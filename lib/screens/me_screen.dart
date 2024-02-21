import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:agro/routes/app_routes.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Crear cuenta como:',
            style: GoogleFonts.openSans(
              color: AppColors.gris,
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
          ),
          const SizedBox(height: 30),
          _buildButton(
            text: 'Agricultor',
            icon: Icons.eco,
            onTap: () {
              Get.toNamed(AppRoutes.form, arguments: "Agricultor");
            },
          ),
          const SizedBox(height: 20),
          _buildButton(
            text: 'Transportista',
            icon: Icons.local_shipping,
            onTap: () {
              Get.toNamed(AppRoutes.form, arguments: "Transportista");
            },
          ),
          const SizedBox(height: 20),
          _buildButton(
            text: 'Tienda Agrícola',
            icon: Icons.shopping_basket,
            onTap: () {
              Get.toNamed(AppRoutes.form, arguments: "Tienda Agricola");
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 1),
            ),
          ],
          color: AppColors.verdeNavbar2,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppColors.verdeNavbar,
              size: 30.0,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: GoogleFonts.openSans(
                color: AppColors.verdeNavbar,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
