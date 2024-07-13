import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agro/controllers/form_controller.dart';

class FormScreen extends StatelessWidget {
  final TextEditingController nombreFincaController = TextEditingController();
  final TextEditingController nombreTiendaController = TextEditingController();
  final TextEditingController ubicacionController = TextEditingController();
  final TextEditingController ciudadCercanaController = TextEditingController();
  final TextEditingController productoController = TextEditingController();
  final TextEditingController contactoController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController nombreConductorController =
      TextEditingController();
  final TextEditingController camionController = TextEditingController();
  final TextEditingController capacidadController = TextEditingController();
  final TextEditingController tipoCargaController = TextEditingController();

  final FormController formController = Get.put(FormController());

  FormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userType = Get.arguments ?? "Cargando...";

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(userType),
            const SizedBox(
              height: 5,
            ),
            _buildUserForm(userType),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String userType) {
    return Container(
      decoration: _buildBackgroundDecoration(),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Center(
            child: Text(
              userType,
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.w700,
                color: AppColors.blanco,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30.0),
        bottomRight: Radius.circular(30.0),
      ),
      gradient: LinearGradient(
        colors: [AppColors.verdeNavbar, AppColors.verdeNavbar2],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  Widget _buildUserForm(String userType) {
    switch (userType) {
      case 'Agricultor':
        return _buildAgricultorForm();
      case 'Transportista':
        return _buildTransportistaForm();
      default:
        return _buildStoreForm();
    }
  }

  Widget _buildAgricultorForm() {
    return Column(
      children: [
        _buildImageContainer(),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextFormField(nombreFincaController,
                  'Nombre (Ejemplo: Hacienda Napoles)', 30),
              _buildTextFormField(
                  descriptionController,
                  'Descripcion (Ejemplo: Somos una empresa agricultora dedicada a la produccion de papa con mas de 40 anios brindando nuestros productos a los bogotanos.)',
                  300),
              _buildTextFormField(
                  stateController, 'Departamento (Ejemplo: Meta)', 30),
              _buildTextFormField(ubicacionController,
                  'Ubicación (Ejemplo: Vereda San Juan)', 30),
              _buildTextFormField(ciudadCercanaController,
                  'Ciudad cercana (Ejemplo: Bogota)', 30),
              _buildTextFormField(productoController,
                  'Producto que produce (Ejmeplo: Papa)', 30),
              _buildTextFormField(statusController,
                  'Estado (Ejeplo: En siembra - En cosecha)', 20),
              _buildTextFormField(
                  contactoController, 'Contacto (Ejemplo: WhatsApp)', 30),
              const SizedBox(height: 20),
              Obx(() {
                return formController.isButtonSelected.value
                    ? const LinearProgressIndicator(
                        color: AppColors.verdeNavbar2,
                      )
                    : ElevatedButton(
                        style: _enviarButtonStyle,
                        onPressed: () {
                          formController.validateAndSendData(
                            nombreFincaController.text,
                            descriptionController.text,
                            stateController.text,
                            ubicacionController.text,
                            ciudadCercanaController.text,
                            productoController.text,
                            statusController.text,
                            contactoController.text,
                          );
                        },
                        child: const Text('Enviar'),
                      );
              })
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField(
      TextEditingController controller, String labelText, var numero) {
    return TextFormField(
      controller: controller,
      maxLines: null,
      maxLength: numero,
      style: GoogleFonts.openSans(fontSize: 14),
      decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.verdeButtons)),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.gris)),
          hintText: labelText,
          hintStyle: GoogleFonts.openSans(
              color: AppColors.grisLetras,
              fontSize: 13,
              fontStyle: FontStyle.italic)),
    );
  }

  Widget _buildTransportistaForm() {
    return Column(
      children: [
        _buildImageContainer(),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextFormField(
                  nombreConductorController, 'Nombre Conductor', 30),
              _buildTextFormField(
                  descriptionController,
                  'Presentacion (Ejemplo: Trabajo de lunes a viernes ...)',
                  300),
              _buildTextFormField(
                  camionController, 'Camion (Ejemplo: Hino Sg1a)', 50),
              _buildTextFormField(
                  ubicacionController, 'Ubicacion (Ciudad, pueblo)', 30),
              _buildTextFormField(
                  stateController, 'Departamento (Ejmplo: Meta)', 30),
              _buildTextFormField(capacidadController,
                  'capacidad de carga (Ejemplo: 500 Kg)', 30),
              _buildTextFormField(
                  tipoCargaController,
                  'Tipo de carga (Ejemplo : refrigerantes, animales, productos)',
                  30),
              _buildTextFormField(
                  contactoController, 'Contacto (WhatsApp)', 30),
              const SizedBox(height: 20),
              Obx(() {
                return formController.isButtonSelected.value
                    ? const LinearProgressIndicator(
                        color: AppColors.verdeNavbar2,
                      )
                    : ElevatedButton(
                        style: _enviarButtonStyle,
                        onPressed: () {
                          formController.validateAndSendDataTransportist(
                              nombreConductorController.text,
                              descriptionController.text,
                              camionController.text,
                              ubicacionController.text,
                              stateController.text,
                              capacidadController.text,
                              tipoCargaController.text,
                              contactoController.text);
                        },
                        child: const Text('Enviar'),
                      );
              })
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStoreForm() {
    return Column(
      children: [
        _buildImageContainer(),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextFormField(nombreTiendaController, 'Tienda', 30),
              _buildTextFormField(descriptionController, 'Descripcion', 300),
              _buildTextFormField(stateController, 'Departamento', 20),
              _buildTextFormField(ubicacionController, 'Direccion', 50),
              _buildTextFormField(contactoController, 'Contacto', 30),
              const SizedBox(height: 20),
              Obx(() {
                return formController.isButtonSelected.value
                    ? const LinearProgressIndicator(
                        color: AppColors.verdeNavbar2,
                      )
                    : ElevatedButton(
                        style: _enviarButtonStyle,
                        onPressed: () {
                          formController.validateAndSendDataStore(
                            nombreTiendaController.text,
                            descriptionController.text,
                            ubicacionController.text,
                            stateController.text,
                            contactoController.text,
                          );
                        },
                        child: const Text('Enviar'),
                      );
              })
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageContainer() {
    return GestureDetector(
      onTap: () async {
        XFile? image = await formController.getImage();
        if (image != null) {
          formController.selectedImage.value = image.path;
        }
      },
      child: Stack(
        children: [
          Container(height: 230),
          Obx(() {
            final selectedImagePortadaPath =
                formController.selectedImagePortada.value;
            return GestureDetector(
              onTap: () async {
                XFile? image = await formController.getImagePortada();
                if (image != null) {
                  formController.selectedImagePortada.value = image.path;
                }
              },
              child: SizedBox(
                height: 180,
                child: selectedImagePortadaPath.isNotEmpty
                    ? Image.file(
                        File(selectedImagePortadaPath),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 180,
                      )
                    : Container(
                        color: AppColors.gris,
                        child: const Center(
                            child: Icon(
                          Icons.add_a_photo,
                          size: 60,
                        )),
                      ),
              ),
            );
          }),
          Positioned(
            bottom: 5,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(
                2,
              ), // Ajusta el espacio entre el borde y el avatar
              decoration: BoxDecoration(
                color: AppColors.blanco, // Color del borde
                shape: BoxShape.circle, // Forma del borde
                border: Border.all(
                  color: AppColors.blanco, // Color del borde
                  width: 2, // Ancho del borde
                ),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Obx(() {
                  final selectedImagePath = formController.selectedImage.value;
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
          ),
        ],
      ),
    );
  }

// Estilo reciclado para el botón "Enviar"
  final _enviarButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: AppColors.verdeButtons,
    backgroundColor: AppColors.verdeNavbar2,
    textStyle: GoogleFonts.openSans(fontSize: 17, fontWeight: FontWeight.bold),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
  );
}
