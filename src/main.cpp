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
#include "locationquerymodel.h"
#include "querycontroller.h"

#include <QQmlApplicationEngine>
#include <QQmlContext>

#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#else
#include <QApplication>
#endif

#include <KPublicTransport/Manager>
#include <KLocalizedContext>

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

    QQmlApplicationEngine engine(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));

    qmlRegisterType<LocationQueryModel>("org.kde.ktrip", 0, 1, "LocationQueryModel");

    QueryController queryController;
    engine.rootContext()->setContextProperty(QStringLiteral("_queryController"), &queryController);

    KPublicTransport::Manager manager;
    engine.rootContext()->setContextProperty(QStringLiteral("_manager"), &manager);

#ifdef Q_OS_ANDROID
    engine.rootContext()->setContextProperty(QStringLiteral("_isAndroid"), true);
    engine.rootContext()->setContextProperty(QStringLiteral("_androidUtils"), QVariant::fromValue(AndroidUtils::instance()));
#else
    engine.rootContext()->setContextProperty(QStringLiteral("_isAndroid"), false);
#endif

    return app.exec();
}
