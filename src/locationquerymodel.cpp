#include "locationquerymodel.h"

#include <KPublicTransport/LocationRequest>
#include <KPublicTransport/LocationReply>

LocationQueryModel::LocationQueryModel(QObject* parent)
    : QAbstractListModel(parent)
    , m_manager()
{
    connect(this, &LocationQueryModel::queryChanged, this, &LocationQueryModel::triggerQuery);
}

void LocationQueryModel::triggerQuery()
{

    KPublicTransport::LocationRequest request;
    request.setName(m_query);

    const KPublicTransport::LocationReply *reply = m_manager.queryLocation(request);

    connect(reply, &KPublicTransport::LocationReply::finished, this, [this, reply] {
        beginResetModel();
        m_locations = reply->result();
        endResetModel();
    });

}

QVariant LocationQueryModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid()
        || index.row() < 0
        || index.row() >= rowCount())
    {
        return QVariant();
    }

    switch (role) {
        case NameRole:
            return m_locations[index.row()].name();
        case ObjectRole:
            return QVariant::fromValue(m_locations[index.row()]);
        default:
            return QVariant(QStringLiteral("deadbeef"));
    }

}

QString LocationQueryModel::query() const
{
    return m_query;
}

int LocationQueryModel::rowCount(const QModelIndex& parent) const
{
    return m_locations.size();
}

void LocationQueryModel::setQuery(const QString query)
{
    if (m_query != query) {
        m_query = query;
        Q_EMIT queryChanged();
    }
}

QHash<int, QByteArray> LocationQueryModel::roleNames() const
{
    QHash<int, QByteArray> names = QAbstractItemModel::roleNames();
    names.insert(NameRole, "name");
    names.insert(ObjectRole, "object");
    return names;
}


