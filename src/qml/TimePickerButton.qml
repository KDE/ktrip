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
import QtQuick.Controls 2.5
import org.kde.kirigami 2.4 as Kirigami

import org.kde.kirigamiaddons.dateandtime 0.1 as KDT

Button {

    signal timePicked(date theTime)

    onClicked: {
        if (_isAndroid) {
            _androidUtils.showTimePicker()
        } else {
            dialog.open()
        }
    }

     Connections {
        target: _androidUtils
        onTimePickerFinished: {
            timePicked(time)
        }
    }

    Dialog {
        id: dialog
        anchors.centerIn: Overlay.overlay
        contentItem: KDT.TimePicker {
            id: picker
            implicitWidth: 300
            implicitHeight: 300
        }

        footer: RowLayout {
            Button {
                text: i18nc("@action:button", "Cancel")
                Layout.fillWidth: true
                onClicked: dialog.reject()
            }
            Button {
                text: i18nc("@action:button", "Accept")
                Layout.fillWidth: true
                onClicked: dialog.accept()
            }
        }

        onAccepted: {
            var hours = picker.hours

            if (picker.pm && hours != 12) {
                hours += 12
            }
            var d = new Date()
            d.setHours(hours)
            d.setMinutes(picker.minutes)
            timePicked(d)
        }
    }
}
