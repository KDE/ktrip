/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.4
import org.kde.kirigami 2.0 as Kirigami
import org.kde.ktrip 1.0

Kirigami.Page {
    id: root

    title: departures ? i18nc("@title", "Query Departures") : i18nc("@title", "Start Journey")

    property bool departures: false

    actions: [
        Kirigami.Action {
            icon.name: "system-search-symbolic"
            text: i18nc("@action", "Search")
            enabled: Controller.start.name != "" && (Controller.destination.name != "" || root.departures)
            onTriggered: pageStack.push(root.departures ? Qt.resolvedUrl("DeparturesPage.qml") : Qt.resolvedUrl("ConnectionsPage.qml"))
        }
    ]

    function startPicked(data) {
        Controller.start = data;
    }

    function destinationPicked(data) {
        Controller.destination = data;
    }

    ColumnLayout {

        width: parent.width

        Label {
            text: i18n("From:")
        }
        Button {
            Layout.fillWidth: true
            text: Controller.start.name ? Controller.start.name : i18nc("@action:button", "Pick Start")
            onClicked: pageStack.push(Qt.resolvedUrl("LocationQueryPage.qml"), {
                title: i18nc("@title", "Search for Start Location"),
                callback: root.startPicked
            })
        }

        Label {
            text: i18n("To:")
            visible: !root.departures
        }
        Button {
            Layout.fillWidth: true
            visible: !root.departures
            text: Controller.destination.name ? Controller.destination.name : i18nc("@action:button", "Pick Destination")
            onClicked: pageStack.push(Qt.resolvedUrl("LocationQueryPage.qml"), {
                title: i18nc("@title", "Search for Destination Location"),
                callback: root.destinationPicked
            })
        }

        Label {
            text: i18n("Departure date:")
        }

        DatePickerButton {
            text: Qt.formatDate(Controller.departureDate, Qt.DefaultLocaleShortDate)
            Layout.fillWidth: true
            onDatePicked: theDate => {
                if (theDate != "") {
                    Controller.departureDate = theDate;
                }
            }
        }

        Label {
            text: i18n("Departure time:")
        }

        TimePickerButton {
            text: Qt.formatTime(Controller.departureTime, Qt.DefaultLocaleShortDate)
            Layout.fillWidth: true
            onTimePicked: theTime => {
                if (theTime != "") {
                    Controller.departureTime = theTime;
                }
            }
        }
    }
}
