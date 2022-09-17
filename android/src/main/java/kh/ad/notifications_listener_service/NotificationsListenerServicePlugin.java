package kh.ad.notifications_listener_service;

import android.annotation.SuppressLint;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodChannel;
import kh.ad.notifications_listener_service.utils.NotificationServiceMethodCallHandler;

/**
 * NotificationsListenerServicePlugin
 */
@SuppressLint("LongLogTag")
public class NotificationsListenerServicePlugin implements FlutterPlugin {
    private MethodChannel channel;
    private NotificationServiceMethodCallHandler handler;
    private final String TAG = "NotificationsListenerServicePlugin";

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        Context mContext = flutterPluginBinding.getApplicationContext();
        String FOREGROUND_METHOD = "notifications_listener_service/RUN_NATIVE_FOREGROUND_METHOD";
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), FOREGROUND_METHOD);
        handler = new NotificationServiceMethodCallHandler(mContext, TAG);
        channel.setMethodCallHandler(handler);
        Log.i(TAG, "On Attached To Engine");
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        channel = null;
        handler = null;
        Log.i(TAG, "On Detached From Engine");
    }

}
