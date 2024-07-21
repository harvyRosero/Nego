import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro/widgets/snackbars.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:agro/models/company_model.dart';
import 'package:agro/routes/app_routes.dart';

class CreateCompanyController extends GetxController {
  RxString selectedImage = RxString('');
  RxString selectedImagePortada = RxString('');
  RxBool isButtonSelected = false.obs;
  var isLoading = false.obs;

  // TextEditingControllers for form fields
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController productionTypeController =
      TextEditingController();
  final TextEditingController productionCapacityController =
      TextEditingController();

  Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = image.path;
    } else {
      SnackbarUtils.info('No se seleccionó ninguna imagen');
    }
    return image;
  }

  Future<String> sendImage() async {
    String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference storageReference = FirebaseStorage.instance.ref();
    Reference referenceDirImages = storageReference.child('companyLogos');

    Reference referenceImagesToUpload =
        referenceDirImages.child(uniqueFileName);

    try {
      await referenceImagesToUpload.putFile(File(selectedImage.value));
      String downloadURL = await referenceImagesToUpload.getDownloadURL();
      return downloadURL; // La imagen se cargó con éxito
    } catch (e) {
      isButtonSelected.value = false;
      SnackbarUtils.error('¡Ocurrió un error inesperado!');
      return '';
    }
  }

  bool validateFields() {
    isLoading.value = true;
    if (companyNameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        departmentController.text.isEmpty ||
        cityController.text.isEmpty ||
        addressController.text.isEmpty ||
        productionTypeController.text.isEmpty ||
        productionCapacityController.text.isEmpty) {
      SnackbarUtils.error('Por favor, complete todos los campos');
      isLoading.value = false;
      return false;
    }
    if (selectedImage.value.isEmpty) {
      SnackbarUtils.error('Por favor, seleccione una imagen');
      isLoading.value = false;
      return false;
    }
    sendCompanyDataToFirebase();
    return true;
  }

  void sendCompanyDataToFirebase() async {
    String logoUrl = await sendImage();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('uid');

    if (userId == null) {
      SnackbarUtils.error('User ID is not available');
      isLoading.value = false;
      return;
    }

    DateTime now = DateTime.now();
    int day = now.day;
    int month = now.month;
    int year = now.year;

    CompanyData companyData = CompanyData(
        logoUrl: logoUrl,
        companyName: companyNameController.text,
        description: descriptionController.text,
        email: emailController.text,
        phone: phoneController.text,
        department: departmentController.text,
        city: cityController.text,
        address: addressController.text,
        productType: productionTypeController.text,
        capacity: productionCapacityController.text,
        createdAt: '$day/$month/$year');

    Map<String, dynamic> dataMap = companyData.toMap();

    FirebaseFirestore.instance
        .collection('empresas')
        .doc(userId) // Use userId as the document ID
        .set(dataMap)
        .then((value) {
      SnackbarUtils.success('¡Datos enviados correctamente!');
      Get.offAllNamed(AppRoutes.home);
    }).catchError((error) {
      isButtonSelected.value = false;
      SnackbarUtils.error('¡Ocurrió un error al enviar los datos!');
      isLoading.value = false;
    });
  }
}
