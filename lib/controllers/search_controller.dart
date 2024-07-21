import 'package:get/get.dart';

class MySearchController extends GetxController {
  var currentScreen = 'home'.obs;

  void changeScreen(String screen) {
    currentScreen.value = screen;
  }
}
