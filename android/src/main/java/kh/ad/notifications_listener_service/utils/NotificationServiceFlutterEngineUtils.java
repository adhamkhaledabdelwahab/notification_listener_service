package kh.ad.notifications_listener_service.utils;

import android.annotation.SuppressLint;
import android.content.Context;

import androidx.annotation.NonNull;

import io.flutter.FlutterInjector;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.view.FlutterCallbackInformation;

public class NotificationServiceFlutterEngineUtils {
//    private static final String FlutterEngineKey = "kh.ad.notifications_listener_service/FlutterEngineKey";

    @SuppressLint("LongLogTag")
    public static FlutterEngine updateEngine(@NonNull Context context) {
        FlutterEngine engine = null;
        engine = new FlutterEngine(context);
        long callback = context.getSharedPreferences("NotificationCallback",
                Context.MODE_PRIVATE).getLong("OnReceiveNotification", 0L);
        if (callback != 0L) {
            FlutterCallbackInformation callbackInformation =
                    FlutterCallbackInformation.lookupCallbackInformation(callback);
            DartExecutor.DartCallback dartCallback = new DartExecutor
                    .DartCallback(context.getAssets(),
                    context.getPackageCodePath(), callbackInformation);
            engine.getDartExecutor().executeDartCallback(dartCallback);
        }


        if (!engine.getAccessibilityChannel().flutterJNI.isAttached()) {
            FlutterInjector.instance().flutterLoader().startInitialization(context);
            FlutterInjector.instance().flutterLoader().ensureInitializationComplete(context, new String[]{});
            engine.getAccessibilityChannel().flutterJNI.attachToNative();
        }
        return engine;
    }
}
