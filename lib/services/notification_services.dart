import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings("@mipmap/ic_launcher");

  void initialisationSet() async {
    InitializationSettings initializationSettings =
        InitializationSettings(android: _androidInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void sendNotification(String title, String body,int valueProcess) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("channelId", "channelName",
            importance: Importance.max, priority: Priority.high,showProgress: true,
                maxProgress: 10,
                progress: valueProcess);
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
   await _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }


void secheduleSendNotification(String title, String body, dynamic scheduledDate , int valueProcess) async {
    AndroidNotificationDetails androidNotificationDetails =
         AndroidNotificationDetails("channelId", "channelName",
            importance: Importance.max, priority: Priority.high,showProgress: true,
                maxProgress: 10,
                progress: valueProcess);
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
   await _flutterLocalNotificationsPlugin.schedule(0, title, body, scheduledDate, notificationDetails);
  }

}
