import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/controllers/profile/config_address_controller.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:agro/screens/profile/map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConfigAddressScreen extends StatelessWidget {
  final ConfigAddressController configAddressController =
      Get.put(ConfigAddressController());

  ConfigAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;
    final barrio = arguments['barrio'];
    final direccion = arguments['direccion'];
    final detallesDireccion = arguments['detallesDireccion'];
    final celular = arguments['celular'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blanco,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Text(
              "Agregar dirección",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildDropdown(),
            const SizedBox(height: 10),
            _buildUbicationMap(context),
            const SizedBox(height: 10),
            _buildTextField("Barrio", barrio.toString(),
                configAddressController.barrioController),
            const SizedBox(height: 10),
            _buildTextField("Dirección", direccion.toString(),
                configAddressController.direccionController),
            const SizedBox(height: 10),
            _buildTextField(
                "Detalles dirección: casa verde junto a...",
                detallesDireccion.toString(),
                configAddressController.detallesDireccionController,
                hintSize: 13),
            const SizedBox(height: 10),
            _buildTextField("Celular", celular.toString(),
                configAddressController.celularController),
            const SizedBox(height: 20),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.grisClaro,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Obx(() {
          return DropdownButton<Map<String, dynamic>>(
            hint: const Text('Ciudad'),
            value: configAddressController.selectedLocation.value == null
                ? null
                : configAddressController.locations.firstWhere((location) =>
                    location['lat'] ==
                        configAddressController
                            .selectedLocation.value!.latitude &&
                    location['lng'] ==
                        configAddressController
                            .selectedLocation.value!.longitude),
            items: configAddressController.locations.map((location) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: location,
                child: Text(location['name']),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                configAddressController.selectLocation(value);
              }
            },
          );
        }),
      ),
    );
  }

  Widget _buildUbicationMap(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.grisClaro,
      ),
      child: Obx(() {
        return GestureDetector(
          onTap: configAddressController.selectedLocation.value == null
              ? () {
                  Get.snackbar('¡Acción inválida!',
                      'Primero debe seleccionar una ciudad.');
                }
              : () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen(
                        location:
                            configAddressController.selectedLocation.value!,
                      ),
                    ),
                  );
                  if (result != null && result is LatLng) {
                    configAddressController.setLocation(result);
                  }
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Row(
              children: [
                Expanded(
                    child: Text(configAddressController
                                .selectedLocationMarker.value !=
                            ''
                        ? configAddressController.selectedLocationMarker.value
                        : 'Ubicacion en el mapa.')),
                const Icon(Icons.map_rounded),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextField(
      String hintText, String value, TextEditingController controller,
      {double hintSize = 13}) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.grisClaro,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: value != '' ? "$hintText: $value" : hintText,
            hintStyle: TextStyle(fontSize: hintSize, color: AppColors.gris),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
          ),
          style: const TextStyle(fontSize: 13, height: 1.5),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          configAddressController.validateData();
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
            "Enviar Ubicacion",
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
