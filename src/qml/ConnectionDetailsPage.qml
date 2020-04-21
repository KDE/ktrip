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
import org.kde.kirigami 2.4 as Kirigami
import org.kde.kpublictransport 1.0
import org.kde.ktrip 1.0

Kirigami.ScrollablePage
{
    id: root
    title: i18nc("@title", "Details")

    property var journey

    Kirigami.CardsListView {
        model: root.journey.sections

        delegate: Loader {
            sourceComponent: {
                switch(model.modelData.mode) {
                    case JourneySection.Walking: return walking
                    case JourneySection.Waiting: return waiting
                    case JourneySection.Transfer: return transfer
                    default: return cardComponent
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
                }

                Item {
                    width: 1
                    height: cardDelegate.topPadding
                }

                Kirigami.Separator {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: -cardDelegate.leftPadding
                    anchors.rightMargin: -cardDelegate.rightPadding
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
                    }

                    Button {
                        visible: theData.from.hasCoordinate
                        icon.name: "map-symbolic"
                        flat: true
                        onClicked: Controller.showOnMap(theData.from)
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Label {
                        text: theData.scheduledDeparturePlatform
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
                        Component.onCompleted: {
                            console.log("Geo", theData.to.latitude, theData.to.longitude)
                        }
                        text: theData.to.name
                        wrapMode: Text.Wrap
                    }

                    Button {
                        visible: theData.to.hasCoordinate
                        icon.name: "map-symbolic"
                        flat: true
                        onClicked: Controller.showOnMap(theData.to)
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Label {
                        text: theData.scheduledArrivalPlatform
                    }
                }

                Label {
                    text: theData.notes.join("<br>")
                    topPadding: Kirigami.Units.largeSpacing
                    width: parent.width
                    wrapMode: Text.Wrap
                }
            }
        }
    }
}
