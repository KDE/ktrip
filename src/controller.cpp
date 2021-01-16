/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include "controller.h"

#include <QDateTime>
#include <QDebug>
#include <QDesktopServices>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStandardPaths>
#include <QUrl>

Controller::Controller(QObject *parent)
    : QObject(parent)
    , m_start()
    , m_destination()
{
    m_departureDate = QDate::currentDate();
    m_departureTime = QTime::currentTime();
}

void Controller::setStart(const KPublicTransport::Location &start)
{
    m_start = start;
    Q_EMIT startChanged();
}

KPublicTransport::Location Controller::start() const
{
    return m_start;
}

void Controller::setDestination(const KPublicTransport::Location &destination)
{
    m_destination = destination;
    Q_EMIT destinationChanged();
}

KPublicTransport::Location Controller::destination() const
{
    return m_destination;
}

KPublicTransport::JourneyRequest Controller::createJourneyRequest()
{
    KPublicTransport::JourneyRequest req;
    req.setFrom(m_start);
    req.setTo(m_destination);
    req.setDownloadAssets(true);

    QDateTime depTime(m_departureDate, m_departureTime);
    req.setDepartureTime(depTime);

    return req;
}

QDate Controller::departureDate() const
{
    return m_departureDate;
}

void Controller::setDepartureDate(const QDate &date)
{
    if (m_departureDate != date) {
        m_departureDate = date;
        Q_EMIT departureDateChanged();
    }
}

QTime Controller::departureTime() const
{
    return m_departureTime;
}

void Controller::setDepartureTime(const QTime &time)
{
    if (m_departureTime != time) {
        m_departureTime = time;
        Q_EMIT departureTimeChanged();
    }
}

KPublicTransport::LocationRequest Controller::createLocationRequest(const QString &name)
{
    KPublicTransport::LocationRequest req;
    req.setName(name);

    return req;
}

KPublicTransport::StopoverRequest Controller::createStopoverRequest()
{
    KPublicTransport::StopoverRequest req;
    req.setStop(m_start);
    QDateTime depTime(m_departureDate, m_departureTime);
    req.setDateTime(depTime);
    return req;
}

void Controller::showOnMap(KPublicTransport::Location location)
{
    QUrl url;
    url.setScheme(QStringLiteral("https"));
    url.setHost(QStringLiteral("www.openstreetmap.org"));
    url.setPath(QStringLiteral("/"));
    const QString fragment = QLatin1String("map=") + QString::number(17) + QLatin1Char('/') + QString::number(location.latitude()) + QLatin1Char('/')
        + QString::number(location.longitude());
    url.setFragment(fragment);
    QDesktopServices::openUrl(url);
}
