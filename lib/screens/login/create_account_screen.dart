import 'package:agro/routes/app_routes.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agro/controllers/login/create_account_controller.dart';

class CreateAccountScreen extends StatelessWidget {
  CreateAccountScreen({super.key});
  final CreateAccountController createAccountController =
      Get.put(CreateAccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLogo(),
                const SizedBox(height: 10),
                _buildTitle(),
                const SizedBox(height: 15),
                _buildUserNameTextField(),
                const SizedBox(height: 15),
                _buildEmailTextField(),
                const SizedBox(height: 15),
                _buildPassTextField(),
                const SizedBox(height: 3),
                const Text(
                    ' La contraseña debe tener al menos 8 caracteres, incluyendo letras mayúsculas, minúsculas y números.',
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grisLetras)),
                const SizedBox(height: 25),
                _buildCreateAccountButton(),
                const SizedBox(height: 15),
                _buildLoginPrompt(),
                const SizedBox(height: 15),
                _buildGoogleRegisterButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "¡Gasta menos y compra más en nuestro mercado digital!",
      style: GoogleFonts.montserrat(
        fontWeight: FontWeight.w900,
        fontSize: 18,
        color: AppColors.verdeNavbar,
      ),
    );
  }

  Widget _buildEmailTextField() {
    return Obx(() {
      return TextField(
        controller: createAccountController.gmailController,
        decoration: InputDecoration(
          hintText: 'Correo',
          hintStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: createAccountController.isGmailValid.value
              ? AppColors.verdeClaro
              : Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
      );
    });
  }

  Widget _buildUserNameTextField() {
    return Obx(() {
      return TextField(
        controller: createAccountController.userNameController,
        decoration: InputDecoration(
          hintText: 'Nombre completo',
          hintStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: createAccountController.isUserNameValid.value
              ? AppColors.verdeClaro
              : Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
      );
    });
  }

  Widget _buildPassTextField() {
    return Obx(() {
      return TextField(
        controller: createAccountController.passwordController,
        obscureText: !createAccountController.isPasswordVisible.value,
        decoration: InputDecoration(
          hintText: 'Contraseña',
          hintStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: createAccountController.isPasswordValid.value
              ? AppColors.verdeClaro
              : Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              createAccountController.isPasswordVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: AppColors.verdeNavbar,
            ),
            onPressed: () {
              createAccountController.isPasswordVisible.value =
                  !createAccountController.isPasswordVisible.value;
            },
          ),
        ),
      );
    });
  }

  Widget _buildCreateAccountButton() {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: createAccountController.isLoadingButton.value
            ? const LinearProgressIndicator(
                color: AppColors.verdeNavbar,
              )
            : ElevatedButton(
                onPressed: () {
                  createAccountController.validateData();
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
                    "Crear cuenta",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
      );
    });
  }

  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '¿Ya tienes cuenta?  ',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: AppColors.verdeLetras,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.login);
          },
          child: Text(
            'Ingresa con tu cuenta',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: AppColors.verdeNavbar,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleRegisterButton() {
    return Center(
        child: ElevatedButton.icon(
      onPressed: () async {
        createAccountController.showTermsAndConditionsDialogFromGmailButton();
      },
      icon: Image.asset(
        'assets/gmail_logo.png',
        height: 24,
        width: 24,
      ),
      label: const Text(
        'Crear cuenta con Google',
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.grisLetras,
        backgroundColor: AppColors.blanco,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              8), // Cambiar el radio de borde si es necesario
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12), // Cambiar el padding si es necesario
      ),
    ));
  }

  Widget _buildLogo() {
    return SizedBox(
      height: 60,
      child: Center(child: Image.asset('assets/logo_sl_green.png')),
    );
  }
}
