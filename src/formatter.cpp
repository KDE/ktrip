/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include "formatter.h"

#include <QDateTime>

QString Formatter::formatTime(const QDateTime &time)
{
    return time.toString(QStringLiteral("hh:mm"));
}
