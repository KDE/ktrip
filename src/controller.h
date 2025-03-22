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
    Q_PROPERTY(bool firstRun READ firstRun CONSTANT)
    Q_PROPERTY(KPublicTransport::Manager *manager READ manager CONSTANT)

public:
    explicit Controller(QObject *parent = nullptr);

    KPublicTransport::Manager *manager() const;
    bool firstRun() const;

    Q_INVOKABLE void showOnMap(KPublicTransport::Location location);

    /** yay for JavaScript! */
    Q_INVOKABLE static KPublicTransport::Location copyLocation(const KPublicTransport::Location &loc);

private:
    std::unique_ptr<KPublicTransport::Manager> m_manager;
    bool m_firstRun = false;
};
