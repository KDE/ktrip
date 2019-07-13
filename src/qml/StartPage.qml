import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.4
import org.kde.kirigami 2.0 as Kirigami

Kirigami.Page
{
    id: rootPage
    property var start;

    title: "Start journey"

    actions.main: Kirigami.Action {
        icon.name: "search"
        text: "Search"
        onTriggered: pageStack.push(Qt.resolvedUrl("ConnectionsPage.qml"))
    }

    ColumnLayout {

        width: parent.width

        Label {
            text: "From:"
        }
        Button {
            Layout.fillWidth: true
            text: _queryController.start.name ? _queryController.start.name : "Pick start"
            onClicked: pageStack.push(Qt.resolvedUrl("LocationQueryPage.qml"), {type: "start"})
        }
        Label {
            text: "To:"
        }
        Button {
            Layout.fillWidth: true
            text: _queryController.start.name ? _queryController.destination.name : "Pick destination"
            onClicked: pageStack.push(Qt.resolvedUrl("LocationQueryPage.qml"), {type: "destination"})
        }

        Label {
            text: "Departure date:"
        }

        DatePickerButton {
            text: _queryController.departureDate
            Layout.fillWidth: true
            onDatePicked: _queryController.departureDate = theDate
        }

        Label {
            text: "Departure time:"
        }

        TimePickerButton {
            text: _queryController.departureTime
            Layout.fillWidth: true
            onTimePicked: _queryController.departureTime = theTime
        }
    }
}


