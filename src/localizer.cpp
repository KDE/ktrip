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

QString Localizer::formatTime(const QVariant &obj, const QString &propertyName) const
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

QString Localizer::formatDate(const QVariant &obj, const QString &propertyName) const
{
    const auto dt = readProperty(obj, propertyName.toUtf8().constData()).toDate();
    if (!dt.isValid()) {
        return {};
    }

    if (dt.year() <= 1900) { // no year specified
        return dt.toString(i18nc("day-only date format", "dd MMMM"));
    }
    return QLocale().toString(dt, QLocale::ShortFormat);
}

QString Localizer::formatDateTime(const QVariant &obj, const QString &propertyName) const
{
    const auto dt = readProperty(obj, propertyName.toUtf8().constData()).toDateTime();
    if (!dt.isValid()) {
        return {};
    }

    auto s = QLocale().toString(dt, QLocale::ShortFormat);
    if (needsTimeZone(dt)) {
        s += QLatin1Char(' ') + tzAbbreviation(dt);
    }
    return s;
}

QString Localizer::formatDateOrDateTimeLocal(const QVariant &obj, const QString &propertyName) const
{
    const auto dt = readProperty(obj, propertyName.toUtf8().constData()).toDateTime();
    if (!dt.isValid()) {
        return {};
    }

    // detect likely date-only values
    if (dt.timeSpec() == Qt::LocalTime && (dt.time() == QTime{0, 0, 0} || dt.time() == QTime{23, 59, 59})) {
        return QLocale().toString(dt.date(), QLocale::ShortFormat);
    }

    return QLocale().toString(dt.toLocalTime(), QLocale::ShortFormat);
}

QString Localizer::formatTimeZoneOffset(qint64 seconds)
{
    if (seconds < 0) {
        return QLocale().negativeSign() + KFormat().formatDuration((-seconds * 1000), KFormat::HideSeconds);
    }
    return QLocale().positiveSign() + KFormat().formatDuration((seconds * 1000), KFormat::HideSeconds);
}

QString Localizer::formatDuration(int seconds)
{
    const auto opts = static_cast<KFormat::DurationFormatOptions>(KFormat::AbbreviatedDuration | KFormat::HideSeconds); // ### workaround for KF < 6.12
    return KFormat().formatDuration((quint64)seconds * 1000, opts);
}

QString Localizer::formatTimeDifferenceToNow(const QVariant &obj, const QString &propertyName)
{
    const auto dt = readProperty(obj, propertyName.toUtf8().constData()).toDateTime();
    if (!dt.isValid()) {
        return {};
    }

    const auto secsDifference = (qint64)dt.toSecsSinceEpoch() - (qint64)QDateTime::currentSecsSinceEpoch();
    if (secsDifference < 60 && secsDifference > -60) {
        return i18nc("time", "Now");
    }

    return formatDuration(secsDifference);
}

#include "moc_localizer.cpp"
