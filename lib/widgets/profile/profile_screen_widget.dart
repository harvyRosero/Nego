import 'package:agro/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/controllers/profile_screen_controller.dart';
import 'package:agro/utils/app_colors.dart';

class ProfileScreenWidget extends StatelessWidget {
  final Function(ScrollNotification) onScroll;
  final ProfileScreenWidgetController controller =
      Get.put(ProfileScreenWidgetController());

  ProfileScreenWidget({super.key, required this.onScroll});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          onScroll(scrollInfo);
          return false;
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          children: [
            const SizedBox(height: 20),
            _buildProfileImage(),
            const SizedBox(height: 10),
            _buildUserName(),
            const SizedBox(height: 5),
            _buildUserEmail(),
            const SizedBox(height: 20),
            _buildAddressInfo(),
            const SizedBox(height: 20),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Obx(() {
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[200],
        child: controller.urlPhoto.value.isNotEmpty
            ? ClipOval(
                child: Image.network(
                  controller.urlPhoto.value,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(
                Icons.person,
                size: 50,
                color: Colors.grey,
              ),
      );
    });
  }

  Widget _buildUserName() {
    return Center(
      child: Obx(() {
        return Text(
          controller.userName.value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        );
      }),
    );
  }

  Widget _buildUserEmail() {
    return Center(
      child: Obx(() {
        return Text(
          controller.gmail.value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        );
      }),
    );
  }

  Widget _buildAddressInfo() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.configAddress);
      },
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: AppColors.verdeNavbar,
            width: 2.0,
          ),
        ),
        child: Obx(() {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.add_home_outlined,
                  size: 35,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAddressHeader(),
                      _buildAddressContent(),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAddressHeader() {
    return const Row(
      children: [
        Expanded(
          child: Text(
            'Dirección',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Icon(Icons.arrow_drop_down),
      ],
    );
  }

  Widget _buildAddressContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.ubicacion.value.isNotEmpty
              ? controller.ubicacion.value
              : 'Aún no tiene ninguna dirección agregada.',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.grisLetras,
          ),
          textAlign: TextAlign.start,
        ),
        if (controller.ubicacion.value.isNotEmpty) ...[
          const Row(
            children: [
              Text(
                'barrio',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grisLetras,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(width: 10),
              Text(
                'ciudad',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grisLetras,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: controller.logout,
      child: const Text('Cerrar sesión'),
    );
  }
}
