/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.4
import org.kde.kirigami 2.12 as Kirigami
import org.kde.kpublictransport 1.0 as KPT
import org.kde.ktrip

Kirigami.ScrollablePage {
    title: i18nc("@title", "Connections")

    header: Kirigami.InlineMessage {
        type: Kirigami.MessageType.Error
        text: theModel.errorMessage
        visible: theModel.errorMessage != ""
    }

    ListView {
        id: connectionList

        model: KPT.JourneyQueryModel {
            id: theModel
            request: Controller.createJourneyRequest()
            manager: Controller.manager
        }

        header: ToolButton {
            width: parent.width
            visible: theModel.canQueryPrevious
            onClicked: theModel.queryPrevious()
            icon.name: "go-up-symbolic"
        }

        delegate: ItemDelegate {

            width: ListView.view.width

            onClicked: pageStack.push(Qt.resolvedUrl("ConnectionDetailsPage.qml"), {
                journey: journey
            })
            readonly property bool cancelled: journey.disruptionEffect == KPT.Disruption.NoService
            readonly property var firstSection: journey.sections[0]
            readonly property var lastSection: journey.sections[journey.sections.length - 1]

            contentItem: Column {

                ConnectionHeading {
                    journey: model.journey
                }

                RowLayout {
                    width: parent.width
                    Label {
                        text: i18n("%1 %2", firstSection.scheduledDepartureTime.toLocaleTimeString(Locale.ShortFormat), firstSection.from.name)
                        font.strikeout: cancelled
                    }

                    Label {
                        visible: firstSection.hasExpectedDepartureTime
                        text: i18n("+%1", firstSection.departureDelay)
                        color: firstSection.departureDelay > 0 ? Kirigami.Theme.negativeTextColor : Kirigami.Theme.positiveTextColor
                        font.strikeout: cancelled
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Label {
                        text: i18np("%1 change", "%1 changes", journey.numberOfChanges)
                        visible: journey.numberOfChanges > 0
                        font.strikeout: cancelled
                        Layout.alignment: Qt.AlignRight
                    }
                }

                RowLayout {
                    width: parent.width
                    Label {
                        text: i18n("%1 %2", lastSection.scheduledArrivalTime.toLocaleTimeString(Locale.ShortFormat), lastSection.to.name)
                        font.strikeout: cancelled
                    }
                    Label {
                        Layout.fillWidth: true
                        visible: lastSection.hasExpectedArrivalTime
                        text: i18n("+%1", lastSection.arrivalDelay)
                        color: lastSection.arrivalDelay > 0 ? Kirigami.Theme.negativeTextColor : Kirigami.Theme.positiveTextColor
                        font.strikeout: cancelled
                    }
                }
            }
        }

        footer: ToolButton {
            width: parent.width
            visible: theModel.canQueryNext
            onClicked: theModel.queryNext()
            icon.name: "go-down-symbolic"
        }

        Kirigami.PlaceholderMessage {
            text: i18n("No connections found")
            anchors.centerIn: parent
            visible: connectionList.count === 0 && !theModel.loading
        }

        BusyIndicator {
            running: theModel.loading
            anchors.centerIn: parent
        }
    }
}
