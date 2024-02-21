import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;

  Future<String?> getPhotoUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? photo = prefs.getString('photo');

    return photo;
  }
}
