import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationsProvider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initNotifications() {
    _initialize();
  }

  void _initialize() {
    _requestPermission();
    _getTokenAndUpdateFirestore();
    _setupMessageListeners();
  }

  void _requestPermission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _getTokenAndUpdateFirestore() async {
    final token = await _firebaseMessaging.getToken();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');
    try {
      if (userId != null && token != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'token': token});
      }
    } catch (e) {
      Get.snackbar("ERROR", "No se pudo actualizar datos");
    }
  }

  void _setupMessageListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        await _saveNotificationLocally(
          message.notification!.title!,
          message.notification!.body!,
        );

        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'your_channel_id', // ID del canal
          'your_channel_name', // Nombre del canal
          channelDescription:
              'your_channel_description', // Descripción del canal
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          icon: 'logo_nego', // Aquí se especifica el ícono
        );
        const NotificationDetails platformChannelSpecifics =
            NotificationDetails(
          android: androidPlatformChannelSpecifics,
        );

        await flutterLocalNotificationsPlugin.show(
          0, // ID de la notificación
          message.notification!.title, // Título de la notificación
          message.notification!.body, // Cuerpo de la notificación
          platformChannelSpecifics,
          payload: 'item x', // Datos opcionales que puedes enviar
        );
      }
    });
  }

  Future<void> _saveNotificationLocally(String title, String body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList('notifications') ?? [];
    final orderDate = DateTime.now().toIso8601String();

    String newNotification =
        '{"title": "$title", "body": "$body", "date": "$orderDate"}';
    notifications.add(newNotification);

    await prefs.setStringList('notifications', notifications);
  }
}
