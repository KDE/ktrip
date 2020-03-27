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

#include "querycontroller.h"

#include <QDateTime>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStandardPaths>

QueryController::QueryController(QObject *parent)
    : QObject(parent)
    , m_start()
    , m_destination()
{
    m_departureDate = QDate::currentDate().toString(Qt::ISODate);
    m_departureTime = QLocale::system().toString(QTime::currentTime(), QLocale::ShortFormat);
}

void QueryController::setStart(const KPublicTransport::Location start)
{
    m_start = start;
    Q_EMIT startChanged();
}

KPublicTransport::Location QueryController::start() const
{
    return m_start;
}

void QueryController::setDestination(const KPublicTransport::Location destination)
{
    m_destination = destination;
    Q_EMIT destinationChanged();
}

KPublicTransport::Location QueryController::destination() const
{
    return m_destination;
}

KPublicTransport::JourneyRequest QueryController::createJourneyRequest()
{
    KPublicTransport::JourneyRequest req;
    req.setFrom(m_start);
    req.setTo(m_destination);

    QDateTime depTime = QDateTime::fromString(m_departureDate + QStringLiteral("T") + m_departureTime, Qt::ISODate);
    req.setDepartureTime(depTime);
    qDebug() << depTime << m_departureDate + QStringLiteral("T") + m_departureTime;

    return req;
}

QString QueryController::departureDate() const
{
    return m_departureDate;
}

void QueryController::setDepartureDate(const QString &date)
{
    if (m_departureDate != date) {
        m_departureDate = date;
        Q_EMIT departureDateChanged();
    }
}

QString QueryController::departureTime() const
{
    return m_departureTime;
}

void QueryController::setDepartureTime(const QString &time)
{
    if (m_departureTime != time) {
        m_departureTime = time;
        Q_EMIT departureTimeChanged();
    }
}

KPublicTransport::LocationRequest QueryController::createLocationRequest(const QString name)
{
    KPublicTransport::LocationRequest req;
    req.setName(name);

    return req;
}

KPublicTransport::DepartureRequest QueryController::createDepartureRequest()
{
    KPublicTransport::DepartureRequest req;
    req.setStop(m_start);
    QDateTime depTime = QDateTime::fromString(m_departureDate + QStringLiteral("T") + m_departureTime, Qt::ISODate);
    req.setDateTime(depTime);
    return req;
}
