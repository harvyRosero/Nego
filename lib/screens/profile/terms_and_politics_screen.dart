import 'package:agro/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:agro/controllers/profile/terms_and_politics_controller.dart';
import 'package:get/get.dart';

class TermsAndPoliticsScreen extends StatelessWidget {
  TermsAndPoliticsScreen({super.key});
  final TermsAndPoliticsController termsAndPoliticsController =
      Get.put(TermsAndPoliticsController());

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(20),
          contentPadding: EdgeInsets.zero,
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              child: Text(
                content,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.verdeNavbar, // Color del botón
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Políticas de privacidad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Obx(() {
              return _buildButton(
                context,
                'Términos y condiciones',
                Icons.article,
                termsAndPoliticsController.tyc.value,
              );
            }),
            const SizedBox(height: 10),
            Obx(() {
              return _buildButton(
                context,
                'Política de privacidad',
                Icons.privacy_tip,
                termsAndPoliticsController.pdp.value,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String text, IconData icon, String content) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showDialog(context, text, content),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.grisClaro2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          textStyle: const TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: AppColors.verdeNavbar),
            Text(text, style: const TextStyle(color: AppColors.verdeNavbar)),
            const Icon(Icons.arrow_forward_ios, color: AppColors.verdeNavbar),
          ],
        ),
      ),
    );
  }
}
