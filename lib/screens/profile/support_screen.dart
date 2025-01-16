import 'package:agro/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:agro/controllers/profile/support_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportScreen extends StatelessWidget {
  SupportScreen({super.key});

  final SupportController supportController = Get.put(SupportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contáctanos"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            _buildTitle(),
            const SizedBox(height: 10),
            _buildSubtitle("Escríbenos"),
            const SizedBox(height: 10),
            Obx(() {
              return _buildContactOption(
                label: supportController.whatsapp.value,
                imageUrl:
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/WhatsApp_icon.png/598px-WhatsApp_icon.png',
              );
            }),
            const SizedBox(height: 20),
            _buildSubtitle("Comunicate con nosotros"),
            const SizedBox(height: 10),
            Obx(() {
              return _buildContactDetail(
                label: 'E-mail',
                value: supportController.gmail.value.isEmpty
                    ? 'No se encontro gmail'
                    : supportController.gmail.value,
              );
            }),
            const SizedBox(height: 5),
            Obx(() {
              return _buildContactDetail(
                label: 'Teléfono',
                value: supportController.telefono.value.isEmpty
                    ? 'No se encontro telefono'
                    : supportController.telefono.value,
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "¿Tienes problemas o necesitas nuestra ayuda?",
      style: GoogleFonts.montserrat(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        height: 1.2,
        color: AppColors.verdeNavbar,
      ),
    );
  }

  Widget _buildSubtitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.verdeNavbar,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _buildContactOption(
      {required String label, required String imageUrl}) {
    return GestureDetector(
      onTap: () {
        // Aquí puedes añadir la lógica para manejar el tap
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.grisClaro,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: Image.network(imageUrl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactDetail({required String label, required String value}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.grisClaro,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
