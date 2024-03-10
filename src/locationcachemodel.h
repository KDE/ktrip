/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#pragma once

#include <QAbstractListModel>
#include <QFile>
#include <QJsonArray>
#include <qqmlregistration.h>

#include <KPublicTransport/Location>

class LocationCacheModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit LocationCacheModel(QObject *parent = nullptr);

    QVariant data(const QModelIndex &index, int role) const override;
    int rowCount(const QModelIndex &parent) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addCachedLocation(const KPublicTransport::Location location);

private:
    void loadLocationsFromCache();

    QVariantList m_cachedLocations;
    QFile m_locationCacheFile;
    QJsonArray m_cachedLocationsJson;
};
