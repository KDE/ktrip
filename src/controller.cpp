/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include "controller.h"

#include "ktripsettings.h"

#include <QDateTime>
#include <QDebug>
#include <QDesktopServices>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStandardPaths>
#include <QUrl>

Controller::Controller(QObject *parent)
    : QObject(parent)
    , m_manager(std::make_unique<KPublicTransport::Manager>())
{
    m_firstRun = KTripSettings::firstRun();
    KTripSettings::setFirstRun(false);
    KTripSettings::self()->save();

    m_manager->setAllowInsecureBackends(true);
    m_manager->setBackendsEnabledByDefault(false);
    m_manager->setEnabledBackends(KTripSettings::self()->enabledBackends());

    connect(m_manager.get(), &KPublicTransport::Manager::configurationChanged, this, [this] {
        KTripSettings::self()->setEnabledBackends(m_manager->enabledBackends());
        KTripSettings::self()->save();
    });
}

void Controller::showOnMap(KPublicTransport::Location location)
{
    if (!location.hasCoordinate())
        return;
    QUrl url(QLatin1String("geo:") + QString::number(location.latitude()) + QLatin1Char(',') + QString::number(location.longitude()));
    QDesktopServices::openUrl(url);
}

bool Controller::firstRun() const
{
    return m_firstRun;
}

KPublicTransport::Manager *Controller::manager() const
{
    return m_manager.get();
}

KPublicTransport::Location Controller::copyLocation(const KPublicTransport::Location &loc)
{
    return loc;
}
