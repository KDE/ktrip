/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.4
import org.kde.kirigami 2.4 as Kirigami
import org.kde.kpublictransport 1.0 as KPT
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
        model: KPT.StopoverQueryModel {
            id: theModel
        }

        delegate: ItemDelegate {

            width: ListView.view.width

            contentItem: RowLayout {
                Label {
                    text: i18n("%3 %1 (%2)", departure.route.line.name, departure.route.direction, departure.scheduledDepartureTime.toLocaleTimeString(Locale.ShortFormat))
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
                Label {
                    text: departure.scheduledPlatform
                }
            }
        }

        footer: ToolButton {
            width: parent.width
            visible: theModel.canQueryNext
            onClicked: theModel.queryNext()
            icon.name: "arrow-down"
        }

        BusyIndicator {
            running: theModel.loading
            anchors.centerIn: parent
        }
    }
}
