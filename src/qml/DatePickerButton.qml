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

    KDT.DatePopup {
        id: dialog
        onAccepted: datePicked(selectedDate)
    }
}
