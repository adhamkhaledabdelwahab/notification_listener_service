const String _notificationId = "NOTIFICATION_ID";
const String _notificationPostTime = "NOTIFICATION_POST_TIME";
const String _notificationKey = "NOTIFICATION_KEY";
const String _notificationTag = "NOTIFICATION_TAG";
const String _notificationPackageName = "NOTIFICATION_PACKAGE_NAME";
const String _notificationState = "NOTIFICATION_STATE";

enum NotificationState {
  post,
  remove,
}

class NotificationEvent {
  int? id;
  String? postTime;
  String? key;
  String? tag;
  String? createdAt;
  String? packageName;
  NotificationState? state;

  NotificationEvent({
    this.id,
    this.postTime,
    this.key,
    this.tag,
    this.createdAt,
    this.packageName,
    this.state,
  });

  static NotificationState? _fetchNotificationState(dynamic state) {
    String val = state;
    if (val == "post") {
      return NotificationState.post;
    } else if (val == "remove") {
      return NotificationState.remove;
    } else {
      return null;
    }
  }

  factory NotificationEvent._fromMap(Map<dynamic, dynamic> map) {
    var evt = NotificationEvent(
      createdAt: DateTime.now().toString(),
      id: map[_notificationId],
      packageName: map[_notificationPackageName],
      postTime: DateTime.fromMillisecondsSinceEpoch(
        (map[_notificationPostTime] as int),
      ).toString(),
      key: map[_notificationKey],
      tag: map[_notificationTag],
      state: _fetchNotificationState(map[_notificationState]),
    );
    return evt;
  }

  static NotificationEvent newEvent(Map<dynamic, dynamic> data) {
    return NotificationEvent._fromMap(data);
  }

  @override
  String toString() {
    return "Notification => "
        "\nid = $id"
        "\npost_time = $postTime"
        "\nkey = $key"
        "\ntag = $tag"
        "\ncreated_at = $createdAt"
        "\npackage_name = $packageName"
        "\nnotification_state = $state.";
  }
}
