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
