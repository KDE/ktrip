/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */
#pragma once

#include <QObject>

class AndroidUtils : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE void showDatePicker();
    Q_INVOKABLE void showTimePicker();

    void _dateSelected(const QString &data);
    void _dateCancelled();

    void _timeSelected(const QString &data);
    void _timeCancelled();

    static AndroidUtils *instance();

Q_SIGNALS:
    void datePickerFinished(bool accepted, const QDate &date);
    void timePickerFinished(bool accepted, const QTime &time);

private:
    static AndroidUtils *s_instance;
};
