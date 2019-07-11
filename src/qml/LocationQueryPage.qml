import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.4
import org.kde.kirigami 2.0 as Kirigami
import org.kde.ktrip 0.1

Kirigami.Page
{
    property string type

    title: {
        if (type == "start") {
            return "Search for start location"
        }
        if (type == "destination") {
            return "Search for destination location"
        }
        return "deadbeef"
    }

    header: TextField {
        id: queryTextField
        placeholderText: "Search..."
        onAccepted: queryModel.query = text
    }

    ListView {
        anchors.fill: parent
        model: LocationQueryModel {
            id: queryModel
        }

        delegate: Kirigami.BasicListItem {
            text: name
            onClicked: {
                if (type == "start") {
                    _queryController.start = object
                } else if (type == "destination") {
                    _queryController.destination = object
                }
                pageStack.pop()
            }
        }
    }
}



