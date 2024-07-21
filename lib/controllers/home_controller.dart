import 'package:get/get.dart';

class HomeController extends GetxController {
  var currentScreen = 'Home'.obs;
  var isBottomNavVisible = true.obs;

  void toggleBottomNav(bool isVisible) {
    isBottomNavVisible.value = isVisible;
  }

  void changeScreen(String screen) {
    currentScreen.value = screen;
  }
}
