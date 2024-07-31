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
      // Pasa la función _sendDataToFirebase como argumento
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
    await _fetchData();
    return Get.dialog(
      AlertDialog(
        title: const Text(
          'Términos y Condiciones',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Obx(() {
            return Text(
              termsAndConditions.value.replaceAll('\n\n', ' '),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
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
            onPressed: () async {
              Get.back();
              // Llama a la función pasada como argumento
              await onAccept();
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

  Future<void> _fetchData() async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('DataApp')
          .doc('tyc')
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
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
