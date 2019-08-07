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
import org.kde.ktrip 0.1
import org.kde.kpublictransport 1.0

Kirigami.Page
{
    title: i18nc("@title", "Details")

    property var journey

    Kirigami.CardsListView {

        id: clv

        anchors.fill: parent

        model: journey.sections

        delegate: Loader {
            sourceComponent: modelData.mode == JourneySection.Walking ? walking : card
            property var theData: modelData
        }
    }

    Component {
        id: walking
        Label {
            text: i18np("Walking (%1 minute)", "Walking (%1 minutes)", theData.duration / 60)
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Component {
        id: card

        Kirigami.AbstractCard {
            id: root

            header: Rectangle {
                id: headerBackground
                Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
                Kirigami.Theme.inherit: false
                color: Kirigami.Theme.backgroundColor
                implicitHeight: headerLabel.implicitHeight + Kirigami.Units.largeSpacing * 2
                anchors.leftMargin: -root.leftPadding
                anchors.topMargin: -root.topPadding
                anchors.rightMargin: -root.rightPadding

                Label {
                    id: headerLabel
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.largeSpacing
                    font.pointSize: Kirigami.Theme.defaultFont.pointSize * root.headerFontScale
                    Layout.fillWidth: true
                    font.strikeout: theData.disruptionEffect == Disruption.NoService
                    color: theData.disruptionEffect == Disruption.NoService ? "red" : Kirigami.Theme.textColor
                    text: theData.route.line.name
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
                        color: "red"
                    }

                    Label {
                        text: theData.from.name
                        Layout.fillWidth: true
                        elide: Text.ElideRight
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
                        color: "red"
                    }

                    Label {
                        text: theData.to.name
                        Layout.fillWidth: true
                    }

                    Label {
                        text: theData.scheduledArrivalPlatform

                    }
                }

                Label {
                    text: theData.note
                    wrapMode: Text.Wrap
                }
            }
        }
    }
}


