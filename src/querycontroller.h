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
    Q_PROPERTY(QString departureDate READ departureDate WRITE setDepartureDate NOTIFY departureDateChanged)
    Q_PROPERTY(QString departureTime READ departureTime WRITE setDepartureTime NOTIFY departureTimeChanged)

public:
    explicit QueryController(QObject *parent=nullptr);

    KPublicTransport::Location start() const;
    void setStart(const KPublicTransport::Location start);

    KPublicTransport::Location destination() const;
    void setDestination(const KPublicTransport::Location destination);

    KPublicTransport::JourneyQueryModel * journeyModel();

    QString departureDate() const;
    void setDepartureDate(const QString& date);

    QString departureTime() const;
    void setDepartureTime(const QString& time);

Q_SIGNALS:
    void startChanged();
    void destinationChanged();
    void departureDateChanged();
    void departureTimeChanged();

private Q_SLOTS:
    void createJourneyRequest();

private:
    KPublicTransport::Location m_start;
    KPublicTransport::Location m_destination;
    KPublicTransport::JourneyQueryModel *m_journeyModel;
    KPublicTransport::Manager m_manager;
    QString m_departureDate;
    QString m_departureTime;
};
