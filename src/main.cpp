#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "locationquerymodel.h"
#include "querycontroller.h"
#include <KPublicTransport/JourneyQueryModel>
#include <KPublicTransport/Manager>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QQmlApplicationEngine engine(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    qmlRegisterType<LocationQueryModel>("org.kde.ktrip", 0, 1, "LocationQueryModel");
    qmlRegisterType<KPublicTransport::JourneyQueryModel>("org.kde.ktrip", 0, 1, "JourneyQueryModel");

    QueryController queryController;
    engine.rootContext()->setContextProperty("_queryController", &queryController);

    return app.exec();
}
