/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#pragma once

#include <QDate>
#include <QObject>
#include <QQmlEngine>
#include <QTime>
#include <QVariant>

#include <KPublicTransport/JourneyRequest>
#include <KPublicTransport/Location>
#include <KPublicTransport/LocationRequest>
#include <KPublicTransport/Manager>
#include <KPublicTransport/StopoverRequest>

class Controller : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(KPublicTransport::Location start READ start WRITE setStart NOTIFY startChanged)
    Q_PROPERTY(KPublicTransport::Location destination READ destination WRITE setDestination NOTIFY destinationChanged)
    Q_PROPERTY(QDate departureDate READ departureDate WRITE setDepartureDate NOTIFY departureDateChanged)
    Q_PROPERTY(QTime departureTime READ departureTime WRITE setDepartureTime NOTIFY departureTimeChanged)
    Q_PROPERTY(bool firstRun READ firstRun CONSTANT)
    Q_PROPERTY(KPublicTransport::Manager *manager READ manager CONSTANT)

public:
    explicit Controller(QObject *parent = nullptr);

    KPublicTransport::Location start() const;
    void setStart(const KPublicTransport::Location &start);

    KPublicTransport::Location destination() const;
    void setDestination(const KPublicTransport::Location &destination);

    QDate departureDate() const;
    void setDepartureDate(const QDate &date);

    QTime departureTime() const;
    void setDepartureTime(const QTime &time);

    bool firstRun() const;

    KPublicTransport::Manager *manager() const;

    Q_INVOKABLE KPublicTransport::JourneyRequest createJourneyRequest();
    Q_INVOKABLE KPublicTransport::LocationRequest createLocationRequest(const QString &name);
    Q_INVOKABLE KPublicTransport::StopoverRequest createStopoverRequest();

    Q_INVOKABLE void showOnMap(KPublicTransport::Location location);

Q_SIGNALS:
    void startChanged();
    void destinationChanged();
    void departureDateChanged();
    void departureTimeChanged();

private:
    KPublicTransport::Location m_start;
    KPublicTransport::Location m_destination;
    std::unique_ptr<KPublicTransport::Manager> m_manager;
    QDate m_departureDate;
    QTime m_departureTime;
    bool m_firstRun = false;
};
