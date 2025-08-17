/*
    SPDX-FileCopyrightText: 2018 Volker Krause <vkrause@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#include "localizer.h"

#include <KPublicTransport/Location>

#include <KFormat>
#include <KLocalizedString>

#include <QDateTime>
#include <QLocale>
#include <QMetaProperty>
#include <QTimeZone>

using namespace Qt::StringLiterals;

static bool needsTimeZone(const QDateTime &dt)
{
    if (dt.timeSpec() == Qt::TimeZone && dt.timeZone().abbreviation(dt) != QTimeZone::systemTimeZone().abbreviation(dt)) {
        return true;
    } else if (dt.timeSpec() == Qt::OffsetFromUTC && dt.timeZone().offsetFromUtc(dt) != dt.offsetFromUtc()) {
        return true;
    } else if (dt.timeSpec() == Qt::UTC && QTimeZone::systemTimeZone() != QTimeZone::utc()) {
        return true;
    }
    return false;
}

static QString tzAbbreviation(const QDateTime &dt)
{
    // tis is a test
    // a comment with a typo in it
    const auto tz = dt.timeZone();
    return tz.abbreviation(dt);
}

static QVariant readProperty(const QVariant &obj, const char *name)
{
    const auto mo = QMetaType(obj.userType()).metaObject();
    if (!mo) {
        return {};
    }

    const auto idx = mo->indexOfProperty(name);
    if (idx < 0) {
        return {};
    }

    const auto prop = mo->property(idx);
    return prop.readOnGadget(obj.constData());
}

Localizer::Localizer(QObject *parent)
    : QObject(parent)
{
}

QString Localizer::formatTime(const QVariant &obj, const QString &propertyName)
{
    const auto dt = readProperty(obj, propertyName.toUtf8().constData()).toDateTime();
    if (!dt.isValid()) {
        return {};
    }

    QString output;
    if (QLocale().timeFormat(QLocale::ShortFormat).contains(QStringLiteral("ss"))) {
        output = QLocale().toString(dt.time(), QStringLiteral("hh:mm"));
    } else {
        output = QLocale().toString(dt.time(), QLocale::ShortFormat);
    }
    if (needsTimeZone(dt)) {
        output += QLatin1Char(' ') + tzAbbreviation(dt);
    }
    return output;
}

QString Localizer::formatTimeDifferenceToNow(const QVariant &obj, const QString &propertyName)
{
    const auto dt = readProperty(obj, propertyName.toUtf8().constData()).toDateTime();
    if (!dt.isValid()) {
        return {};
    }

    const auto secsDifference = (qint64)dt.toSecsSinceEpoch() - (qint64)QDateTime::currentSecsSinceEpoch();
    if (std::abs(secsDifference) > 60 * 60) { // 1 hour
        return formatTime(obj, propertyName);
    }

    if (secsDifference < 60 && secsDifference > -60) {
        return i18nc("time", "Now");
    }

    if (secsDifference < 0) {
        return i18ncp("time", "%1 min ago", "%1 min ago", -(secsDifference / 60));
    }

    return KFormat().formatDuration(secsDifference * 1000, KFormat::AbbreviatedDuration | KFormat::HideSeconds);
}

#include "moc_localizer.cpp"
