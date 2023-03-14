package kh.ad.notifications_listener_service.receivers;

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import kh.ad.notifications_listener_service.utils.NotificationServiceUtils;

public class NotificationBroadcastReceiver extends BroadcastReceiver {

    @SuppressLint("LongLogTag")
    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction().equals(Intent.ACTION_REBOOT) ||
                intent.getAction().equals(Intent.ACTION_BOOT_COMPLETED)) {
            if (NotificationServiceUtils.isNotificationServiceEnabled(context) &&
                    !NotificationServiceUtils.isServiceRunning(context)) {
                NotificationServiceUtils.startService(context);
            }
        } else {
            String TAG = "NotificationBroadcastReceiver";
            Log.i(TAG, intent.getAction());
        }
    }
}
