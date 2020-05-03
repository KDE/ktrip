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
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.4
import org.kde.kirigami 2.0 as Kirigami
import org.kde.ktrip 1.0

Kirigami.Page
{
    id: rootPage

    title: departures ? i18nc("@title", "Query Departures") : i18nc("@title", "Start Journey")

    property bool departures: false

    actions.main: Kirigami.Action {
        icon.name: "nicesicon"
        text: i18nc("@action", "Search")
        enabled: Controller.start.name != "" && (Controller.destination.name != "" || departures)
        onTriggered: pageStack.push(departures ? Qt.resolvedUrl("DeparturesPage.qml") : Qt.resolvedUrl("ConnectionsPage.qml"))
    }

    function startPicked(data) {
        Controller.start = data
    }

    function destinationPicked(data) {
        Controller.destination = data
    }

    ColumnLayout {

        width: parent.width

        Label {
            text: i18n("From:")
        }
        Button {
            Layout.fillWidth: true
            text: Controller.start.name ? Controller.start.name : i18nc("@action:button", "Pick Start")
            onClicked: pageStack.push(Qt.resolvedUrl("LocationQueryPage.qml"), {title: i18nc("@title", "Search for Start Location"), callback: startPicked})
        }

        Label {
            text: i18n("To:")
            visible: !departures
        }
        Button {
            Layout.fillWidth: true
            visible: !departures
            text: Controller.destination.name ? Controller.destination.name : i18nc("@action:button", "Pick Destination")
            onClicked: pageStack.push(Qt.resolvedUrl("LocationQueryPage.qml"), {title: i18nc("@title", "Search for Destination Location"), callback: destinationPicked})
        }

        Label {
            text: i18n("Departure date:")
        }

        DatePickerButton {
            text: Qt.formatDate(Controller.departureDate, Qt.DefaultLocaleShortDate)
            Layout.fillWidth: true
            onDatePicked: {
                if (theDate != "") {
                    Controller.departureDate = theDate
                }
            }
        }

        Label {
            text: i18n("Departure time:")
        }

        TimePickerButton {
            text: Qt.formatTime(Controller.departureTime, Qt.DefaultLocaleShortDate)
            Layout.fillWidth: true
            onTimePicked: {
                if (theTime != "") {
                    Controller.departureTime = theTime
                }
            }
        }
    }
}


