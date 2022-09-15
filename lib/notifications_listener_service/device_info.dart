const String _deviceSDK = "DEVICE_SDK";
const String _deviceRelease = "DEVICE_RELEASE";
const String _deviceBrand = "DEVICE_BRAND";
const String _deviceType = "DEVICE_TYPE";
const String _deviceId = "DEVICE_ID";
const String _deviceHardware = "DEVICE_HARDWARE";
const String _deviceManufacturer = "DEVICE_MANUFACTURER";
const String _deviceModel = "DEVICE_MODEL";
const String _deviceProduct = "DEVICE_PRODUCT";

class DeviceInfo {
  int? deviceSDK;
  String? deviceRelease;
  String? deviceBrand;
  String? deviceId;
  String? deviceHardware;
  String? deviceManufacturer;
  String? deviceModel;
  String? deviceProduct;
  String? deviceType;

  DeviceInfo({
    this.deviceSDK,
    this.deviceRelease,
    this.deviceBrand,
    this.deviceId,
    this.deviceHardware,
    this.deviceManufacturer,
    this.deviceModel,
    this.deviceProduct,
    this.deviceType,
  });

  factory DeviceInfo._fromMap(Map<dynamic, dynamic> map) {
    var info = DeviceInfo(
      deviceBrand: map[_deviceBrand],
      deviceHardware: map[_deviceHardware],
      deviceId: map[_deviceId],
      deviceManufacturer: map[_deviceManufacturer],
      deviceModel: map[_deviceModel],
      deviceProduct: map[_deviceProduct],
      deviceRelease: map[_deviceRelease],
      deviceSDK: map[_deviceSDK],
      deviceType: map[_deviceType],
    );
    return info;
  }

  static DeviceInfo newEvent(Map<dynamic, dynamic> data) {
    return DeviceInfo._fromMap(data);
  }

  @override
  String toString() {
    return 'Device Info => '
        '\ndevice_sdk = $deviceSDK'
        '\ndevice_release = $deviceRelease'
        '\ndevice_brand = $deviceBrand'
        '\ndevice_id = $deviceId'
        '\ndevice_hardware = $deviceHardware'
        '\ndevice_manufacturer = $deviceManufacturer'
        '\ndevice_model = $deviceModel'
        '\ndevice_product = $deviceProduct'
        '\ndevice_type = $deviceType';
  }
}
