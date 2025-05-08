/*
    SPDX-FileCopyrightText: 2018 Volker Krause <vkrause@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#ifndef LOCALIZER_H
#define LOCALIZER_H

#include <KFormat>

#include <QObject>
#include <qqmlregistration.h>

class QVariant;

/** Date/time localization utilities.
 *  Works around JS losing timezone information, ie. we need
 *  to do this without passing the date/time values through JS.
 */
class Localizer : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit Localizer(QObject *parent = nullptr);
    Q_INVOKABLE [[nodiscard]] static QString formatTime(const QVariant &obj, const QString &propertyName);
    Q_INVOKABLE [[nodiscard]] static QString formatDuration(int seconds);
    Q_INVOKABLE [[nodiscard]] static QString formatTimeDifferenceToNow(const QVariant &obj, const QString &propertyName);
};

#endif // LOCALIZER_H
