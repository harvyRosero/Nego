import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  var currentScreen = 'Home'.obs;
  var isBottomNavVisible = true.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var userData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchUserData();
  }

  void toggleBottomNav(bool isVisible) {
    isBottomNavVisible.value = isVisible;
  }

  void changeScreen(String screen) {
    currentScreen.value = screen;
  }

  Future<void> _fetchUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId').toString();
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        userData.value = userDoc.data() as Map<String, dynamic>;
        String userName = userData['userName'];
        String gmail = userData['email'];
        String perfilImg = userData['perfilImg'];
        String direccion = userData['direccion'];
        String ciudad = userData['ciudad'];
        String barrio = userData['barrio'];
        String detallesUbicacion = userData['detallesUbicacion'];
        String celular = userData['celular'];
        String lat = userData['lat'];
        String lng = userData['lng'];

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userId', userId);
        prefs.setString('userName', userName);
        prefs.setString('gmail', gmail);
        prefs.setString('perfilImg', perfilImg);
        prefs.setString('direccion', direccion);
        prefs.setString('ciudad', ciudad);
        prefs.setString('barrio', barrio);
        prefs.setString('detallesUbicacion', detallesUbicacion);
        prefs.setString('celular', celular);
        prefs.setString('lat', lat);
        prefs.setString('lng', lng);
      }
    } catch (e) {
      Get.snackbar('Error (lsc)', 'No se pudo obtener datos de usuario.');
    }
  }
}
