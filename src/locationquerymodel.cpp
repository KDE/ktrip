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
