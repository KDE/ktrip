<!--
    SPDX-FileCopyrightText: 2019-2020 Nicolas Fella <nicolas.fella@gmx.de>
    SPDX-License-Identifier: CC0-1.0
-->

# Summary
KTrip is a public transport assistant targeted towards mobile Linux and Android.

It allows to query journeys for a wide range of countries/public transport providers by leveraging [KPublicTransport](https://cgit.kde.org/kpublictransport.git/).

<a href='https://flathub.org/apps/details/org.kde.ktrip'><img width='190px' alt='Download on Flathub' src='https://flathub.org/assets/badges/flathub-badge-i-en.png'/></a>

# Get it

Nightly [Android APKs](https://community.kde.org/Android/FDroid) and [Windows installers](https://cdn.kde.org/ci-builds/utilities/ktrip/) can be found at KDE's binary factory.

Nightly Flatpak builds are available:

`flatpak remote-add --if-not-exists kdeapps --from https://distribute.kde.org/kdeapps.flatpakrepo`

`flatpak install kdeapps org.kde.ktrip`

# Building

KTrip depends on Qt 6 and a number of KDE Frameworks:
- KCoreAddons
- KI18n
- KConfig
- Kirigami
- KPublicTransport
- kirigami-addons

## Linux

`git clone https://invent.kde.org/utilities/ktrip`

`cd ktrip`

`mkdir build`

`cd build`

`cmake -DCMAKE_INSTALL_PREFIX=/usr ..`

`make`

`sudo make install`

This assumes that all dependencies are installed. If your distribution does not provide them you can use [kdesrc-build](https://kdesrc-build.kde.org/) to build all of them conveniently.

## Android

You can build KTrip for Android using KDE's [Docker-based build environment](https://community.kde.org/Android/Environment_via_Container).

## Windows

You can build KTrip on Windows using KDE's [Craft](https://community.kde.org/Craft).

## macOS and iOS

Running on macOS and iOS should be possible in theory, but is untested. Building on macOS should be possible using KDE's [Craft](https://community.kde.org/Craft). Patches are welcome.
