import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/utils/app_colors.dart';

class SnackbarUtils {
  static SnackbarController success(String message) {
    return Get.snackbar(
      "OK",
      message,
      backgroundColor: AppColors.verdeNavbar,
      colorText: Colors.white,
      duration: const Duration(seconds: 7),
    );
  }

  static SnackbarController error(String message) {
    return Get.snackbar(
      "Error",
      message,
      backgroundColor: const Color.fromARGB(253, 250, 17, 0),
      colorText: Colors.white,
    );
  }

  static SnackbarController warning(String message) {
    return Get.snackbar(
      "Advertencia",
      message,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  static SnackbarController info(String message) {
    return Get.snackbar(
      "Información",
      message,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }
}
