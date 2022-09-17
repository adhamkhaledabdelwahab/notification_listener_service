package kh.ad.notifications_listener_service.utils;

import android.content.Context;
import android.content.SharedPreferences;

public class SharedPreferencesUtils {
    private final SharedPreferences preferences;
    private static final String SHARED_PREFERENCE_NAME = "NotificationCallback";
    private static final String SHARED_PREFERENCE_CALLBACK_KEY = "OnReceiveNotification";
    private static SharedPreferencesUtils instance;

    private SharedPreferencesUtils(Context context) {
        preferences = context.getSharedPreferences(SHARED_PREFERENCE_NAME, Context.MODE_PRIVATE);
    }

    public static synchronized SharedPreferencesUtils getInstance(Context context) {
        if (instance == null) {
            instance = new SharedPreferencesUtils(context);
        }
        return instance;
    }

    public void saveNotificationCallback(long val) {
        SharedPreferences.Editor editor = preferences.edit();
        editor.putLong(SHARED_PREFERENCE_CALLBACK_KEY, val);
        editor.apply();
    }

    public Long getNotificationCallback() {
        try {
            long result = preferences.getLong(SHARED_PREFERENCE_CALLBACK_KEY, 0L);
            if (result == 0L) {
                throw new Exception("No Callback Method exists");
            }
            return result;
        } catch (Exception e) {
            return null;
        }
    }
}
