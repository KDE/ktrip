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

#pragma once

#include <QObject>
#include <QFile>
#include <QJsonArray>

#include <KPublicTransport/Location>
#include <KPublicTransport/JourneyRequest>

class QueryController : public QObject {

    Q_OBJECT
    Q_PROPERTY(KPublicTransport::Location start READ start WRITE setStart NOTIFY startChanged)
    Q_PROPERTY(KPublicTransport::Location destination READ destination WRITE setDestination NOTIFY destinationChanged)
    Q_PROPERTY(QString departureDate READ departureDate WRITE setDepartureDate NOTIFY departureDateChanged)
    Q_PROPERTY(QString departureTime READ departureTime WRITE setDepartureTime NOTIFY departureTimeChanged)
    Q_PROPERTY(QVariantList cachedLocations READ cachedLocations WRITE setCachedLocations NOTIFY cachedLocationsChanged)

public:
    explicit QueryController(QObject *parent=nullptr);

    KPublicTransport::Location start() const;
    void setStart(const KPublicTransport::Location start);

    KPublicTransport::Location destination() const;
    void setDestination(const KPublicTransport::Location destination);

    QString departureDate() const;
    void setDepartureDate(const QString& date);

    QString departureTime() const;
    void setDepartureTime(const QString& time);

    QVariantList cachedLocations() const;
    void setCachedLocations(const QVariantList& locations);

    Q_INVOKABLE void addCachedLocation(const KPublicTransport::Location location);
    Q_INVOKABLE KPublicTransport::JourneyRequest createJourneyRequest();

Q_SIGNALS:
    void startChanged();
    void destinationChanged();
    void departureDateChanged();
    void departureTimeChanged();
    void cachedLocationsChanged();

private:
    void loadLocationsFromCache();

    KPublicTransport::Location m_start;
    KPublicTransport::Location m_destination;
    QString m_departureDate;
    QString m_departureTime;
    QVariantList m_cachedLocations;
    QFile m_locationCacheFile;
    QJsonArray m_cachedLocationsJson;
};
