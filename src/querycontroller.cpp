#include "querycontroller.h"

#include <QDebug>
#include <QDateTime>

QueryController::QueryController(QObject* parent)
    : QObject(parent)
    , m_start()
    , m_destination()
    , m_journeyModel(new KPublicTransport::JourneyQueryModel)
    , m_manager()
{
    m_journeyModel->setManager(&m_manager);

    connect(this, &QueryController::startChanged, this, &QueryController::createJourneyRequest);
    connect(this, &QueryController::destinationChanged, this, &QueryController::createJourneyRequest);
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

KPublicTransport::JourneyQueryModel * QueryController::journeyModel() const
{
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

    req.setDepartureTime(QDateTime::currentDateTime());

    m_journeyModel->setJourneyRequest(req);
}


