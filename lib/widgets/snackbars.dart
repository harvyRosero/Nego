import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/utils/app_colors.dart';

class SnackbarUtils {
  static SnackbarController success(String message) {
    return Get.snackbar(
      "OK",
      message,
      icon: const Icon(Icons.check_circle, color: AppColors.blanco),
      backgroundColor: AppColors.verdeSuccess,
      colorText: AppColors.blanco,
      duration: const Duration(seconds: 8),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  static SnackbarController error(String message) {
    return Get.snackbar(
      "Error",
      message,
      icon: const Icon(Icons.error, color: AppColors.blanco),
      backgroundColor: AppColors.rojoError,
      colorText: AppColors.blanco,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  static SnackbarController warning(String message) {
    return Get.snackbar(
      "Advertencia",
      message,
      icon: const Icon(Icons.warning, color: AppColors.blanco),
      backgroundColor: AppColors.naranjaAdvertencia,
      colorText: AppColors.blanco,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  static SnackbarController info(String message) {
    return Get.snackbar(
      "Información",
      message,
    );
  }
}
