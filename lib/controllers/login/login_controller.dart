import 'package:agro/routes/app_routes.dart';
import 'package:agro/widgets/snackbars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  RxBool isLoggedIn = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool modeForgetPass = false.obs;
  RxBool isLoadingButton = false.obs;
  var userData = {}.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<User?> user = Rx<User?>(null);

  final TextEditingController gmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }

  User? get currentUser => user.value;

  Future<void> validateData() async {
    if (passwordController.text.isEmpty || gmailController.text.isEmpty) {
      SnackbarUtils.info("Debe llenar todos los campos");
      isLoadingButton.value = false;
      return;
    }
    if (!gmailController.text.trim().isEmail) {
      SnackbarUtils.info("Formato de correo invalido");
      isLoadingButton.value = false;
      return;
    }

    await login();
  }

  Future<void> login() async {
    try {
      isLoadingButton.value = true;

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: gmailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!userCredential.user!.emailVerified) {
        SnackbarUtils.info('Por favor, verifica tu correo electrónico.');
        await userCredential.user!.sendEmailVerification();
        isLoadingButton.value = false;
        return;
      }

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        SnackbarUtils.info('No se encontró la información del usuario.');
        isLoadingButton.value = false;
        return;
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', userCredential.user!.uid);
      Get.offAllNamed(AppRoutes.home);

      gmailController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        SnackbarUtils.error(
            'Credenciales inválidas. Por favor, intenta de nuevo.');
      } else {
        SnackbarUtils.error(
          '¡Error al iniciar sesión!, revisa tus credenciales',
        );
      }
    } catch (e) {
      SnackbarUtils.error('¡Error al iniciar sesión! $e.');
    } finally {
      isLoadingButton.value = false;
    }
  }

  Future<void> loginWithGmail() async {
    try {
      final GoogleSignInAccount? gUser = await googleSignIn.signIn();
      if (gUser == null) {
        SnackbarUtils.info('Iniciar sesión cancelado.');
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
      if (!userExists) {
        SnackbarUtils.info('La cuenta no existe, por favor regístrate.');
        await googleSignIn.signOut();
        return;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', userCredential.user!.uid);

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      SnackbarUtils.error(
          '¡Ocurrió un error inesperado!, revisa tu conexión y vuelve a intentarlo');
    }
  }

  Future<void> resetPassword() async {
    isLoadingButton.value = true;
    if (gmailController.text.isEmpty) {
      SnackbarUtils.warning('Debe digitar su correo electronico');
      isLoadingButton.value = false;
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: gmailController.text.trim());
      SnackbarUtils.success(
          "Se ha enviado un correo para restablecer tu contraseña. Por favor, revisa tu bandeja de entrada.");
      gmailController.text = "";
      modeForgetPass.value = false;
      isLoadingButton.value = false;
    } catch (e) {
      SnackbarUtils.error(
          "Error al enviar el correo de restablecimiento de contraseña. Por favor, intenta de nuevo.");
      isLoadingButton.value = false;
    }
  }

  Future<bool> checkUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('gmail') != null;
  }

  Future<bool> checkIfUserExists(String uid) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc.exists;
  }
}
