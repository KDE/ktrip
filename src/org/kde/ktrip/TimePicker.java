/*
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

package org.kde.ktrip;

import android.app.TimePickerDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.app.DialogFragment;
import android.app.Activity;

import java.util.Calendar;

public class TimePicker extends DialogFragment
        implements TimePickerDialog.OnTimeSetListener {

    private Activity activity;
    private long initialTime;

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
        TimePickerDialog dialog = new TimePickerDialog(activity, this, cal.get(Calendar.HOUR_OF_DAY), cal.get(Calendar.MINUTE), true);
        return dialog;
    }

    public void onTimeSet(android.widget.TimePicker view, int hourOfDay, int minute) {

        // Add leading zero if needed
        String hourFormatted = Integer.toString(hourOfDay);
        if (hourOfDay < 10) {
            hourFormatted = "0" + hourFormatted;
        }

        String minuteFormatted = Integer.toString(minute);
        if (minute < 10) {
            minuteFormatted = "0" + minuteFormatted;
        }

        timeSelected(String.format("%s:%s", hourFormatted, minuteFormatted));
    }

    @Override
    public void onCancel(DialogInterface dialog) {
        cancelled();
    }

    public void doShow() {
        show(activity.getFragmentManager(), "timePicker");
    }
}
