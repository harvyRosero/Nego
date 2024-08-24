import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotificationsController extends GetxController {
  var notifications = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notificationsList = prefs.getStringList('notifications') ?? [];

    notifications.value = notificationsList.map((notification) {
      return Map<String, String>.from(json.decode(notification));
    }).toList();
  }

  Future<void> removeNotification(int index) async {
    notifications.removeAt(index);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notificationsList = notifications.map((notification) {
      return json.encode(notification);
    }).toList();
    await prefs.setStringList('notifications', notificationsList);
  }
}
