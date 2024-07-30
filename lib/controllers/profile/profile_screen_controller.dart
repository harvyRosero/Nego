import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agro/routes/app_routes.dart';

class ProfileScreenWidgetController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var urlPhoto = ''.obs;
  var userName = ''.obs;
  var gmail = ''.obs;
  var direccion = ''.obs;
  var lng = ''.obs;
  var lat = ''.obs;
  var ciudad = ''.obs;
  var celular = ''.obs;
  var detallesUbicacion = ''.obs;
  var barrio = ''.obs;
  var userData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    urlPhoto.value = prefs.getString('perfilImg') ?? '';
    gmail.value = prefs.getString('gmail') ?? '';
    userName.value = prefs.getString('userName') ?? '';
    direccion.value = prefs.getString('direccion') ?? '';
    lat.value = prefs.getString('lat') ?? '';
    lng.value = prefs.getString('lng') ?? '';
    detallesUbicacion.value = prefs.getString('detallesUbicacion') ?? '';
    ciudad.value = prefs.getString('ciudad') ?? '';
    celular.value = prefs.getString('celular') ?? '';
    barrio.value = prefs.getString('barrio') ?? '';
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await _auth.signOut();
    prefs.clear();
    Get.offAllNamed(AppRoutes.login);
  }
}
