/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include "version.h"

#include <QCommandLineOption>
#include <QCommandLineParser>
#include <QIcon>
#include <QImage>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QTimer>

#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#else
#include <KCrash>
#include <QApplication>
#endif

#include <KAboutData>
#include <KLocalizedQmlContext>
#include <KLocalizedString>
#include <KPublicTransport/LocationRequest>
#include <KPublicTransport/Manager>

using namespace Qt::Literals;

#ifdef Q_OS_ANDROID
Q_DECL_EXPORT
#endif
int main(int argc, char *argv[])
{
    QCommandLineParser parser;
    QCommandLineOption selfTestOpt(u"self-test"_s, u"internal, for automated testing"_s);
    selfTestOpt.setFlags(QCommandLineOption::HiddenFromHelp);
    parser.addOption(selfTestOpt);

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

    QGuiApplication::setApplicationDisplayName(i18n("KTrip"));
    QGuiApplication::setDesktopFileName(QStringLiteral("org.kde.ktrip"));

#if KCOREADDONS_VERSION >= QT_VERSION_CHECK(6, 28, 0)
    KAboutData about = KAboutData::fromAppStreamForApplication();
#else
    KAboutData about = KAboutData::applicationData();
    about.setShortDescription(i18n("Public transport assistant"));
    about.setLicense(KAboutLicense::GPL);
    about.setBugAddress("https://invent.kde.org/utilities/ktrip/-/issues");
#endif
    about.setCopyrightStatement(i18n("© 2019 KDE Community"));
    about.addAuthor(i18n("Nicolas Fella"), QString(), QStringLiteral("nicolas.fella@gmx.de"));
    KAboutData::setApplicationData(about);

    KLocalizedString::setApplicationDomain("ktrip");
    about.setupCommandLine(&parser);
    parser.process(app);
    about.processCommandLine(&parser);

    QQmlApplicationEngine engine;
    KLocalization::setupLocalizedContext(&engine);

#ifndef Q_OS_ANDROID
    QApplication::setWindowIcon(QIcon::fromTheme(QStringLiteral("org.kde.ktrip")));
    KCrash::initialize();
#endif

    engine.loadFromModule("org.kde.ktrip", "Main");

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    if (parser.isSet(selfTestOpt)) {
        QTimer::singleShot(std::chrono::milliseconds(250), &app, &QCoreApplication::quit);
    }

    return app.exec();
}
