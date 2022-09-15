package kh.ad.notifications_listener_service.receivers;

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import kh.ad.notifications_listener_service.services.NotificationListenerService;
import kh.ad.notifications_listener_service.utils.NotificationServicePermissionUtils;

public class NotificationBroadcastReceiver extends BroadcastReceiver {

    @SuppressLint("LongLogTag")
    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction().equals(Intent.ACTION_REBOOT) ||
                intent.getAction().equals(Intent.ACTION_BOOT_COMPLETED)) {
            if (NotificationServicePermissionUtils.isNotificationServiceEnabled(context)) {
                Intent intent1 = new Intent(context, NotificationListenerService.class);
                context.startService(intent1);
            }
        } else {
            String TAG = "NotificationBroadcastReceiver";
            Log.i(TAG, intent.getAction());
        }
    }
}
