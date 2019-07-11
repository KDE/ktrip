import QtQuick 2.2
import QtQuick.Controls 2.4
import org.kde.kirigami 2.0 as Kirigami

Kirigami.ApplicationWindow
{
    width: 480
    height: 720

    pageStack.initialPage: Qt.resolvedUrl("StartPage.qml")
}
