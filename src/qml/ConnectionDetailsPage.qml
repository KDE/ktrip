/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import org.kde.kpublictransport
import org.kde.kpublictransport.ui
import org.kde.ktrip

Kirigami.ScrollablePage {
    id: root
    title: i18nc("@title", "Details")

    property var journey

    Kirigami.CardsListView {
        model: root.journey.sections

        delegate: Loader {
            width: parent.width

            sourceComponent: {
                switch (model.modelData.mode) {
                case JourneySection.Walking:
                    return walking;
                case JourneySection.Waiting:
                    return waiting;
                case JourneySection.Transfer:
                    return transfer;
                default:
                    return cardComponent;
                }
            }
            property var theData: model.modelData
        }
    }

    Component {
        id: walking
        Label {
            text: i18np("Walking (%1 minute)", "Walking (%1 minutes)", theData.duration / 60)
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Component {
        id: waiting
        Label {
            text: i18np("Waiting (%1 minute)", "Waiting (%1 minutes)", theData.duration / 60)
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Component {
        id: transfer
        Label {
            text: i18np("Transfer (%1 minute)", "Transfer (%1 minutes)", theData.duration / 60)
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Component {
        id: cardComponent

        Kirigami.AbstractCard {
            id: cardDelegate

            header: Column {

                RowLayout {
                    width: parent.width
                    Kirigami.Icon {
                        visible: theData.route.line.hasLogo
                        source: theData.route.line.logo
                        Layout.fillHeight: true
                        Layout.preferredWidth: height
                    }

                    Kirigami.Heading {
                        id: headerLabel
                        level: 4
                        font.strikeout: theData.disruptionEffect == Disruption.NoService
                        color: theData.disruptionEffect == Disruption.NoService ? Kirigami.Theme.negativeTextColor : Kirigami.Theme.textColor
                        text: theData.route.line.name
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Button {
                        icon.name: intermediateStops.expanded ? "collapse" : "expand"
                        text: intermediateStops.expanded ? i18n("Hide intermediate Stops") : i18n("Show intermediate Stops")
                        display: Button.IconOnly
                        flat: true
                        Layout.preferredWidth: height // Work around Material button being too wide
                        onClicked: intermediateStops.expanded = !intermediateStops.expanded
                    }
                }

                Item {
                    width: 1
                    height: cardDelegate.topPadding
                }

                Kirigami.Separator {
                    anchors.left: parent.left
                    anchors.right: parent.right
                }
            }

            contentItem: Column {
                id: topLayout

                RowLayout {
                    width: parent.width
                    Label {
                        text: theData.scheduledDepartureTime.toLocaleTimeString(Locale.ShortFormat)
                    }

                    Label {
                        text: theData.expectedDepartureTime.toLocaleTimeString(Locale.ShortFormat)
                        visible: theData.departureDelay > 0
                        color: Kirigami.Theme.negativeTextColor
                    }

                    Label {
                        text: theData.from.name
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }

                    Button {
                        visible: theData.from.hasCoordinate
                        icon.name: "mark-location-symbolic"
                        flat: true
                        Layout.preferredWidth: height // Work around Material button being too wide
                        onClicked: Controller.showOnMap(theData.from)
                    }

                    Label {
                        text: theData.scheduledDeparturePlatform
                    }
                }

                Repeater {
                    id: intermediateStops

                    property var expanded: false
                    model: theData.intermediateStops

                    delegate: RowLayout {
                        visible: intermediateStops.expanded
                        width: parent.width

                        Item {
                            width: 3 * Kirigami.Units.largeSpacing
                        }

                        Label {
                            text: modelData.scheduledDepartureTime.toLocaleTimeString(Locale.ShortFormat)
                        }

                        Label {
                            text: modelData.expectedDepartureTime.toLocaleTimeString(Locale.ShortFormat)
                            visible: modelData.departureDelay > 0
                            color: Kirigami.Theme.negativeTextColor
                        }

                        Label {
                            text: modelData.stopPoint.name
                            wrapMode: Text.Wrap
                            Layout.fillWidth: true
                        }

                        Label {
                            text: modelData.scheduledPlatform
                        }
                    }
                }

                RowLayout {
                    width: parent.width
                    Label {
                        text: theData.scheduledArrivalTime.toLocaleTimeString(Locale.ShortFormat)
                    }

                    Label {
                        text: theData.expectedArrivalTime.toLocaleTimeString(Locale.ShortFormat)
                        visible: theData.arrivalDelay > 0
                        color: Kirigami.Theme.negativeTextColor
                    }

                    Label {
                        text: theData.to.name
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }

                    Button {
                        visible: theData.to.hasCoordinate
                        icon.name: "mark-location-symbolic"
                        flat: true
                        Layout.preferredWidth: height // Work around Material button being too wide
                        onClicked: Controller.showOnMap(theData.to)
                    }

                    Label {
                        text: theData.scheduledArrivalPlatform
                    }
                }

                RowLayout {
                    visible: !intermediateStops.expanded
                    Repeater {
                        model: theData.features
                        delegate: FeatureIcon {
                            required property feature modelData
                            feature: modelData
                            Layout.preferredHeight: Kirigami.Units.iconSizes.small
                            Layout.preferredWidth: Kirigami.Units.iconSizes.small
                        }
                    }
                }
                Repeater {
                    model: intermediateStops.expanded ? theData.features : null
                    delegate: FeatureDelegate {
                        required property feature modelData
                        feature: modelData
                        Layout.fillWidth: true
                    }
                }

                Label {
                    text: theData.notes.join("<br>")
                    onLinkActivated: link => Qt.openUrlExternally(link)
                    topPadding: Kirigami.Units.largeSpacing
                    width: parent.width
                    wrapMode: Text.Wrap
                }
            }
        }
    }
}
