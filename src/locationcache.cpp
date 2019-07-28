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

#include "locationcache.h"

#include <QDebug>
#include <QDateTime>
#include <QStandardPaths>
#include <QJsonDocument>
#include <QJsonObject>

LocationCache::LocationCache(QObject *parent)
    : QObject(parent), m_locationCacheFile(QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + QStringLiteral("/locations.cache")), m_cachedLocationsJson()
{
    if (!m_locationCacheFile.open(QIODevice::ReadWrite)) {
        qWarning() << "Could not open location cache file" << m_locationCacheFile.fileName();
    }

    loadLocationsFromCache();
}

QVariantList LocationCache::cachedLocations() const
{
    return m_cachedLocations;
}

void LocationCache::setCachedLocations(const QVariantList &locations)
{
    if (locations != m_cachedLocations) {
        m_cachedLocations = locations;
        Q_EMIT cachedLocationsChanged();
    }
}

void LocationCache::addCachedLocation(const KPublicTransport::Location location)
{
    if (m_cachedLocations.contains(QVariant::fromValue(location))) {
        return;
    }

    m_cachedLocations.append(QVariant::fromValue(location));
    m_cachedLocationsJson.append(KPublicTransport::Location::toJson(location));

    QJsonObject obj;
    obj[QStringLiteral("version")] = 1;
    obj[QStringLiteral("locations")] = m_cachedLocationsJson;

    QJsonDocument doc(obj);

    m_locationCacheFile.resize(0);
    m_locationCacheFile.write(doc.toJson());
    m_locationCacheFile.flush();
}

void LocationCache::loadLocationsFromCache()
{
    m_cachedLocationsJson = QJsonDocument::fromJson(m_locationCacheFile.readAll()).object()[QStringLiteral("locations")].toArray();

    for (const QJsonValue &val : qAsConst(m_cachedLocationsJson)) {
        m_cachedLocations.append(QVariant::fromValue(KPublicTransport::Location::fromJson(val.toObject())));
    }
}
