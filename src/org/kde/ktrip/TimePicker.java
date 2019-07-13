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
        TimePickerDialog dialog = new TimePickerDialog(activity, this, cal.get(Calendar.HOUR), cal.get(Calendar.MINUTE), true);
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