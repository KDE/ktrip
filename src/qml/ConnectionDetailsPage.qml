import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.4
import org.kde.kirigami 2.4 as Kirigami
import org.kde.ktrip 0.1
import org.kde.kpublictransport 1.0

Kirigami.Page
{
    title: "Details"

    property var journey

    Kirigami.CardsListView {

        id: clv

        anchors.fill: parent

        model: journey.sections

        delegate: Kirigami.AbstractCard {
            id: root

            showClickFeedback: true

            header: Rectangle {
                id: headerBackground
                Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
                Kirigami.Theme.inherit: false
                color: Kirigami.Theme.backgroundColor
                implicitHeight: headerLabel.implicitHeight + Kirigami.Units.largeSpacing * 2
                anchors.leftMargin: -root.leftPadding
                anchors.topMargin: -root.topPadding
                anchors.rightMargin: -root.rightPadding

                Label {
                    id: headerLabel
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.largeSpacing
                    color: Kirigami.Theme.textColor
                    font.pointSize: Kirigami.Theme.defaultFont.pointSize * root.headerFontScale
                    Layout.fillWidth: true

                    text: {

                        if (modelData.mode == JourneySection.Walking) {
                            return "Walking"
                        }

                        return modelData.route.line.name
                    }
                }
            }

            contentItem: ColumnLayout {
                id: topLayout

                RowLayout {
                    Label {
                        text: modelData.scheduledDepartureTime.toLocaleTimeString(Locale.ShortFormat)
                    }

                    Label {
                        text: modelData.from.name
                        Layout.fillWidth: true
                    }

                    Label {
                        text: modelData.scheduledDeparturePlatform
                    }
                }

                RowLayout {
                    Label {
                        text: modelData.scheduledArrivalTime.toLocaleTimeString(Locale.ShortFormat)
                    }

                    Label {
                        text: modelData.to.name
                        Layout.fillWidth: true
                    }

                    Label {
                        text: modelData.scheduledArrivalPlatform
                    }
                }
            }
        }
    }
}


