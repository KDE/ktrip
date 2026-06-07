#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Volker Krause <vkrause@kde.org>
# SPDX-License-Identifier: BSD-2-Clause

import json
import os
import subprocess
import sys
import time
import yaml

if __name__ == '__main__':
    env = os.environ

    if 'KDE_FLATPAK_TEST_COMMAND' not in os.environ:
        print("No test command specified, skipping.")
        sys.exit(0)

    # find the Flatpak manifest, and read the app id from it
    # (same logic as in flatpak-build.py)
    # manifestfile = ".flatpak-manifest"
    # if 'KDE_FLATPAK_MANIFEST_FILE' in os.environ:
    #     manifestfile = os.environ['KDE_FLATPAK_MANIFEST_FILE']
    # if os.path.exists(f"{manifestfile}.yml"):
    #     manifestfile = f"{manifestfile}.yml"
    # elif os.path.exists(f"{manifestfile}.yaml"):
    #     manifestfile = f"{manifestfile}.yaml"
    # else:
    #     manifestfile = f"{manifestfile}.json"
    #
    # f = open(manifestfile, "r")
    # if manifestfile.endswith(".json"):
    #     manifest = json.load(f)
    # else:
    #     manifest = yaml.safe_load(f)
    #
    # try:
    #     app_id = manifest["app-id"]
    # except KeyError:
    #     app_id = manifest["id"]
    # print(f"Testing Flatpak {app_id}")

    # set up D-Bus and Xvfb
    # (same general approach as done for CI tests)
    print("### Environment setup…")
    env['DISPLAY'] = ':90'
    xvfbProcess = subprocess.Popen("Xvfb :90 -ac -screen 0 1600x1200x24+32", stdout=open(os.devnull, 'w'), stderr=subprocess.STDOUT, shell=True)
    time.sleep(5)

    wmProcess = subprocess.Popen("openbox", stdout=sys.stdout, stderr=sys.stderr, shell=True, env=env)

    process = subprocess.Popen("dbus-launch", shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    process.wait()
    for variable in process.stdout:
        line = str(variable, 'utf-8')
        splitVars = line.split('=', 1)
        env[splitVars[0]] = splitVars[1].strip()

    for (key, value) in env.items():
        print(f"{key}={value}")

    print("### Running test…")
    testProcess = subprocess.Popen(os.environ['KDE_FLATPAK_TEST_COMMAND'], stdout=sys.stdout, stderr=sys.stderr, shell=True, env=env)
    testProcess.wait()
    print(f"### Test finished with exit code {testProcess.returncode}!")

    wmProcess.terminate()
    xvfbProcess.terminate()

    sys.exit(testProcess.returncode)
