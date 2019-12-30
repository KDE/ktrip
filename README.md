# Summary
KTrip is a public transport assistant targeted towards mobile Linux and Android.

It allows to query journeys for a wide range of countries/public transport providers by leveraging [KPublicTransport](https://cgit.kde.org/kpublictransport.git/).

# Get it

Nightly Android APKs can be found at [KDE's binary factory](https://binary-factory.kde.org/view/Android/job/KTrip_android/).

Nightly Windows installers can be found at [KDE's binary factory](https://binary-factory.kde.org/view/Windows%2064-bit/job/KTrip_Nightly_win64/)

# Building

KTrip depends on Qt 5 and a number of KDE Frameworks:
- KCoreAddons
- KI18n
- KConfig
- KItemModels
- Kirigami
- KPublicTransport

## Linux

`git clone https://invent.kde.org/kde/ktrip`

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