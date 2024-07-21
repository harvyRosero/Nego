import 'dart:io';
import 'package:flutter/material.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:agro/controllers/create_company_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:agro/widgets/snackbars.dart';

class CreateCompanyScreen extends StatelessWidget {
  CreateCompanyScreen({super.key});
  final CreateCompanyController createCompanyController =
      Get.put(CreateCompanyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [_buildPublishButton(context)],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 2.0, left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 10),
              _buildDescriptionField(),
              const SizedBox(height: 10),
              _buildInfoCompanyField(),
              const SizedBox(height: 10),
              _buildProductionInfoFields(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            XFile? image = await createCompanyController.getImage();
            if (image != null) {
              createCompanyController.selectedImage.value = image.path;
            }
          },
          child: CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.gris,
            child: Obx(() {
              final selectedImagePath =
                  createCompanyController.selectedImage.value;
              return selectedImagePath.isNotEmpty
                  ? ClipOval(
                      child: Image.file(
                        File(selectedImagePath),
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      ),
                    )
                  : const Icon(
                      Icons.add_a_photo_rounded,
                      size: 50,
                      color: Colors.black,
                    );
            }),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: createCompanyController.companyNameController,
            cursorColor: AppColors.gris,
            maxLines: 2,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              hintText: "Nombre de la empresa",
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Descripción:",
            style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: createCompanyController.descriptionController,
          cursorColor: Colors.grey,
          maxLines: 7,
          maxLength: 300,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
          decoration: const InputDecoration(
            hintText:
                "En Agrícola Los Campos Verdes, creemos en la transparencia y la calidad. Trabajamos mano a mano con nuestros agricultores para asegurar que cada producto que llega a su mesa ha sido cultivado con esmero y dedicación. Además, ofrecemos tours educativos en nuestra finca para que los clientes puedan conocer de cerca nuestro proceso de producción y nuestras prácticas sostenibles.",
            border: InputBorder.none,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCompanyField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Información empresarial:",
            style: TextStyle(fontWeight: FontWeight.bold)),
        _buildTextFieldWithIcon(Icons.email, "Correo electrónico",
            createCompanyController.emailController),
        _buildTextFieldWithIcon(Icons.phone_android, "Número de teléfono",
            createCompanyController.phoneController),
        _buildTextFieldWithIcon(Icons.map, "Departamento",
            createCompanyController.departmentController),
        _buildTextFieldWithIcon(
            Icons.location_city,
            "Ciudad, pueblo, vereda...",
            createCompanyController.cityController),
        _buildTextFieldWithIcon(Icons.location_history, "Dirección física",
            createCompanyController.addressController),
      ],
    );
  }

  Widget _buildProductionInfoFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Producción:",
            style: TextStyle(fontWeight: FontWeight.bold)),
        _buildTextFieldWithIcon(
            Icons.local_florist,
            "Tipo: Frutas, verduras, granos...",
            createCompanyController.productionTypeController),
        _buildTextFieldWithIcon(
            Icons.local_shipping,
            "Capacidad de producción: 1000 kg",
            createCompanyController.productionCapacityController),
      ],
    );
  }

  Widget _buildTextFieldWithIcon(
      IconData icon, String hintText, TextEditingController controller) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            cursorColor: Colors.grey,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPublishButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Obx(() {
        return ElevatedButton(
          onPressed: createCompanyController.isLoading.value
              ? null
              : () async {
                  if (createCompanyController.validateFields()) {
                    createCompanyController.validateFields();
                  } else {
                    SnackbarUtils.error("Ocurrio un error inesperado.(ccs)");
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: createCompanyController.isLoading.value
                ? Colors.grey
                : AppColors.verdeNavbar,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          ),
          child: createCompanyController.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  "Enviar",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        );
      }),
    );
  }
}
