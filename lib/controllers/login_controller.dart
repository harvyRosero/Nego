import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agro/routes/app_routes.dart';
import 'package:agro/widgets/snackbars.dart';

class LoginController extends GetxController {
  RxBool isLoggedIn = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }

  User? get currentUser => user.value;

  void login() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;
      final credential2 = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential2);
      prefs.setString('gmail', currentUser!.email.toString());
      prefs.setString('photo', currentUser!.photoURL.toString());
      prefs.setString('name', currentUser!.displayName.toString());
      prefs.setString('uid', currentUser!.uid.toString());
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      SnackbarUtils.error(
          '¡Ocurrio un error inesperado!, revisa tu conexion y vuelve  a intentarlo');
    }
  }

  Future<bool> checkUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? gmail = prefs.getString('gmail');

    if (gmail != null) {
      return true;
    } else {
      return false;
    }
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Lógica para cerrar sesión.
    prefs.clear();
    await _auth.signOut();
    Get.offAllNamed(AppRoutes.login);
  }
}
