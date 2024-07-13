import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  Future<Map<String, String?>> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? photo = prefs.getString('photo');
    String? name = prefs.getString('name');
    String? gmail = prefs.getString('gmail');

    return {
      'photo': photo,
      'name': name,
      'gmail': gmail,
    };
  }
}
