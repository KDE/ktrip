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

    readonly property bool showArrivals: theModel.request.mode === KPublicTransport.StopoverRequest.QueryArrival
    title: root.showArrivals ? i18nc("@title", "Arrivals") : i18nc("@title", "Departures")

    header: Kirigami.InlineMessage {
        type: Kirigami.MessageType.Error
        text: theModel.errorMessage
        visible: theModel.errorMessage != ""
    }

    ListView {
        id: listView
        model: KPublicTransport.StopoverQueryModel {
            id: theModel
            autoUpdate: true
        }

        header: Controls.ToolButton {
            width: parent.width
            visible: theModel.canQueryPrevious
            onClicked: theModel.queryPrevious()
            icon.name: "arrow-up"
        }

        delegate: FormCard.AbstractFormDelegate {
            id: delegate

            required property KPublicTransport.stopover stopover

            width: ListView.view.width

            contentItem: RowLayout {
                spacing: Kirigami.Units.largeSpacing * 2

                ColumnLayout {
                    spacing: Kirigami.Units.smallSpacing

                    Layout.fillWidth: true

                    RowLayout {
                        spacing: Kirigami.Units.smallSpacing

                        KPublicTransport.TransportNameControl {
                            line: delegate.stopover.route.line
                            journeySectionMode: KPublicTransport.JourneySection.PublicTransport
                        }

                        Kirigami.Heading {
                            level: 3
                            text: delegate.stopover.route.direction
                            visible: delegate.stopover.route.direction.length > 0
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }

                    Flow {
                        spacing: Kirigami.Units.smallSpacing

                        Layout.fillWidth: true

                        KPublicTransport.ExpectedTimeLabel {
                            stopover: delegate.stopover
                            delay: root.showArrivals ? delegate.stopover.arrivalDelay : delegate.stopover.departureDelay
                            scheduledTime: Localizer.formatTime(delegate.stopover, root.showArrivals ? "scheduledArrivalTime" : "scheduledDepartureTime")
                            hasExpectedTime: root.showArrivals ? delegate.stopover.hasExpectedArrivalTime : delegate.stopover.hasExpectedDepartureTime
                        }

                        Controls.Label {
                            text: ' · ' +i18nc("@info", "Platform %1", delegate.stopover.hasExpectedPlatform ? delegate.stopover.expectedPlatform : delegate.stopover.scheduledPlatform)
                            color: delegate.stopover.platformChanged ? Kirigami.Theme.negativeTextColor : Kirigami.Theme.textColor
                            visible: delegate.stopover.scheduledPlatform.length > 0

                            Layout.rightMargin: Kirigami.Units.smallSpacing
                        }

                        Repeater {
                            model: delegate.stopover.features
                            delegate: KPublicTransport.FeatureIcon {
                                required property KPublicTransport.feature modelData
                                feature: modelData
                                height: Kirigami.Units.iconSizes.small
                                width: Kirigami.Units.iconSizes.small
                            }
                        }
                    }
                }

                Kirigami.Heading {
                    text: root.showArrivals ?
                        Localizer.formatTimeDifferenceToNow(delegate.stopover, delegate.stopover.hasExpectedArrivalTime ? "expectedArrivalTime" : "scheduledArrivalTime") :
                        Localizer.formatTimeDifferenceToNow(delegate.stopover, delegate.stopover.hasExpectedDepartureTime ? "expectedDepartureTime" : "scheduledDepartureTime")
                }
            }

            background.children: Kirigami.Separator {
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
            }

            onClicked: {
                detailsDialog.stopover = delegate.stopover;
                if (detailsDialog.hasContent)
                    detailsDialog.open();
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

        Kirigami.PlaceholderMessage {
            anchors.fill: parent
            text: root.showArrivals ? i18n("No arrivals found.") : i18n("No departures found.")
            visible: listView.count === 0 && !theModel.loading && theModel.errorMessage === ""
        }
    }

    Controls.Dialog {
        id: detailsDialog
        parent: Controls.ApplicationWindow.window.Controls.Overlay.overlay

        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)

        width: Math.min(parent.width - Kirigami.Units.gridUnit * 4, Kirigami.Units.gridUnit * 30)
        height: Math.min(parent.height - Kirigami.Units.gridUnit * 4, implicitHeight)

        property alias stopover: infoView.stopover
        property alias hasContent: infoView.hasContent
        contentItem: Controls.ScrollView {
            id: detailScrollView
            Controls.ScrollBar.horizontal.policy: Controls.ScrollBar.AlwaysOff
            KPublicTransport.StopoverInformationView {
                id: infoView
                width: detailScrollView.width - detailScrollView.effectiveScrollBarWidth
            }
        }
    }
}
