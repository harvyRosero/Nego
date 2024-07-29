import 'package:agro/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/routes/app_routes.dart';

class PreLoginScreen extends StatelessWidget {
  const PreLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLogo(),
                const SizedBox(height: 5),
                _buildSubtitle(),
                const SizedBox(height: 50),
                _buildCreateAccountButton(),
                const SizedBox(height: 25),
                _buildLoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      height: 200,
      child: Image.asset('assets/logo_nego.png'),
    );
  }

  Widget _buildSubtitle() {
    return const Text(
      "Tu mercado local \n en línea.",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: AppColors.grisLetras,
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    return ElevatedButton(
      onPressed: () {
        Get.toNamed(AppRoutes.createAccount);
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.blanco,
        backgroundColor: AppColors.verdeNavbar,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 58.0, vertical: 12.0),
        child: Text(
          "Crear cuenta",
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {
        Get.toNamed(AppRoutes.login);
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.verdeNavbar,
        backgroundColor: AppColors.grisVerdoso,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 58.0, vertical: 12.0),
        child: Text(
          "Iniciar sesión",
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
