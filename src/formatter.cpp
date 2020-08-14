/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include "formatter.h"

#include <QDateTime>

QString Formatter::formatDuration(int seconds)
{
    const int minutes = seconds / 60;
    const int hours = minutes / 60;
    const int minutesRemainder = minutes % 60;

    const QString minutesString = minutesRemainder > 9 ? QString::number(minutesRemainder) : QStringLiteral("0") + QString::number(minutesRemainder);

    return QString::number(hours) + QStringLiteral(":") + minutesString;
}

QString Formatter::formatTime(const QDateTime &time)
{
    return time.toString(QStringLiteral("hh:mm"));
}
