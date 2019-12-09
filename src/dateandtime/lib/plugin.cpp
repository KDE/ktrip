/*
 *  Copyright (C) 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Library General Public
 *  License as published by the Free Software Foundation; either
 *  version 2 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Library General Public License for more details.
 *
 *  You should have received a copy of the GNU Library General Public License
 *  along with this library; see the file COPYING.LIB.  If not, write to
 *  the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 *  Boston, MA 02110-1301, USA.
 */


#include <QQmlEngine>
#include <QQmlExtensionPlugin>

#include "knumbermodel.h"
#include "timezonemodel.h"

class KirigamiAddonsDataAndTimePlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    KirigamiAddonsDataAndTimePlugin() = default;
    ~KirigamiAddonsDataAndTimePlugin() = default;
    void initializeEngine(QQmlEngine *engine, const char *uri) override {};
    void registerTypes(const char *uri) override;
};

void KirigamiAddonsDataAndTimePlugin::registerTypes(const char *uri)
{
    qmlRegisterType<TimeZoneModel>(uri, 0, 1, "TimeZoneModel");
    qmlRegisterType<TimeZoneFilterProxy>(uri, 0, 1, "TimeZoneFilterModel");
    qmlRegisterType<KNumberModel>(uri, 0, 1, "NumberModel");
}

#include "plugin.moc"
