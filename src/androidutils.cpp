/**
 * Copyright 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#include "androidutils.h"
#include <QAndroidJniObject>
#include <QDateTime>
#include <QDebug>
#include <QtAndroid>

#define JSTRING(s) QAndroidJniObject::fromString(s).object<jstring>()

AndroidUtils *AndroidUtils::s_instance = nullptr;

AndroidUtils *AndroidUtils::instance()
{
    if (!s_instance) {
        s_instance = new AndroidUtils();
    }

    return s_instance;
}

static void dateSelected(JNIEnv *env, jobject that, jstring data)
{
    Q_UNUSED(that);
    AndroidUtils::instance()->_dateSelected(QString::fromUtf8(env->GetStringUTFChars(data, nullptr)));
}

static void dateCancelled(JNIEnv *env, jobject that)
{
    Q_UNUSED(that);
    Q_UNUSED(env);
    AndroidUtils::instance()->_dateCancelled();
}

static void timeSelected(JNIEnv *env, jobject that, jstring data)
{
    Q_UNUSED(that);
    AndroidUtils::instance()->_timeSelected(QString::fromUtf8(env->GetStringUTFChars(data, nullptr)));
}

static void timeCancelled(JNIEnv *env, jobject that)
{
    Q_UNUSED(that);
    Q_UNUSED(env);
    AndroidUtils::instance()->_timeCancelled();
}

static const JNINativeMethod methods[] = {{"dateSelected", "(Ljava/lang/String;)V", (void *)dateSelected}, {"cancelled", "()V", (void *)dateCancelled}};

static const JNINativeMethod timeMethods[] = {{"timeSelected", "(Ljava/lang/String;)V", (void *)timeSelected}, {"cancelled", "()V", (void *)timeCancelled}};

Q_DECL_EXPORT jint JNICALL JNI_OnLoad(JavaVM *vm, void *)
{
    static bool initialized = false;
    if (initialized)
        return JNI_VERSION_1_6;
    initialized = true;

    JNIEnv *env = nullptr;
    if (vm->GetEnv((void **)&env, JNI_VERSION_1_4) != JNI_OK) {
        qWarning() << "Failed to get JNI environment.";
        return -1;
    }
    jclass theclass = env->FindClass("org/kde/ktrip/DatePicker");
    if (env->RegisterNatives(theclass, methods, sizeof(methods) / sizeof(JNINativeMethod)) < 0) {
        qWarning() << "Failed to register native functions.";
        return -1;
    }

    jclass timeclass = env->FindClass("org/kde/ktrip/TimePicker");
    if (env->RegisterNatives(timeclass, timeMethods, sizeof(timeMethods) / sizeof(JNINativeMethod)) < 0) {
        qWarning() << "Failed to register native functions.";
        return -1;
    }

    return JNI_VERSION_1_4;
}

void AndroidUtils::showDatePicker()
{
    QAndroidJniObject picker("org/kde/ktrip/DatePicker", "(Landroid/app/Activity;J)V", QtAndroid::androidActivity().object(), QDateTime::currentDateTime().toMSecsSinceEpoch());
    picker.callMethod<void>("doShow");
}

void AndroidUtils::_dateSelected(const QString &data)
{
    Q_EMIT datePickerFinished(true, data);
}

void AndroidUtils::_dateCancelled()
{
    Q_EMIT datePickerFinished(false, QString());
}

void AndroidUtils::showTimePicker()
{
    QAndroidJniObject picker("org/kde/ktrip/TimePicker", "(Landroid/app/Activity;J)V", QtAndroid::androidActivity().object(), QDateTime::currentDateTime().toMSecsSinceEpoch());
    picker.callMethod<void>("doShow");
}

void AndroidUtils::_timeSelected(const QString &data)
{
    Q_EMIT timePickerFinished(true, data);
}

void AndroidUtils::_timeCancelled()
{
    Q_EMIT timePickerFinished(false, QString());
}
