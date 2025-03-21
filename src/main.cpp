/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include "androidutils.h"
#include "version.h"

#include <QCommandLineOption>
#include <QCommandLineParser>
#include <QIcon>
#include <QImage>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>

#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#else
#include <KCrash>
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
    QCommandLineParser parser;
#ifdef Q_OS_ANDROID
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle(QStringLiteral("org.kde.breeze"));
#else
    QIcon::setFallbackThemeName(QStringLiteral("breeze"));
    QApplication app(argc, argv);
    // Default to org.kde.desktop style unless the user forces another style
    if (qEnvironmentVariableIsEmpty("QT_QUICK_CONTROLS_STYLE")) {
        QQuickStyle::setStyle(QStringLiteral("org.kde.desktop"));
    }
#endif

#ifdef Q_OS_WINDOWS
    QApplication::setStyle(QStringLiteral("breeze"));
#endif

    QCoreApplication::setApplicationName(QStringLiteral("ktrip"));
    QCoreApplication::setOrganizationName(QStringLiteral("KDE"));
    QCoreApplication::setOrganizationDomain(QStringLiteral("kde.org"));
    QCoreApplication::setApplicationVersion(QStringLiteral(KTRIP_VERSION_STRING));

    QGuiApplication::setApplicationDisplayName(QStringLiteral("KTrip"));
    QGuiApplication::setDesktopFileName(QStringLiteral("org.kde.ktrip"));

    KLocalizedString::setApplicationDomain("ktrip");
    parser.addVersionOption();
    parser.process(app);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));

    qRegisterMetaType<KPublicTransport::LocationRequest>();

    KAboutData about(QStringLiteral("ktrip"),
                     i18n("KTrip"),
                     QStringLiteral(KTRIP_VERSION_STRING),
                     i18n("Public transport assistant"),
                     KAboutLicense::GPL,
                     i18n("© 2019 KDE Community"));
    about.addAuthor(i18n("Nicolas Fella"), QString(), QStringLiteral("nicolas.fella@gmx.de"));
    about.setBugAddress("https://invent.kde.org/utilities/ktrip/-/issues");
    KAboutData::setApplicationData(about);

#ifndef Q_OS_ANDROID
    QApplication::setWindowIcon(QIcon::fromTheme(QStringLiteral("org.kde.ktrip")));
    KCrash::initialize();
#endif

#ifdef Q_OS_ANDROID
    engine.rootContext()->setContextProperty(QStringLiteral("_isAndroid"), true);
    engine.rootContext()->setContextProperty(QStringLiteral("_androidUtils"), QVariant::fromValue(AndroidUtils::instance()));
#else
    engine.rootContext()->setContextProperty(QStringLiteral("_isAndroid"), false);
#endif

    engine.loadFromModule("org.kde.ktrip", "Main");

    return app.exec();
}
