import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigAccountController extends GetxController {
  var userName = ''.obs;
  // var userId = ''.obs;

  // Método para actualizar el nombre de usuario en Firestore
  Future<void> updateUserName(String newUserName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? userId = prefs.getString('userId');
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'userName': newUserName});
      userName.value = newUserName;
      print("UserName updated successfully");
    } catch (e) {
      print("Failed to update userName: $e");
    }
  }
}
