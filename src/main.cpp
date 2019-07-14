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

#include <QQmlApplicationEngine>
#include <QQmlContext>

#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#else
#include <QApplication>
#endif


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
