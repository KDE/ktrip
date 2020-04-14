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
import org.kde.kpublictransport 1.0 as KPT

Kirigami.ScrollablePage
{
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
            request: _queryController.createJourneyRequest()
            manager: _manager
        }

        header: ToolButton {
            width: parent.width
            visible: theModel.canQueryPrevious
            onClicked: theModel.queryPrevious()
            icon.name: "arrow-up"
        }

        delegate: Kirigami.AbstractListItem {

            highlighted: false
            onClicked: pageStack.push(Qt.resolvedUrl("ConnectionDetailsPage.qml"), {journey: journey})
            readonly property bool cancelled: {
                var disrupt = false
                journey.sections.forEach(sec => {
                    if (sec.disruptionEffect == KPT.Disruption.NoService) {
                        disrupt = true
                    }
                })
                return disrupt
            }

            RowLayout {
                Label {
                    text: i18n("%1 - %2", journey.sections[0].scheduledDepartureTime.toLocaleTimeString(Locale.ShortFormat), journey.sections[journey.sections.length - 1].scheduledArrivalTime.toLocaleTimeString(Locale.ShortFormat))
                    font.strikeout: cancelled
                }

                Label {
                    text: i18n("(%1)", _formatter.formatDuration(journey.duration))
                    Layout.fillWidth: !delayLabel.visible
                    font.strikeout: cancelled
                }

                Label {
                    id: delayLabel
                    Layout.fillWidth: true
                    visible: journey.sections[journey.sections.length - 1].hasExpectedArrivalTime
                    text: i18n("+%1", journey.sections[journey.sections.length - 1].arrivalDelay)
                    color: journey.sections[journey.sections.length - 1].arrivalDelay > 0 ? "red" : "green"
                    font.strikeout: cancelled
                }

                Label {
                    text: i18np("%1 change", "%1 changes", journey.numberOfChanges)
                    visible: journey.numberOfChanges > 0
                    font.strikeout: cancelled
                }
            }
        }

        footer: ToolButton {
            width: parent.width
            visible: theModel.canQueryNext
            onClicked: theModel.queryNext()
            icon.name: "arrow-down"
        }

        Label {
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

