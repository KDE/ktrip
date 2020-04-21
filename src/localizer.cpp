/*
    Copyright (C) 2018 Volker Krause <vkrause@kde.org>

    This program is free software; you can redistribute it and/or modify it
    under the terms of the GNU Library General Public License as published by
    the Free Software Foundation; either version 2 of the License, or (at your
    option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Library General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
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
