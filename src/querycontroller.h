#pragma once

#include <QObject>

#include <KPublicTransport/Location>
#include <KPublicTransport/JourneyRequest>
#include <KPublicTransport/JourneyQueryModel>
#include <KPublicTransport/Manager>

class QueryController : public QObject {

    Q_OBJECT
    Q_PROPERTY(KPublicTransport::Location start READ start WRITE setStart NOTIFY startChanged)
    Q_PROPERTY(KPublicTransport::Location destination READ destination WRITE setDestination NOTIFY destinationChanged)
    Q_PROPERTY(KPublicTransport::JourneyQueryModel* journeyModel READ journeyModel CONSTANT)

public:
    explicit QueryController(QObject *parent=nullptr);

    KPublicTransport::Location start() const;
    void setStart(const KPublicTransport::Location start);

    KPublicTransport::Location destination() const;
    void setDestination(const KPublicTransport::Location destination);

    KPublicTransport::JourneyQueryModel * journeyModel() const;

Q_SIGNALS:
    void startChanged();
    void destinationChanged();

private Q_SLOTS:
    void createJourneyRequest();

private:
    KPublicTransport::Location m_start;
    KPublicTransport::Location m_destination;
    KPublicTransport::JourneyQueryModel *m_journeyModel;
    KPublicTransport::Manager m_manager;

};
