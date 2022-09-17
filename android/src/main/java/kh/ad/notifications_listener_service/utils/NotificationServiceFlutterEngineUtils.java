package kh.ad.notifications_listener_service.utils;

import android.annotation.SuppressLint;
import android.content.Context;

import androidx.annotation.NonNull;

import io.flutter.FlutterInjector;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.view.FlutterCallbackInformation;

public class NotificationServiceFlutterEngineUtils {

    @SuppressLint("LongLogTag")
    public static FlutterEngine updateEngine(@NonNull Context context) {
        FlutterEngine engine;
        engine = new FlutterEngine(context);
        Long callback = SharedPreferencesUtils.getInstance(context).getNotificationCallback();
        if (callback != null) {
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
