/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
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

        standardButtons: Dialog.Ok | Dialog.Cancel

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
