import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.4
import org.kde.kirigami 2.4 as Kirigami
import org.kde.ktrip 0.1

Kirigami.Page
{
    title: "Details"

    property var journey

    Kirigami.CardsListView {

        anchors.fill: parent

        model: journey.sections

        delegate: Kirigami.Card {

            height: Kirigami.Units.gridUnit * 4

            Column {
                Label {
                    anchors.leftMargin: Kirigami.Units.largeSpacing
                    text: modelData.from.name + " " + modelData.scheduledDepartureTime
                }
                Label {
                    text: modelData.to.name + " " + modelData.scheduledArrivalTime
                }
            }

        }

    }
}


