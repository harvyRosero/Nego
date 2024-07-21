import 'package:get/get.dart';

class AddAdController extends GetxController {
  var currentScreen = 'Add'.obs;
  var isButtonSelected = 'true'.obs;

  void changeScreen(String screen) {
    currentScreen.value = screen;
  }
}
