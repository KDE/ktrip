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
import org.kde.kpublictransport.ui as KPublicTransport
import org.kde.ktrip

Kirigami.ScrollablePage {
    id: root

    /** The journey to query for. */
    property alias journeyRequest: theModel.request
    property alias manager: theModel.manager

    title: i18nc("@title", "Departures")

    header: Kirigami.InlineMessage {
        type: Kirigami.MessageType.Error
        text: theModel.errorMessage
        visible: theModel.errorMessage != ""
    }

    ListView {
        model: KPublicTransport.StopoverQueryModel {
            id: theModel
        }

        delegate: FormCard.AbstractFormDelegate {
            id: delegate

            required property KPublicTransport.stopover departure

            width: ListView.view.width

            contentItem: RowLayout {
                spacing: Kirigami.Units.largeSpacing * 2

                ColumnLayout {
                    spacing: Kirigami.Units.smallSpacing

                    Layout.fillWidth: true

                    RowLayout {
                        spacing: Kirigami.Units.smallSpacing

                        KPublicTransport.TransportNameControl {
                            line: delegate.departure.route.line
                            journeySectionMode: KPublicTransport.JourneySection.PublicTransport
                        }

                        Kirigami.Heading {
                            level: 3
                            text: delegate.departure.route.direction
                            visible: delegate.departure.route.direction.length > 0
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }

                    Flow {
                        spacing: 0

                        Layout.fillWidth: true

                        DelayRow {
                            stopover: delegate.departure
                            delay: delegate.departure.departureDelay
                            originalTime: Localizer.formatTime(delegate.departure, "scheduledDepartureTime")
                        }

                        Controls.Label {
                            text: ' · ' +i18nc("@info", "Platform %1", delegate.departure.hasExpectedPlatform ? delegate.departure.expectedPlatform : delegate.departure.scheduledPlatform)
                            color: delegate.departure.platformChanged ? Kirigami.Theme.negativeTextColor : Kirigami.Theme.textColor
                            visible: delegate.departure.scheduledPlatform.length > 0

                            Layout.rightMargin: Kirigami.Units.smallSpacing
                        }

                        Repeater {
                            model: delegate.departure.features
                            delegate: KPublicTransport.FeatureIcon {
                                required property KPublicTransport.feature modelData
                                feature: modelData
                                Layout.preferredHeight: Kirigami.Units.iconSizes.small
                                Layout.preferredWidth: Kirigami.Units.iconSizes.small
                            }
                        }
                    }
                }

                Kirigami.Heading {
                    text: Localizer.formatTimeDifferenceToNow(delegate.departure, delegate.departure.hasExpectedDepartureTime ? "expectedDepartureTime" : "scheduledDepartureTime")
                }
            }

            background.children: Kirigami.Separator {
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
            }
        }

        footer: Controls.ToolButton {
            width: parent.width
            visible: theModel.canQueryNext
            onClicked: theModel.queryNext()
            icon.name: "arrow-down"
        }

        Controls.BusyIndicator {
            running: theModel.loading
            anchors.centerIn: parent
        }
    }
}
