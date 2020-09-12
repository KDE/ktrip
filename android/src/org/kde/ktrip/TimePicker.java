/*
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

package org.kde.ktrip;

import android.app.TimePickerDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.app.DialogFragment;
import android.app.Activity;

import java.util.Calendar;
import java.util.Locale;

public class TimePicker extends DialogFragment
        implements TimePickerDialog.OnTimeSetListener {

    private final Activity activity;
    private final long initialTime;

    private native void timeSelected(String time);
    private native void cancelled();

    public TimePicker(Activity activity, long initialTime) {
        super();
        this.activity = activity;
        this.initialTime = initialTime;
    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        Calendar cal = Calendar.getInstance();
        cal.setTimeInMillis(initialTime);
        return new TimePickerDialog(activity, this, cal.get(Calendar.HOUR_OF_DAY), cal.get(Calendar.MINUTE), true);
    }

    public void onTimeSet(android.widget.TimePicker view, int hourOfDay, int minute) {
        timeSelected(String.format(Locale.ENGLISH, "%02d:%02d", hourOfDay, minute));
    }

    @Override
    public void onCancel(DialogInterface dialog) {
        cancelled();
    }

    public void doShow() {
        show(activity.getFragmentManager(), "timePicker");
    }
}
