#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "locationquerymodel.h"
#include "querycontroller.h"
#include <KPublicTransport/JourneyQueryModel>
#include <KPublicTransport/Manager>

#ifdef Q_OS_ANDROID
Q_DECL_EXPORT
#endif
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    qmlRegisterType<LocationQueryModel>("org.kde.ktrip", 0, 1, "LocationQueryModel");
    qmlRegisterType<KPublicTransport::JourneyQueryModel>("org.kde.ktrip", 0, 1, "JourneyQueryModel");

    QueryController queryController;
    engine.rootContext()->setContextProperty(QStringLiteral("_queryController"), &queryController);

    return app.exec();
}
