import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();
  static int _id = 0;
  static const String groupKey = 'group key';
  static const String groupChannelId = 'grouped channel id';
  static const String groupChannelName = 'grouped channel name';
  static const String groupChannelDescription = 'grouped channel description';

  static Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          groupChannelId,
          groupChannelName,
          channelDescription: groupChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
          groupKey: groupKey,
        ),
        iOS: DarwinNotificationDetails(
            categoryIdentifier: 'plainCategory',
            threadIdentifier: 'thread id'));
  }

  static Future init() async {
    final settings = InitializationSettings(
        android: const AndroidInitializationSettings('@mipmap/launcher_icon'),
        iOS: DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: (int id, String? title, String? body,
                String? payload) async {
              _notifications.show(_id++, title, body, await _notificationDetails(),
                  payload: payload);
            }));
    await _notifications.initialize(settings, onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {
      onNotifications.add(notificationResponse.payload);
    });
  }

  static Future clearAllNotifications() async {
    _id = 0;
    await _notifications.cancelAll();
  }

  static Future showNotification(
          {int id = 0, String? title, String? body, String? payload}) async =>
      _notifications.show(_id++, title, body, await _notificationDetails(),
          payload: payload);
}
