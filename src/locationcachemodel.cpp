/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include "locationcachemodel.h"

#include <QDateTime>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStandardPaths>

LocationCacheModel::LocationCacheModel(QObject *parent)
    : QAbstractListModel(parent)
    , m_locationCacheFile(QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + QStringLiteral("/locations.cache"))
    , m_cachedLocationsJson()
{
    if (!m_locationCacheFile.open(QIODevice::ReadWrite)) {
        qWarning() << "Could not open location cache file" << m_locationCacheFile.fileName();
    }

    loadLocationsFromCache();
}

void LocationCacheModel::addCachedLocation(const KPublicTransport::Location location)
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

void LocationCacheModel::loadLocationsFromCache()
{
    m_cachedLocationsJson = QJsonDocument::fromJson(m_locationCacheFile.readAll()).object()[QStringLiteral("locations")].toArray();

    for (const QJsonValue &val : qAsConst(m_cachedLocationsJson)) {
        m_cachedLocations.append(QVariant::fromValue(KPublicTransport::Location::fromJson(val.toObject())));
    }
}

QVariant LocationCacheModel::data(const QModelIndex &index, int role) const
{
    Q_ASSERT(index.row() >= 0);
    Q_ASSERT(index.row() <= m_cachedLocations.count());

    if (role == Qt::UserRole + 1) {
        return m_cachedLocations[index.row()];
    }

    return QStringLiteral("deadbeef");
}

int LocationCacheModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_cachedLocations.count();
}

QHash<int, QByteArray> LocationCacheModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles.insert((Qt::UserRole + 1), "location");
    return roles;
}
