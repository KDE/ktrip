/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard
import org.kde.kpublictransport.ui as PublicTransport
import org.kde.ktrip

FormCard.FormCardPage {
    id: root

    property bool departures: false
    property var departureStop
    property var arrivalStop

    /** Pre-selected departure time. */
    property date initialDateTime: new Date()

    /**
     * Pre-selected country in the location pickers.
     * If not specified the country from the current locale is used.
     */
    property string initialCountry: Qt.locale().name.match(/_([A-Z]{2})/)[1]

    readonly property PublicTransport.Manager publicTransportManager: Controller.manager

    title: departures ? i18nc("@title", "Query Departures") : i18nc("@title", "Start Journey")

    header: Kirigami.InlineMessage {
        id: noProvidersMessage
        text: i18n("No providers enabled")
        visible: Controller.manager.enabledBackends.length === 0
        type: Kirigami.MessageType.Warning
        position: Kirigami.InlineMessage.Header
        actions: Controls.Action {
            text: i18n("Configure providers")
            icon.name: "configure"
            onTriggered: window.pageStack.push(Qt.resolvedUrl("BackendPage.qml"))
        }
    }

    // either true/false if all mode switches are in that position, undefined otherwise
    function fullModeSwitchState() {
        let state = longDistanceSwitch.checked;
        for (const s of [localTrainSwitch, rapidTransitSwitch, busSwitch, ferrySwitch]) {
            if (s.checked != state) {
                return undefined;
            }
        }
        return state;
    }

    Component {
        id: departurePicker
        PublicTransport.StopPickerPage {
            title: i18nc("departure train station", "Select Departure Stop")
            publicTransportManager: root.publicTransportManager
            initialCountry: root.initialCountry
            // force a deep copy, otherwise this breaks as soon as the other stop picker page is shown...
            onLocationChanged: root.departureStop = Controller.copyLocation(location)
            historySortRoleName: KTripSettings.historySortMode
            onHistorySortRoleChanged: KTripSettings.historySortMode = sortRoleName
        }
    }

    Component {
        id: arrivalPicker
        PublicTransport.StopPickerPage {
            title: i18nc("arrival train station", "Select Arrival Stop")
            publicTransportManager: root.publicTransportManager
            initialCountry: root.initialCountry
            onLocationChanged: root.arrivalStop = Controller.copyLocation(location)
            historySortRoleName: KTripSettings.historySortMode
            onHistorySortRoleChanged: KTripSettings.historySortMode = sortRoleName
        }
    }

    FormCard.FormCard {
        id: requestCard

        Layout.topMargin: Kirigami.Units.largeSpacing * 2

        FormCard.FormButtonDelegate {
            id: fromButton

            text: i18nc("departure train station", "From:")
            description: departureStop ? departureStop.name : i18nc("departure train station", "Select Departure Stop")
            onClicked: applicationWindow().pageStack.push(departurePicker)
        }

        FormCard.FormDelegateSeparator {
            below: fromButton
            above: toButton
            visible: !root.departures
        }

        FormCard.FormButtonDelegate {
            id: toButton

            visible: !root.departures
            text: i18nc("arrival train station", "To:")
            description: arrivalStop ? arrivalStop.name : i18nc("arrival train station", "Select Arrival Stop")
            onClicked: applicationWindow().pageStack.push(arrivalPicker)
        }

        Item {
            width: parent.width
            height: 0

            visible: !root.departures

            Controls.RoundButton {
                icon.name: "reverse"
                y: -fromButton.height - height / 2
                z: toButton.z + 10000
                x: fromButton.width - width / 2 - Kirigami.Units.gridUnit * 3
                onClicked: {
                    var oldDepartureStop = departureStop;
                    departureStop = arrivalStop;
                    arrivalStop = oldDepartureStop;
                }

                Accessible.name: i18n("Swap departure and arrival")
            }
        }
        FormCard.FormDelegateSeparator {
            below: !root.departures ? fromButton : toButton
            above: departureArrivalSelector
        }

        FormCard.FormRadioSelectorDelegate {
            id: departureArrivalSelector

            consistentWidth: true

            actions: [
                Kirigami.Action {
                    text: i18nc("train or bus departure", "Departure")
                },
                Kirigami.Action {
                    text: i18nc("train or bus arrival", "Arrival")
                }
            ]
        }

        FormCard.FormDelegateSeparator {
            below: departureArrivalSelector
            above: dateTimeInput
        }

        FormCard.FormDateTimeDelegate {
            id: dateTimeInput
            value: root.initialDateTime
            Accessible.name: departureArrivalSelector.selectedIndex === 0 ? i18nc("train or bus departure", "Departure time") : i18nc("train or bus arrival", "Arrival time")
        }

        FormCard.FormDelegateSeparator {
            below: dateTimeInput
            above: searchButton
        }

        FormCard.FormButtonDelegate {
            id: searchButton
            icon.name: "system-search-symbolic"
            text: root.departures ?  i18nc("@action:button", "Search Departures") : i18nc("@action:button", "Search Journey")
            enabled: root.departureStop != undefined && (root.arrivalStop != undefined || root.departures) && root.fullModeSwitchState() !== false
            onClicked: {
                Controls.ApplicationWindow.window.pageStack.push(root.departures ? Qt.resolvedUrl("DeparturesPage.qml") : Qt.resolvedUrl("ConnectionsPage.qml"), {
                    manager: root.publicTransportManager
                });

                const req = Controls.ApplicationWindow.window.pageStack.currentItem.journeyRequest;
                if (!root.departures) {
                    req.from = root.departureStop;
                    req.to = root.arrivalStop;
                    req.dateTimeMode = departureArrivalSelector.selectedIndex === 0 ? PublicTransport.JourneyRequest.Departure : PublicTransport.JourneyRequest.Arrival;
                    req.includePaths = true;
                    req.maximumResults = 6;
                } else {
                    req.stop = root.departureStop;
                    req.mode = departureArrivalSelector.selectedIndex === 0 ? PublicTransport.StopoverRequest.QueryDeparture : PublicTransport.StopoverRequest.QueryArrival;
                    req.maximumResults = 12;
                }

                req.dateTime = dateTimeInput.value;
                req.downloadAssets = true;

                let lineModes = [];
                if (root.fullModeSwitchState() == undefined) {
                    if (longDistanceSwitch.checked)
                        lineModes.push(PublicTransport.Line.LongDistanceTrain, PublicTransport.Line.Train);
                    if (localTrainSwitch.checked)
                        lineModes.push(PublicTransport.Line.LocalTrain);
                    if (rapidTransitSwitch.checked)
                        lineModes.push(PublicTransport.Line.RapidTransit, PublicTransport.Line.Metro, PublicTransport.Line.Tramway, PublicTransport.Line.RailShuttle);
                    if (busSwitch.checked)
                        lineModes.push(PublicTransport.Line.Bus, PublicTransport.Line.Coach);
                    if (ferrySwitch.checked)
                        lineModes.push(PublicTransport.Line.Ferry, PublicTransport.Line.Boat);
                }
                req.lineModes = lineModes;

                console.log(req);

                Controls.ApplicationWindow.window.pageStack.currentItem.journeyRequest = req;
            }
        }
    }

    FormCard.FormHeader {
        title: i18n("Mode of transportation")
    }

    FormCard.FormCard {
        FormCard.FormSwitchDelegate {
            id: longDistanceSwitch
            text: i18nc("journey query search constraint, title", "Long distance trains")
            description: i18nc("journey query search constraint, description", "High speed or intercity trains")
            checked: true
            leading: Kirigami.Icon {
                source: PublicTransport.LineMode.iconName(PublicTransport.Line.LongDistanceTrain)
                isMask: true
            }
        }
        FormCard.FormSwitchDelegate {
            id: localTrainSwitch
            text: i18nc("journey query search constraint, title", "Local trains")
            description: i18nc("journey query search constraint, description", "Regional or local trains")
            checked: true
            leading: Kirigami.Icon {
                source: PublicTransport.LineMode.iconName(PublicTransport.Line.LocalTrain)
                isMask: true
            }
        }
        FormCard.FormSwitchDelegate {
            id: rapidTransitSwitch
            text: i18nc("journey query search constraint, title", "Rapid transit")
            description: i18nc("journey query search constraint, description", "Rapid transit, metro, trams")
            checked: true
            leading: Kirigami.Icon {
                source: PublicTransport.LineMode.iconName(PublicTransport.Line.Tramway)
                isMask: true
            }
        }
        FormCard.FormSwitchDelegate {
            id: busSwitch
            text: i18nc("journey query search constraint, title", "Bus")
            description: i18nc("journey query search constraint, description", "Local or regional bus services")
            checked: true
            leading: Kirigami.Icon {
                source: PublicTransport.LineMode.iconName(PublicTransport.Line.Bus)
                isMask: true
            }
        }
        FormCard.FormSwitchDelegate {
            id: ferrySwitch
            text: i18nc("journey query search constraint, title", "Ferry")
            description: i18nc("journey query search constraint, description", "Boats or ferries")
            checked: true
            leading: Kirigami.Icon {
                source: PublicTransport.LineMode.iconName(PublicTransport.Line.Ferry)
                isMask: true
            }
        }
    }
}
