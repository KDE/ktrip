import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.4
import org.kde.kirigami 2.4 as Kirigami

Button {

    signal timePicked(string theTime)

    onClicked: {
        if (_isAndroid) {
            _androidUtils.showTimePicker()
        }
    }

     Connections {
        target: _androidUtils
        onTimePickerFinished: {
            timePicked(time)
        }
    }
}
