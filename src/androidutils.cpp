/**
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include "androidutils.h"

#include <QCoreApplication>
#include <QDateTime>
#include <QDebug>
#include <QJniObject>

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
#if QT_VERSION < QT_VERSION_CHECK(6, 7, 0)
    QJniObject picker("org/kde/ktrip/DatePicker",
                      "(Landroid/app/Activity;J)V",
                      QNativeInterface::QAndroidApplication::context(),
                      QDateTime::currentDateTime().toMSecsSinceEpoch());
#else
    QJniObject picker("org/kde/ktrip/DatePicker",
                      "(Landroid/app/Activity;J)V",
                      QNativeInterface::QAndroidApplication::context().object<jobject>(),
                      QDateTime::currentDateTime().toMSecsSinceEpoch());
#endif
    picker.callMethod<void>("doShow");
}

void AndroidUtils::_dateSelected(const QString &data)
{
    Q_EMIT datePickerFinished(true, QDate::fromString(data, QStringLiteral("yyyy-MM-dd")));
}

void AndroidUtils::_dateCancelled()
{
    Q_EMIT datePickerFinished(false, QDate());
}

void AndroidUtils::showTimePicker()
{
#if QT_VERSION < QT_VERSION_CHECK(6, 7, 0)
    QJniObject picker("org/kde/ktrip/TimePicker",
                      "(Landroid/app/Activity;J)V",
                      QNativeInterface::QAndroidApplication::context(),
                      QDateTime::currentDateTime().toMSecsSinceEpoch());
#else
    QJniObject picker("org/kde/ktrip/TimePicker",
                      "(Landroid/app/Activity;J)V",
                      QNativeInterface::QAndroidApplication::context().object<jobject>(),
                      QDateTime::currentDateTime().toMSecsSinceEpoch());
#endif
    picker.callMethod<void>("doShow");
}

void AndroidUtils::_timeSelected(const QString &data)
{
    Q_EMIT timePickerFinished(true, QTime::fromString(data, QStringLiteral("HH:mm")));
}

void AndroidUtils::_timeCancelled()
{
    Q_EMIT timePickerFinished(false, QTime());
}
