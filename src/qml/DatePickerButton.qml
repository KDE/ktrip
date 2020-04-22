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

    signal datePicked(date theDate)

    onClicked: {
        if (_isAndroid) {
            _androidUtils.showDatePicker()
        } else {
            dialog.open()
        }
    }

     Connections {
        target: _androidUtils
        onDatePickerFinished: {
            datePicked(date)
        }
    }

    Dialog {
        id: dialog
        anchors.centerIn: Overlay.overlay
        height: Kirigami.Units.gridUnit * 6
        contentItem: KDT.DateInput {
            id: picker
        }

        standardButtons: Dialog.Ok | Dialog.Cancel

        onAccepted: datePicked(picker.selectedDate)
    }
}
