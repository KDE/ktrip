/**
 * Copyright 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
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
                onTriggered: {
                    window.pageStack.clear()
                    window.pageStack.push(Qt.resolvedUrl("QueryPage.qml"), {departures: false})
                }
            },
            Kirigami.Action {
                text: i18n("Departures")
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
                onTriggered: window.pageStack.push(Qt.resolvedUrl("BackendPage.qml"))
            },
            Kirigami.Action {
                text: i18n("About")
                onTriggered: window.pageStack.layers.push(aboutPage)
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
