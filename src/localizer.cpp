/*
    SPDX-FileCopyrightText: 2018 Volker Krause <vkrause@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#include "localizer.h"

#include <KContacts/Address>

QString Localizer::countryName(const QString &isoCode) const
{
    return KContacts::Address::ISOtoCountry(isoCode);
}

QString Localizer::countryFlag(const QString &isoCode) const
{
    if (isoCode.size() != 2) {
        return {};
    }

    QString flag;
    char flagA[] = "\xF0\x9F\x87\xA6";
    flagA[3] = 0xA6 + (isoCode[0].toLatin1() - 'A');
    flag += QString::fromUtf8(flagA);
    flagA[3] = 0xA6 + (isoCode[1].toLatin1() - 'A');
    flag += QString::fromUtf8(flagA);
    return flag;
}
