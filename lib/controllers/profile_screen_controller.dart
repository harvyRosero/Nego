import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agro/routes/app_routes.dart';

class ProfileScreenWidgetController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var urlPhoto = ''.obs;
  var userName = ''.obs;
  var gmail = ''.obs;
  var ubicacion = ''.obs;
  var userData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
    fetchUserData();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    urlPhoto.value = prefs.getString('perfilImg') ?? '';
    gmail.value = prefs.getString('gmail') ?? '';
    userName.value = prefs.getString('userName') ?? '';
    ubicacion.value = prefs.getString('ubicacion') ?? '';
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await _auth.signOut();
    prefs.clear();
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> fetchUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        userData.value = userDoc.data() as Map<String, dynamic>;
        String userName = userData['userName'];
        String gmail = userData['email'];
        String perfilImg = userData['perfilImg'];
        String ubicacion = userData['ubicacion'];
        String ciudad = userData['ciudad'];
        String barrio = userData['barrio'];
        String detallesUbicacion = userData['detallesUbicacion'];
        String celular = userData['celular'];

        prefs.setString('userName', userName);
        prefs.setString('gmail', gmail);
        prefs.setString('perfilImg', perfilImg);
        prefs.setString('ubicacion', ubicacion);
        prefs.setString('ciudad', ciudad);
        prefs.setString('barrio', barrio);
        prefs.setString('detallesUbicacion', detallesUbicacion);
        prefs.setString('celular', celular);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user data: $e');
    }
  }
}
