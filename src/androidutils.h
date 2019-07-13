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

    static AndroidUtils* instance();

Q_SIGNALS:
    void datePickerFinished(bool accepted, const QString &date);
    void timePickerFinished(bool accepted, const QString &time);

private:
    static AndroidUtils* s_instance;

};
