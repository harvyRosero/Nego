import 'package:agro/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:agro/controllers/profile/notifications_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfigNotificationsScreen extends StatelessWidget {
  ConfigNotificationsScreen({super.key});

  final ConfigNotificationsController notificationsController =
      Get.put(ConfigNotificationsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              Text(
                "¿Cómo quieres recibir nuestras notificaciones?",
                style: GoogleFonts.montserrat(
                  color: AppColors.verdeNavbar,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Las notificaciones incluyen información importante sobre tus pedidos y promociones que pueden ser de tu interés. \nTe recomendamos tener al menos una activa.",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.verdeLetras,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              Obx(() => NotificationOption(
                    icon: Icons.email,
                    label: "E-mail",
                    isActive: notificationsController.emailNotification.value,
                    onToggle: notificationsController.toggleEmailNotification,
                  )),
              const SizedBox(height: 10),
              Obx(() => NotificationOption(
                    icon: Icons.phone,
                    label: "SMS",
                    isActive: notificationsController.smsNotification.value,
                    onToggle: notificationsController.toggleSmsNotification,
                  )),
              const SizedBox(height: 10),
              Obx(() => NotificationOption(
                    icon: Icons.smartphone_sharp,
                    label: "WhatsApp",
                    isActive:
                        notificationsController.whatsappNotification.value,
                    onToggle:
                        notificationsController.toggleWhatsappNotification,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onToggle;

  const NotificationOption({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.verdeNavbar2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.verdeNavbar),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.verdeNavbar,
                fontSize: 17,
              ),
            ),
          ),
          Icon(
            isActive ? Icons.toggle_on : Icons.toggle_off,
            size: 40,
            color: isActive ? Colors.green : Colors.grey,
          ),
        ],
      ),
    );
  }
}
