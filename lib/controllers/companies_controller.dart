import 'package:get/get.dart';

class CompaniesController extends GetxController {
  var isButton1Enabled = true.obs;
  var isButton2Enabled = false.obs;
  var isButton3Enabled = false.obs;

  // Método para activar o desactivar el primer botón
  void toggleButton1() {
    isButton1Enabled.value = true;
    isButton2Enabled.value = false;
    isButton3Enabled.value = false;
  }

  // Método para activar o desactivar el segundo botón
  void toggleButton2() {
    isButton2Enabled.value = true;
    isButton1Enabled.value = false;
    isButton3Enabled.value = false;
  }

  void toggleButton3() {
    isButton3Enabled.value = true;
    isButton2Enabled.value = false;
    isButton1Enabled.value = false;
  }
}
