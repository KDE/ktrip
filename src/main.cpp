/**
 * Copyright 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#include "androidutils.h"
#include "controller.h"
#include "formatter.h"
#include "ktripsettings.h"
#include "localizer.h"
#include "locationcachemodel.h"

#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QImage>

#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#else
#include <QApplication>
#endif

#include <KAboutData>
#include <KLocalizedContext>
#include <KLocalizedString>
#include <KPublicTransport/LocationRequest>
#include <KPublicTransport/Manager>

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

    QCoreApplication::setApplicationName(QStringLiteral("ktrip"));
    QCoreApplication::setOrganizationName(QStringLiteral("KDE"));
    QCoreApplication::setOrganizationDomain(QStringLiteral("kde.org"));
    QCoreApplication::setApplicationVersion(QStringLiteral("0.1"));

    QGuiApplication::setApplicationDisplayName(QStringLiteral("KTrip"));
    QGuiApplication::setDesktopFileName(QStringLiteral("org.kde.ktrip"));

    KLocalizedString::setApplicationDomain("ktrip");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));

    qRegisterMetaType<KPublicTransport::LocationRequest>();

    qmlRegisterType<LocationCacheModel>("org.kde.ktrip", 1, 0, "LocationCacheModel");

    KPublicTransport::Manager manager;
    manager.setAllowInsecureBackends(true);
    manager.setBackendsEnabledByDefault(false);
    engine.rootContext()->setContextProperty(QStringLiteral("_manager"), &manager);

    KTripSettings settings;
    manager.setEnabledBackends(settings.enabledBackends());

    QObject::connect(&manager, &KPublicTransport::Manager::configurationChanged, &settings, [&settings, &manager]{
        settings.setEnabledBackends(manager.enabledBackends());
        settings.save();
    });

    KAboutData about(QStringLiteral("ktrip"), i18n("KTrip"), QStringLiteral("0.1"), i18n("Public transport assistant"), KAboutLicense::GPL, i18n("© 2019 KDE Community"));
    about.addAuthor(i18n("Nicolas Fella"), QString(), QStringLiteral("nicolas.fella@gmx.de"));
    about.setProgramLogo(QImage(QStringLiteral(":/ktrip.svg")));
    KAboutData::setApplicationData(about);

    engine.rootContext()->setContextProperty(QStringLiteral("_aboutData"), QVariant::fromValue(about));

    engine.rootContext()->setContextProperty(QStringLiteral("_settings"), &settings);

    Formatter formatter;
    engine.rootContext()->setContextProperty(QStringLiteral("_formatter"), &formatter);

#ifdef Q_OS_ANDROID
    engine.rootContext()->setContextProperty(QStringLiteral("_isAndroid"), true);
    engine.rootContext()->setContextProperty(QStringLiteral("_androidUtils"), QVariant::fromValue(AndroidUtils::instance()));
#else
    engine.rootContext()->setContextProperty(QStringLiteral("_isAndroid"), false);
#endif

    qmlRegisterSingletonType("org.kde.ktrip", 1, 0, "Localizer", [](QQmlEngine *, QJSEngine *engine) -> QJSValue { return engine->toScriptValue(Localizer()); });

    qmlRegisterSingletonType<Controller>("org.kde.ktrip", 1, 0, "Controller", [](QQmlEngine *, QJSEngine *engine) -> QObject * {
        Q_UNUSED(engine);
        return new Controller;
    });

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
