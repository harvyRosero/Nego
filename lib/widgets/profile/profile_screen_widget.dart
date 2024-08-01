import 'package:agro/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/controllers/profile/profile_screen_controller.dart';
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
            const SizedBox(height: 50),
            _buildProfileImage(),
            const SizedBox(height: 10),
            _buildUserName(),
            const SizedBox(height: 5),
            _buildUserEmail(),
            const SizedBox(height: 20),
            _buildAddressInfo(),
            const SizedBox(height: 20),
            Obx(() => controller.lat.value.isEmpty
                ? Container()
                : _buildButton(
                    icon: Icons.location_on,
                    label: "Ver mi ubicación",
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.map2,
                        arguments: {
                          'lat': controller.lat.value,
                          'lng': controller.lng.value,
                        },
                      );
                    },
                  )),
            const SizedBox(height: 10),
            Obx(() => controller.direccion.value.isEmpty
                ? Container()
                : _buildButton(
                    icon: Icons.location_city,
                    label: "Editar ubicación",
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.configAddress,
                        arguments: {
                          'barrio': controller.barrio.value,
                          'direccion': controller.direccion.value,
                          'detallesDireccion': controller.detallesUbicacion,
                          'celular': controller.celular.value,
                        },
                      );
                    },
                  )),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            _buildButton(
              icon: Icons.settings_accessibility,
              label: "Configurar cuenta",
              onTap: () {
                Get.toNamed(
                  AppRoutes.configAccount,
                  arguments: {
                    'userName': controller.userName.value,
                    'gmail': controller.gmail.value,
                    'celular': controller.celular.value,
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            _buildButton(
              icon: Icons.list,
              label: "Historial de pedidos",
              onTap: () {
                Get.toNamed(AppRoutes.allOrders);
              },
            ),
            const SizedBox(height: 20),
            _buildButton(
              icon: Icons.notifications_active,
              label: "Notificaciones",
              onTap: () {
                Get.toNamed(AppRoutes.configNotifications);
              },
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            _buildButton(
              icon: Icons.support_agent,
              label: "Soporte",
              onTap: () {
                Get.toNamed(AppRoutes.support);
              },
            ),
            const SizedBox(height: 20),
            _buildButton(
              icon: Icons.security_rounded,
              label: "Políticas de seguridad",
              onTap: () {
                Get.toNamed(AppRoutes.termsAndPolitics);
              },
            ),
            const SizedBox(height: 20),
            _buildButton(
              icon: Icons.exit_to_app,
              label: "Cerrar sesión",
              onTap: controller.logout,
            ),
            const SizedBox(height: 20),
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
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.verdeNavbar,
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
            fontSize: 14,
            color: AppColors.verdeLetras,
          ),
        );
      }),
    );
  }

  Widget _buildAddressInfo() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.configAddress,
          arguments: {
            'barrio': controller.barrio.value,
            'direccion': controller.direccion.value,
            'detallesDireccion': controller.detallesUbicacion,
            'celular': controller.celular.value,
          },
        );
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
              fontSize: 14,
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
          controller.direccion.value.isNotEmpty
              ? controller.direccion.value
              : 'Aún no tiene ninguna dirección agregada.',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.grisLetras,
          ),
          maxLines: 1,
          textAlign: TextAlign.start,
        ),
        if (controller.direccion.value.isNotEmpty) ...[
          Row(
            children: [
              Text(
                controller.barrio.value,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.grisLetras,
                ),
                maxLines: 1,
                textAlign: TextAlign.start,
              ),
              const Text(" - "),
              Text(
                controller.ciudad.value,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.grisLetras,
                ),
                maxLines: 1,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
        if (controller.celular.value.isNotEmpty)
          Text(
            controller.celular.value,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.grisLetras,
            ),
          )
      ],
    );
  }

  Widget _buildButton(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(icon, color: AppColors.verdeNavbar),
          const SizedBox(width: 30),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, color: AppColors.grisLetras),
            ),
          ),
          const Icon(Icons.arrow_right_outlined, color: AppColors.verdeNavbar),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
