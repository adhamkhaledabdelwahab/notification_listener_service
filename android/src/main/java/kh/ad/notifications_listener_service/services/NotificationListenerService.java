package kh.ad.notifications_listener_service.services;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.service.notification.StatusBarNotification;
import android.util.Log;

import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import kh.ad.notifications_listener_service.models.NotificationModel;
import kh.ad.notifications_listener_service.utils.NotificationServiceFlutterEngineUtils;

@SuppressLint("LongLogTag")
public class NotificationListenerService
        extends android.service.notification.NotificationListenerService {
    private final String TAG = "NotificationListenerService";
    private Handler handler;
    private MethodChannel onNotificationChannel;

    @Override
    public void onCreate() {
        super.onCreate();
        initService();
        Log.i(TAG, "On Service Created");

    }

    private void initService() {
        Context mContext = this;
        handler = new Handler(Looper.getMainLooper());
        FlutterEngine engine = NotificationServiceFlutterEngineUtils.updateEngine(mContext);
        String RUN_DART_CHANNEL_NAME = "notifications_listener_service/RUN_DART_BACKGROUND_METHOD";
        onNotificationChannel = new MethodChannel(
                engine.getDartExecutor().getBinaryMessenger(),
                RUN_DART_CHANNEL_NAME
        );
    }

    @Override
    public void onNotificationPosted(StatusBarNotification sbn) {
        String appPackageName = getApplicationContext().getPackageName();
        String notificationPackageName = sbn.getPackageName();
        if (notificationPackageName.contains(appPackageName)) {
            String log = "On Notification Posted";
            String NOTIFICATION_POSTED_METHOD = "OnNotificationDisplay";
            onNotificationStateChange(sbn, log, NOTIFICATION_POSTED_METHOD);
        }
    }

    @Override
    public void onNotificationRemoved(StatusBarNotification sbn) {
        String appPackageName = getApplicationContext().getPackageName();
        String notificationPackageName = sbn.getPackageName();
        if (notificationPackageName.contains(appPackageName)) {
            String log = "On Notification Removed";
            String NOTIFICATION_REMOVED_METHOD = "OnNotificationRemove";
            onNotificationStateChange(sbn, log, NOTIFICATION_REMOVED_METHOD);
        }
    }

    private void onNotificationStateChange(
            StatusBarNotification sbn, String logMessage, String methodName) {
        try {
            handler.post(() -> {
                String state = "";
                if (logMessage.contains("Removed")) state = "remove";
                else if (logMessage.contains("Posted")) state = "post";
                Map<String, Object> map = NotificationModel.fromStatusBarNotification(sbn, state);
                onNotificationChannel.invokeMethod(methodName, map);
                Log.i(TAG, logMessage);
            });

        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
        }
    }

    @Override
    public void onDestroy() {
        handler = null;
        onNotificationChannel = null;
        Log.i(TAG, "On Service Destroyed");
        super.onDestroy();
    }
}
