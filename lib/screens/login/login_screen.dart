import 'package:agro/controllers/login/login_controller.dart';
import 'package:agro/routes/app_routes.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeText(),
                const SizedBox(height: 40),
                _buildEmailTextField(),
                const SizedBox(height: 16),
                Obx(() {
                  return controller.modeForgetPass.value
                      ? Container()
                      : _buildPasswordTextField();
                }),
                const SizedBox(height: 5),
                _buildForgotPasswordRow(),
                const SizedBox(height: 60),
                _buildLoginButton(),
                const SizedBox(height: 15),
                _buildRegisterRow(),
                const SizedBox(height: 5),
                _buildDividerRow(),
                const SizedBox(height: 20),
                _buildGoogleLoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Obx(() {
      return controller.isLoadingButton.value
          ? const LinearProgressIndicator(
              color: AppColors.verdeNavbar,
            )
          : Text(
              'Bienvenido',
              style: GoogleFonts.montserrat(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.verdeNavbar,
              ),
            );
    });
  }

  Widget _buildEmailTextField() {
    return TextField(
      controller: controller.gmailController,
      decoration: InputDecoration(
        hintText: 'Correo',
        hintStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Obx(() {
      return TextField(
        controller: controller.passwordController,
        obscureText: !controller.isPasswordVisible.value,
        decoration: InputDecoration(
          hintText: 'Contraseña',
          hintStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              controller.isPasswordVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            color: AppColors.verdeNavbar,
            onPressed: () {
              controller.isPasswordVisible.value =
                  !controller.isPasswordVisible.value;
            },
          ),
        ),
      );
    });
  }

  Widget _buildForgotPasswordRow() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          controller.modeForgetPass.value
              ? GestureDetector(
                  onTap: () {
                    controller.modeForgetPass.value = false;
                  },
                  child: const Text(
                    "Iniciar sesion",
                    style:
                        TextStyle(fontSize: 15, color: AppColors.verdeNavbar),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    controller.modeForgetPass.value = true;
                  },
                  child: const Text(
                    "¿Olvidó su contraseña?",
                    style:
                        TextStyle(fontSize: 12, color: AppColors.verdeNavbar),
                  ),
                ),
        ],
      );
    });
  }

  Widget _buildLoginButton() {
    return Obx(() {
      return controller.modeForgetPass.value
          ? SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.resetPassword();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.blanco,
                  backgroundColor: AppColors.verdeNavbar,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 13.0),
                  child: Text(
                    "Recuperar contraseña",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            )
          : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.isLoadingButton.value = true;
                  controller.validateData();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.blanco,
                  backgroundColor: AppColors.verdeNavbar,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 13.0),
                  child: Text(
                    "Iniciar sesión",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            );
    });
  }

  Widget _buildRegisterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '¿Aun no tienes cuenta?  ',
          style: TextStyle(fontSize: 10, color: AppColors.grisLetras),
        ),
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.createAccount);
          },
          child: Text(
            "Regístrate Aquí",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: AppColors.verdeNavbar,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDividerRow() {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.verdeNavbar,
          ),
        ),
        Text(
          "  o  ",
          style: TextStyle(color: AppColors.verdeNavbar),
        ),
        Expanded(
          child: Divider(
            color: AppColors.verdeNavbar,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleLoginButton() {
    return Obx(() {
      return controller.modeForgetPass.value
          ? Container()
          : Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  controller.loginWithGmail();
                },
                icon: Image.asset(
                  'assets/gmail_logo.png',
                  height: 24,
                  width: 24,
                ),
                label: const Text(
                  'Iniciar Sesión con Google',
                  style: TextStyle(color: AppColors.grisLetras),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.grisLetras,
                  backgroundColor: AppColors.blanco,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8), // Cambiar el radio de borde si es necesario
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12), // Cambiar el padding si es necesario
                ),
              ),
            );
    });
  }
}
