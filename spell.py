#!/usr/bin/env python3

# SPDX-FileCopyrightText: None
# SPDX-License-Identifier: CC0-1.0

import json

warnings = []

warning = {
    "type": "issue",
    "description": "Test",#match.group(5),
    "categories": ["Bug Risk"], # TODO
    "location": {
        "path": "src/main.cpp",
        "lines": {
            "begin": 0
        }
    },
    "fingerprint": 1
}

warning2 = {
    "type": "issue",
    "description": "Test 2",#match.group(5),
    "categories": ["Bug Risk"], # TODO
    "location": {
        "path": "src/main.cpp",
        "lines": {
            "begin": 0
        }
    },
    "fingerprint": 2
}

warnings.append(warning)
warnings.append(warning2)

f = open("report.json", "w")
f.write(json.dumps(warnings))
f.close()
