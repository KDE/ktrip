/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import org.kde.kpublictransport as KPT
import org.kde.ktrip

Kirigami.ScrollablePage {
    title: i18nc("@title", "Connections")

    /** The journey to query for. */
    property alias journeyRequest: journeyModel.request
    property alias manager: journeyModel.manager

    header: Kirigami.InlineMessage {
        type: Kirigami.MessageType.Error
        text: journeyModel.errorMessage
        visible: journeyModel.errorMessage.length > 0
        position: Kirigami.InlineMessage.Header
    }

    ListView {
        id: connectionList

        model: KPT.JourneyQueryModel {
            id: journeyModel
        }

        header: ToolButton {
            width: parent.width
            visible: journeyModel.canQueryPrevious
            onClicked: journeyModel.queryPrevious()
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
            visible: journeyModel.canQueryNext
            onClicked: journeyModel.queryNext()
            icon.name: "go-down-symbolic"
        }

        Kirigami.PlaceholderMessage {
            text: i18n("No connections found")
            anchors.centerIn: parent
            visible: connectionList.count === 0 && !journeyModel.loading
        }

        BusyIndicator {
            running: journeyModel.loading
            anchors.centerIn: parent
        }
    }
}
