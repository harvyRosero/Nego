import 'package:agro/routes/app_routes.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agro/widgets/snackbars.dart';

class ConfigAccountController extends GetxController {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController currentEmailController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  void validateData() {
    if (userNameController.text.isEmpty && phoneNumberController.text.isEmpty) {
      SnackbarUtils.info('No se detectaron datos para actualizar.');
      return;
    }

    if (userNameController.text.isNotEmpty) {
      _updateUserName(userNameController.text);
    }

    if (phoneNumberController.text.isNotEmpty) {
      _updatePhoneNumber(phoneNumberController.text);
    }
  }

  Future<void> _updateUserName(String newUserName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? userId = prefs.getString('userId');
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'userName': newUserName});
      Get.offAllNamed(AppRoutes.home);

      SnackbarUtils.success("Nombre y apellido fueron actualizados");
    } catch (e) {
      SnackbarUtils.error("No se pudo actualizar datos");
    }
  }

  Future<void> _updatePhoneNumber(String newPhoneNumber) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? userId = prefs.getString('userId');
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'celular': newPhoneNumber});
      SnackbarUtils.success("Numero de celular actualizado");
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      SnackbarUtils.error("No se pudo actualizar datos");
    }
  }

  void showEmailInputDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            'Ingrese su correo electrónico',
            style: TextStyle(color: AppColors.verdeNavbar),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  hintText: 'ejemplo@correo.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon:
                      const Icon(Icons.email, color: AppColors.verdeNavbar),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.verdeNavbar),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.offAllNamed(AppRoutes.home);
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: AppColors.verdeNavbar),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String email = emailController.text;
                if (email.isNotEmpty) {
                  if (email == currentEmailController.text) {
                    _resetPassword(email);
                  } else {
                    SnackbarUtils.info('Tu correo electronico no coincide');
                  }
                } else {
                  SnackbarUtils.info('este campo no puede estar vacio');
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.verdeNavbar,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _resetPassword(String gmail) async {
    try {
      await auth.sendPasswordResetEmail(email: gmail);

      _logout();
      SnackbarUtils.success(
          "Se ha enviado un correo para restablecer tu contraseña. Por favor, revisa tu bandeja de entrada.");
    } catch (e) {
      SnackbarUtils.error(
          "Error al enviar el correo de restablecimiento de contraseña. Por favor, intenta de nuevo.");
    }
  }

  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await auth.signOut();
    prefs.clear();
    Get.offAllNamed(AppRoutes.login);
  }
}
