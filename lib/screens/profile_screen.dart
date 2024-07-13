import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/controllers/profile_controller.dart';
import 'package:agro/controllers/login_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:agro/routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController _profileController = Get.put(ProfileController());
  final LoginController _loginController = Get.put(LoginController());

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: FutureBuilder<Map<String, String?>>(
        future: _profileController.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final userData = snapshot.data!;
            final photo = userData['photo'];
            final name = userData['name'];
            final gmail = userData['gmail'];

            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage('$photo'),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    '$name',
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$gmail',
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
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
                          text: 'Empresa Agricultora',
                          icon: Icons.eco,
                          onTap: () {
                            Get.toNamed(AppRoutes.form,
                                arguments: "Empresa Agricultora");
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildButton(
                          text: 'Transportista',
                          icon: Icons.local_shipping,
                          onTap: () {
                            Get.toNamed(AppRoutes.form,
                                arguments: "Transportista");
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildButton(
                          text: 'Tienda Agrícola',
                          icon: Icons.shopping_basket,
                          onTap: () {
                            Get.toNamed(AppRoutes.form,
                                arguments: "Tienda Agricola");
                          },
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _loginController.logout();
                      },
                      icon: const Icon(Icons.logout_outlined))
                ],
              ),
            );
          }
        },
      )),
    );
  }
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
