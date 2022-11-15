/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.2
import QtQuick.Controls 2.4
import org.kde.kirigami 2.6 as Kirigami
import org.kde.ktrip 1.0

Kirigami.ApplicationWindow
{
    id: window
    width: 480
    height: 720

    pageStack.initialPage: Qt.resolvedUrl("QueryPage.qml")

    Component.onCompleted: {
        if (Settings.firstRun) {
            window.pageStack.push(Qt.resolvedUrl("BackendPage.qml"))
            Settings.firstRun = false
            Settings.save()
        }
    }

    globalDrawer: Kirigami.GlobalDrawer {
        isMenu: true
        actions: [
            Kirigami.Action {
                text: i18n("Journey")
                icon.name: "globe"
                onTriggered: {
                    window.pageStack.clear()
                    window.pageStack.push(Qt.resolvedUrl("QueryPage.qml"), {departures: false})
                }
            },
            Kirigami.Action {
                text: i18n("Departures")
                icon.name: "arrow-right-double"
                onTriggered: {
                    window.pageStack.clear()
                    window.pageStack.push(Qt.resolvedUrl("QueryPage.qml"), {departures: true})
                }
            },
            Kirigami.Action {
                separator: true
            },
            Kirigami.Action {
                text: i18n("Providers")
                icon.name: "settings-configure"
                onTriggered: window.pageStack.push(Qt.resolvedUrl("BackendPage.qml"))
            },
            Kirigami.Action {
                text: i18n("About KTrip")
                // TODO add help-about icon when other actions have icons too
                icon.name: "help-about"
                onTriggered: {
                    if (window.pageStack.layers.depth < 2) {
                        window.pageStack.layers.push(aboutPage)
                    }
                }
            }
        ]
    }

    Component {
        id: aboutPage
        Kirigami.AboutPage {
            aboutData: _aboutData
        }
    }
}
