package kh.ad.notifications_listener_service.models;

import android.os.Build;

import java.util.HashMap;
import java.util.Map;

public class DeviceInfoModel {

    private static final String DEVICE_SDK = "DEVICE_SDK";
    private static final String DEVICE_RELEASE = "DEVICE_RELEASE";
    private static final String DEVICE_BRAND = "DEVICE_BRAND";
    private static final String DEVICE_TYPE = "DEVICE_TYPE";
    private static final String DEVICE_ID = "DEVICE_ID";
    private static final String DEVICE_HARDWARE = "DEVICE_HARDWARE";
    private static final String DEVICE_MANUFACTURER = "DEVICE_MANUFACTURER";
    private static final String DEVICE_MODEL = "DEVICE_MODEL";
    private static final String DEVICE_PRODUCT = "DEVICE_PRODUCT";

    public static Map<String, Object> getDeviceInfo() {
        Map<String, Object> map = new HashMap<>();
        map.put(DEVICE_SDK, Build.VERSION.SDK_INT);
        map.put(DEVICE_RELEASE, Build.VERSION.RELEASE);
        map.put(DEVICE_BRAND, Build.BRAND);
        map.put(DEVICE_TYPE, Build.DEVICE);
        map.put(DEVICE_ID, Build.ID);
        map.put(DEVICE_HARDWARE, Build.HARDWARE);
        map.put(DEVICE_MANUFACTURER, Build.MANUFACTURER);
        map.put(DEVICE_MODEL, Build.MODEL);
        map.put(DEVICE_PRODUCT, Build.PRODUCT);
        return map;
    }

}
