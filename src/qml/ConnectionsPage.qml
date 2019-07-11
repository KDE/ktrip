import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.4
import org.kde.kirigami 2.4 as Kirigami
import org.kde.ktrip 0.1

Kirigami.Page
{
    title: "Connections"

    header: Label {
        text: _queryController.journeyModel.errorMessage
    }

    ListView {

        anchors.fill: parent

        model: _queryController.journeyModel

        delegate: Kirigami.BasicListItem {
            text: journey.sections[0].from.name + " - " + journey.sections[journey.sections.length - 1].to.name + " (" + journey.numberOfChanges + " changes)"
            onClicked: pageStack.push(Qt.resolvedUrl("ConnectionDetailsPage.qml"), {journey: journey})
        }
    }
}

