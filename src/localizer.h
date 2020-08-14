/*
    SPDX-FileCopyrightText: 2018 Volker Krause <vkrause@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#ifndef LOCALIZER_H
#define LOCALIZER_H

#include <QObject>

class Localizer : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE QString countryName(const QString &isoCode) const;
    /** Emoji representation of @p isoCode.
     *  @see https://en.wikipedia.org/wiki/Regional_Indicator_Symbol
     */
    Q_INVOKABLE QString countryFlag(const QString &isoCode) const;
};

#endif // LOCALIZER_H
