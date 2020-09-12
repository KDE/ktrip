/*
 * SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

 package org.kde.ktrip;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.app.DialogFragment;
import android.app.Activity;

import java.util.Calendar;
import java.util.Locale;

public class DatePicker extends DialogFragment implements DatePickerDialog.OnDateSetListener {

    private final Activity activity;
    private final long initialDate;

    private native void dateSelected(String date);
    private native void cancelled();

    public DatePicker(Activity activity, long initialDate) {
        super();
        this.activity = activity;
        this.initialDate = initialDate;
    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        Calendar cal = Calendar.getInstance();
        cal.setTimeInMillis(initialDate);
        return new DatePickerDialog(activity, this, cal.get(Calendar.YEAR), cal.get(Calendar.MONTH), cal.get(Calendar.DAY_OF_MONTH));
    }

    @Override
    public void onCancel(DialogInterface dialog) {
        cancelled();
    }

    public void onDateSet(android.widget.DatePicker view, int year, int month, int day) {
        // Android reports month starting with 0
        dateSelected(String.format(Locale.ENGLISH, "%4d-%02d-%02d", year, month+1, day));
    }

    public void doShow() {
        show(activity.getFragmentManager(), "datePicker");
    }

}
