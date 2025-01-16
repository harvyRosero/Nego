import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro/widgets/snackbars.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:agro/routes/app_routes.dart';

class CreateAccountController extends GetxController {
  RxBool isPasswordVisible = false.obs;
  RxBool isLoadingButton = false.obs;
  RxBool isUserNameValid = false.obs;
  RxBool isGmailValid = false.obs;
  RxBool isPasswordValid = false.obs;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController gmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();

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
    isLoadingButton.value = true;

    if (validatePassword(passwordController.text) &&
        validateEmail(gmailController.text) &&
        userNameController.text.isNotEmpty) {
      await _showTermsAndConditionsDialog(_sendDataToFirebase);
    } else {
      SnackbarUtils.info("¡Debes llenar todos los campos!");
      isLoadingButton.value = false;
    }
  }

  void showTermsAndConditionsDialogFromGmailButton() {
    _showTermsAndConditionsDialog(_registerWithGmail);
  }

  Future<void> _showTermsAndConditionsDialog(
      Future<void> Function() onAccept) async {
    return Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título del diálogo
              const Text(
                'Términos y Condiciones',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),

              // Descripción inicial
              const Text(
                "Antes de continuar, te invitamos a leer nuestros Términos y Condiciones. \nAl aceptar, confirmarás estar de acuerdo con nuestras políticas, las cuales estarán vigentes de inmediato. Esto nos ayuda a garantizar una experiencia segura, transparente y confiable para todos los usuarios.",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () {
                  // Get.to(() => TermsAndConditionsScreen());
                  Get.toNamed(AppRoutes.termsAndPolitics);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gris,
                  foregroundColor: AppColors.blanco,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                icon: const Icon(Icons.description_outlined, size: 20),
                label: const Text(
                  'Leer Términos y Condiciones',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 30),

              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón de cancelar
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  // Botón de aceptar
                  ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      await onAccept();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.verdeNavbar,
                      foregroundColor: AppColors.blanco,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                    ),
                    child: const Text(
                      'Aceptar',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendDataToFirebase() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: gmailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await userCredential.user!.sendEmailVerification();

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'userName': userNameController.text.trim(),
        'email': gmailController.text.trim(),
        'direccion': '',
        'perfilImg': '',
        'celular': '',
        'ciudad': '',
        'barrio': '',
        'detallesUbicacion': '',
        'lat': '',
        'lng': '',
        'token': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      SnackbarUtils.success(
          'Cuenta creada exitosamente. Por favor, revisa tu correo electrónico y verifica tu cuenta.');
      Get.offAllNamed(AppRoutes.login);

      userNameController.clear();
      gmailController.clear();
      passwordController.clear();
    } catch (e) {
      SnackbarUtils.error(
          '¡Error al crear la cuenta! \n Puede que este correo ya este registrado');
    } finally {
      isLoadingButton.value = false;
    }
  }

  Future<void> _registerWithGmail() async {
    try {
      final GoogleSignInAccount? gUser = await googleSignIn.signIn();
      if (gUser == null) {
        SnackbarUtils.info('Registro cancelado.');
        return;
      }
      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final bool userExists = await checkIfUserExists(userCredential.user!.uid);
      if (userExists) {
        SnackbarUtils.info('La cuenta ya existe, por favor inicia sesión.');
        await googleSignIn.signOut();
        return;
      }

      await saveUserDataToFirestore(userCredential.user!);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', userCredential.user!.uid);

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      SnackbarUtils.error(
          '¡Ocurrió un error inesperado!, revisa tu conexión y vuelve a intentarlo');
    }
  }

  Future<bool> checkIfUserExists(String uid) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc.exists;
  }

  Future<void> saveUserDataToFirestore(User user) async {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    await userDoc.set({
      'userName': user.displayName,
      'email': user.email,
      'perfilImg': user.photoURL,
      'barrio': '',
      'celular': '',
      'ciudad': '',
      'detallesUbicacion': '',
      'direccion': '',
      'lat': '',
      'lng': '',
      'token': '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
