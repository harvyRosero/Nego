import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/controllers/login_controller.dart';
import 'package:agro/utils/app_colors.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/login_img.jpg'),
                  fit: BoxFit.cover)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo u otros elementos de diseño
                // ...

                const SizedBox(height: 600),

                // Botón de inicio de sesión con Google
                ElevatedButton.icon(
                  onPressed: () async {
                    // await _authController.signInWithGoogle();
                    controller.login();
                  },
                  icon: Image.asset(
                    'assets/gmail_logo.png',
                    height: 24, // Ajusta el tamaño según sea necesario
                    width: 24,
                  ),
                  label: const Text(
                    'Iniciar Sesión con Google',
                    style: TextStyle(color: AppColors.marron),
                  ),
                ),

                const SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
