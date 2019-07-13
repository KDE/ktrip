import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.4
import org.kde.kirigami 2.0 as Kirigami
import org.kde.ktrip 0.1

Kirigami.Page
{
    property string type
    property bool showCached: true

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
        onAccepted: {
            queryModel.query = text
            showCached = false
        }
    }

    ListView {
        anchors.fill: parent
        visible: showCached
        model: _queryController.cachedLocations

        delegate: Kirigami.BasicListItem {
            text: modelData.name
            reserveSpaceForIcon: false
            onClicked: {
                _queryController.addCachedLocation(modelData)

                if (type == "start") {
                    _queryController.start = modelData
                } else if (type == "destination") {
                    _queryController.destination = modelData
                }
                pageStack.pop()
            }
        }
    }

    LocationQueryModel {
        id: queryModel
    }

    ListView {
        anchors.fill: parent
        visible: !showCached
        model: queryModel

        delegate: Kirigami.BasicListItem {
            text: name
            reserveSpaceForIcon: false
            onClicked: {
                _queryController.addCachedLocation(object)

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



