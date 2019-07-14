#include "querycontroller.h"

#include <QDebug>
#include <QDateTime>
#include <QStandardPaths>
#include <QJsonDocument>
#include <QJsonObject>

QueryController::QueryController(QObject* parent)
    : QObject(parent)
    , m_start()
    , m_destination()
    , m_journeyModel(new KPublicTransport::JourneyQueryModel)
    , m_manager()
    , m_locationCacheFile(QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + QStringLiteral("/locations.cache"))
    , m_cachedLocationsJson()
{
    if (!m_locationCacheFile.open(QIODevice::ReadWrite)) {
        qWarning() << "Could not open location cache file" << m_locationCacheFile.fileName();
    }

    m_departureDate = QDate::currentDate().toString(Qt::ISODate);
    m_departureTime = QTime::currentTime().toString(Qt::ISODate);

    m_journeyModel->setManager(&m_manager);

    loadLocationsFromCache();
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

KPublicTransport::JourneyQueryModel * QueryController::journeyModel()
{
    createJourneyRequest();
    return m_journeyModel;
}

void QueryController::createJourneyRequest()
{

    if (m_start.isEmpty() || m_destination.isEmpty()) {
        return;
    }

    KPublicTransport::JourneyRequest req;
    req.setFrom(m_start);
    req.setTo(m_destination);

    QDateTime depTime = QDateTime::fromString(m_departureDate + QStringLiteral("T") + m_departureTime, Qt::ISODate);
    req.setDepartureTime(depTime);
    qDebug() << depTime << m_departureDate  + QStringLiteral("T") +  m_departureTime;

    m_journeyModel->setJourneyRequest(req);
}

QString QueryController::departureDate() const
{
    return m_departureDate;
}

void QueryController::setDepartureDate(const QString& date)
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

void QueryController::setDepartureTime(const QString& time)
{
    if (m_departureTime != time) {
        m_departureTime = time;
        Q_EMIT departureTimeChanged();
    }
}

QVariantList QueryController::cachedLocations() const
{
    return m_cachedLocations;
}

void QueryController::setCachedLocations(const QVariantList& locations)
{
    if (locations != m_cachedLocations) {
        m_cachedLocations = locations;
        Q_EMIT cachedLocationsChanged();
    }
}

void QueryController::addCachedLocation(const KPublicTransport::Location location)
{
    if (m_cachedLocations.contains(QVariant::fromValue(location))) {
        return;
    }

    m_cachedLocations.append(QVariant::fromValue(location));
    m_cachedLocationsJson.append(KPublicTransport::Location::toJson(location));

    QJsonDocument doc(m_cachedLocationsJson);

    m_locationCacheFile.resize(0);
    m_locationCacheFile.write(doc.toJson());
    m_locationCacheFile.flush();
}

void QueryController::loadLocationsFromCache()
{
    m_cachedLocationsJson = QJsonDocument::fromJson(m_locationCacheFile.readAll()).array();

    for (const QJsonValue& val : m_cachedLocationsJson) {
        m_cachedLocations.append(QVariant::fromValue(KPublicTransport::Location::fromJson(val.toObject())));
    }
}
