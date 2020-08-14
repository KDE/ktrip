/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#pragma once

#include <QObject>

class Formatter : public QObject
{
    Q_OBJECT

public:
    Q_INVOKABLE QString formatDuration(int seconds);
    Q_INVOKABLE QString formatTime(const QDateTime &time);
};
