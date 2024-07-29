import 'package:agro/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro/widgets/snackbars.dart';
import 'package:agro/utils/app_colors.dart';

class CreateAccountController extends GetxController {
  RxBool isCheckBoxSelected = false.obs;
  RxBool isCheckBoxSelected2 = true.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isLoadingButton = false.obs;
  RxBool isUserNameValid = false.obs;
  RxBool isGmailValid = false.obs;
  RxBool isPasswordValid = false.obs;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController gmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;
  RxString termsAndConditions = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    userNameController.addListener(() {
      isUserNameValid.value = userNameController.text.isNotEmpty;
    });
    gmailController.addListener(() {
      isGmailValid.value = validateEmail(gmailController.text.trim());
    });
    passwordController.addListener(() {
      isPasswordValid.value = validatePassword(passwordController.text);
    });
  }

  bool validateEmail(String email) {
    String newEmail = email.replaceAll(' ', '');
    if (isEmail(newEmail)) {
      emailError.value = '';
      return true;
    } else {
      emailError.value = 'Correo inválido';
      return false;
    }
  }

  bool validatePassword(String password) {
    if (password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]'))) {
      passwordError.value = '';
      return true;
    } else {
      passwordError.value =
          'La contraseña debe tener al menos 8 caracteres, incluyendo letras mayúsculas, minúsculas y números.';
      return false;
    }
  }

  Future<void> validateData() async {
    // Activar el estado de carga del botón
    isLoadingButton.value = true;

    if (validatePassword(passwordController.text) &&
        validateEmail(gmailController.text) &&
        userNameController.text.isNotEmpty) {
      _showTermsAndConditionsDialog();
    } else {
      SnackbarUtils.info("¡Debes llenar todos los campos!");
      isLoadingButton.value = false;
    }

    // Intentar crear el usuario en Firebase
  }

  Future<void> sendDataToFirebase() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: gmailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Enviar mensaje de verificación de correo electrónico
      await userCredential.user!.sendEmailVerification();

      // Guardar información adicional del usuario en Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'userName': userNameController.text.trim(),
        'email': gmailController.text.trim(),
        'ubicacion': '',
        'perfilImg': '',
        'celular': '',
        'ciudad': '',
        'barrio': '',
        'detallesUbicacion': '',
        'maps': ''
      });

      SnackbarUtils.success(
          'Cuenta creada exitosamente. Por favor, revisa tu correo electrónico y verifica tu cuenta.');
      Get.offAllNamed(AppRoutes.login);

      // Limpiar los controladores de texto
      userNameController.clear();
      gmailController.clear();
      passwordController.clear();
    } catch (e) {
      SnackbarUtils.error(
          '¡Error al crear la cuenta! \n Puede que este correo ya este registrado');
    } finally {
      // Desactivar el estado de carga del botón
      isLoadingButton.value = false;
    }
  }

  Future<void> _fetchData() async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('DataApp')
          .doc('tyc') // Asegúrate de que el documento tenga este ID
          .get();
      if (document.exists) {
        termsAndConditions.value = document['version1'];
      } else {
        termsAndConditions.value = 'No se encontraron términos y condiciones.';
      }
    } catch (e) {
      termsAndConditions.value = 'Error al cargar los datos.';
    }
  }

  Future<void> _showTermsAndConditionsDialog() async {
    _fetchData();
    return Get.dialog(
      AlertDialog(
        title: const Text(
          'Términos y Condiciones',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  termsAndConditions.value.replaceAll('\n\n', ' '),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w300),
                )
              ],
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              isLoadingButton.value = false;
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              sendDataToFirebase();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.blanco,
              backgroundColor: AppColors.azulClaro,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}
