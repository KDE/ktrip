import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.4
import org.kde.kirigami 2.4 as Kirigami

Button {

    signal datePicked(string theDate)

    onClicked: {
        if (_isAndroid) {
            _androidUtils.showDatePicker()
        }
    }

     Connections {
        target: _androidUtils
        onDatePickerFinished: {
            datePicked(date)
        }
    }
}
