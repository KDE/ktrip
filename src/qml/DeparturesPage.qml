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
import org.kde.ktrip 1.0

Kirigami.ScrollablePage {
    title: i18nc("@title", "Departures")

    header: Kirigami.InlineMessage {
        type: Kirigami.MessageType.Error
        position: Kirigami.InlineMessage.Header
        text: theModel.errorMessage
        visible: theModel.errorMessage != ""
    }

    ListView {

        model: KPT.StopoverQueryModel {
            id: theModel
            request: Controller.createStopoverRequest()
            manager: Manager
        }

        delegate: ItemDelegate {

            width: ListView.view.width

            contentItem: RowLayout {
                Label {
                    text: i18n("%3 %1 (%2)", departure.route.line.name, departure.route.direction, Formatter.formatTime(departure.scheduledDepartureTime))
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
