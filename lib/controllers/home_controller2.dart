import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro/widgets/snackbars.dart';

class HomeController2 extends GetxController {
  var isBottomNavVisible = true.obs; // Variable para controlar la visibilidad
  var publicaciones = <Map<String, dynamic>>[].obs;
  var isButtonSelected = 'true'.obs;
  var currentScreen = 'Home'.obs;

  @override
  void onInit() {
    super.onInit();
    getDataPublics();
  }

  void changeScreen(String screen) {
    currentScreen.value = screen;
  }

  Future<String?> getPhotoUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? photo = prefs.getString('photo');
    return photo;
  }

  Future<void> getDataPublics() async {
    try {
      CollectionReference publicacionesCollection =
          FirebaseFirestore.instance.collection('publicaciones');

      QuerySnapshot querySnapshot = await publicacionesCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        // Limpia la lista antes de agregar nuevos datos
        publicaciones.clear();
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          publicaciones.add(data);
        }
      } else {
        SnackbarUtils.error("No se encontraron datos");
      }
    } catch (e) {
      SnackbarUtils.error('Error al obtener datos, intente más tarde!');
    }
  }

  void toggleBottomNav(bool isVisible) {
    isBottomNavVisible.value = isVisible;
  }
}
