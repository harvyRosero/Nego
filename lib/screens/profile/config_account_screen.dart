import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/controllers/profile/config_account_controller.dart';
import 'package:agro/utils/app_colors.dart';

class ConfigAccountScreen extends StatelessWidget {
  ConfigAccountScreen({super.key});

  final ConfigAccountController controller = Get.put(ConfigAccountController());

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;
    final String userName = arguments['userName'] ?? '';
    final String gmail = arguments['gmail'] ?? '';
    final String celular = arguments['celular'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi cuenta"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextLabel('Nombre y apellido'),
              const SizedBox(height: 10),
              _buildTextField(
                textController: controller.userNameController,
                hintText: userName,
                icon: Icons.person,
              ),
              const SizedBox(height: 20),
              _buildTextLabel('Correo electrónico'),
              const SizedBox(height: 10),
              _buildInfoContainer(
                text: gmail,
                icon: Icons.email,
              ),
              const SizedBox(height: 20),
              _buildTextLabel('Número de celular'),
              const SizedBox(height: 10),
              _buildTextField(
                textController: controller.phoneNumberController,
                hintText: celular,
                icon: Icons.phone,
              ),
              const SizedBox(height: 40),
              _buildResetPasswordContainer(context, gmail),
              const SizedBox(height: 40),
              _buildSendButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, color: AppColors.verdeLetras),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    required TextEditingController textController,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grisClaro,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: hintText,
            icon: Icon(icon, color: AppColors.verdeNavbar),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoContainer({
    required String text,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grisClaro,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18),
        child: Row(
          children: [
            Icon(icon, color: AppColors.verdeNavbar),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetPasswordContainer(BuildContext context, String gmail) {
    return GestureDetector(
      onTap: () {
        controller.currentEmailController.text = gmail;
        controller.showEmailInputDialog(context);
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Icon(
              Icons.key,
              color: AppColors.verdeNavbar,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(child: Text("Cambiar contraseña")),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.verdeNavbar,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Validar y actualizar datos
          controller.validateData();
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.verdeNavbar, // Color del texto
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.update, size: 20), // Icono de actualización
            SizedBox(width: 10),
            Text(
              'Actualizar Datos',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
