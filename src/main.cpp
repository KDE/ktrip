#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#else
#include <QApplication>
#endif

#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "locationquerymodel.h"
#include "querycontroller.h"
#include <KPublicTransport/JourneyQueryModel>
#include <KPublicTransport/Manager>

#include "androidutils.h"

#ifdef Q_OS_ANDROID
Q_DECL_EXPORT
#endif
int main(int argc, char *argv[])
{

#ifdef Q_OS_ANDROID
    QGuiApplication app(argc, argv);
#else
    QApplication app(argc, argv);
#endif

    QQmlApplicationEngine engine(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    qmlRegisterType<LocationQueryModel>("org.kde.ktrip", 0, 1, "LocationQueryModel");
    qmlRegisterType<KPublicTransport::JourneyQueryModel>("org.kde.ktrip", 0, 1, "JourneyQueryModel");

    QueryController queryController;
    engine.rootContext()->setContextProperty(QStringLiteral("_queryController"), &queryController);

#ifdef Q_OS_ANDROID
    engine.rootContext()->setContextProperty(QStringLiteral("_isAndroid"), true);
    engine.rootContext()->setContextProperty(QStringLiteral("_androidUtils"), QVariant::fromValue(AndroidUtils::instance()));
#else
    engine.rootContext()->setContextProperty(QStringLiteral("_isAndroid"), false);
#endif

    return app.exec();
}
