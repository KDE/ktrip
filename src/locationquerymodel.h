#pragma once

#include <QObject>
#include <QAbstractListModel>
#include <QVariant>

#include <KPublicTransport/Manager>
#include <KPublicTransport/Location>

class LocationQueryModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString query READ query WRITE setQuery NOTIFY queryChanged)

public:
    enum Roles {
        NameRole = Qt::DisplayRole,
        ObjectRole = Qt::UserRole + 1
    };

    explicit LocationQueryModel(QObject *parent=nullptr);

    QVariant data(const QModelIndex &index, int role) const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QHash<int, QByteArray> roleNames() const override;

    QString query() const;
    void setQuery(const QString query);

Q_SIGNALS:
    void queryChanged();

private Q_SLOTS:
    void triggerQuery();

private:
    KPublicTransport::Manager m_manager;
    QString m_query;
    std::vector<KPublicTransport::Location> m_locations;
};
