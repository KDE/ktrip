/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.4
import org.kde.kirigami 2.12 as Kirigami
import org.kde.kpublictransport 1.0 as KPT
import org.kde.ktrip 1.0

Kirigami.ScrollablePage
{
    property bool showCached: true
    property var callback

    header: Kirigami.SearchField {
        id: queryTextField

        visible: Manager.enabledBackends.length !== 0
        width: parent.width
        onAccepted: {
            queryModel.request = Controller.createLocationRequest(text)
            showCached = false
        }
    }

    ListView {
        id: locationView
        model: showCached ? cacheModel : queryModel

        delegate: Kirigami.BasicListItem {
            visible: Manager.enabledBackends.length !== 0
            text: location.name
            highlighted: false
            reserveSpaceForIcon: false
            onClicked: {
                cacheModel.addCachedLocation(location)
                callback(location)
                pageStack.pop()
            }
        }

        Kirigami.PlaceholderMessage {
            text: i18n("No locations found")
            visible: locationView.count === 0 && !queryModel.loading
            anchors.centerIn: parent
        }

        Kirigami.PlaceholderMessage {
            text: i18n("No providers enabled")
            visible: Manager.enabledBackends.length === 0
            helpfulAction: Action {
                text: i18n("Configure providers")
                icon.name: "configure"
                onTriggered: window.pageStack.push(Qt.resolvedUrl("BackendPage.qml"))
            }
            anchors.centerIn: parent
        }

        BusyIndicator {
            running: queryModel.loading
            anchors.centerIn: parent
        }

        KPT.LocationQueryModel {
            id: queryModel
            manager: Manager
        }

        LocationCacheModel {
            id: cacheModel
        }
    }
}
