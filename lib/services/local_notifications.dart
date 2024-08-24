import 'package:flutter_local_notifications/flutter_local_notifications.dart';

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void initializeNotifications() {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}
