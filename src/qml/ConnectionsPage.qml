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
import org.kde.kpublictransport 1.0 as KPT

Kirigami.Page
{
    title: i18nc("@title", "Connections")

    header: Kirigami.InlineMessage {
        type: Kirigami.MessageType.Error
        text: theModel.errorMessage
        visible: theModel.errorMessage != ""
    }

    ListView {

        anchors.fill: parent

        model: KPT.JourneyQueryModel {
            id: theModel
            request: _queryController.createJourneyRequest()
            manager: _manager
        }

        header: Button {
            text: i18nc("@action:button", "Earlier")
            width: parent.width
            visible: theModel.canQueryPrevious
            onClicked: theModel.queryPrevious()
        }

        delegate: Kirigami.AbstractListItem {

            onClicked: pageStack.push(Qt.resolvedUrl("ConnectionDetailsPage.qml"), {journey: journey})

            RowLayout {
                Label {
                text: i18n("%1 - %2", journey.sections[0].scheduledDepartureTime.toLocaleTimeString(Locale.ShortFormat), journey.sections[journey.sections.length - 1].scheduledArrivalTime.toLocaleTimeString(Locale.ShortFormat))
                }

                Label {
                    text: i18n("(%1)", _formatter.formatDuration(journey.duration))
                    Layout.fillWidth: !delayLabel.visible
                }

                Label {
                    id: delayLabel
                    Layout.fillWidth: true
                    visible: journey.sections[journey.sections.length - 1].hasExpectedArrivalTime
                    text: i18n("+%1", journey.sections[journey.sections.length - 1].arrivalDelay)
                    color: journey.sections[journey.sections.length - 1].arrivalDelay > 0 ? "red" : "green"
                }

                Label {
                    text: i18np("%1 change", "%1 changes", journey.numberOfChanges)
                    visible: journey.numberOfChanges > 0
                }
            }
        }

        footer: Button {
            text: i18nc("@action:button", "Later")
            width: parent.width
            visible: theModel.canQueryNext
            onClicked: theModel.queryNext()
        }
    }

    BusyIndicator {
        running: theModel.loading
        anchors.centerIn: parent
    }
}

