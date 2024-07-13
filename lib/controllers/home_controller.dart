import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro/widgets/snackbars.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getDataPublic();
  }

  Future<String?> getPhotoUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? photo = prefs.getString('photo');

    return photo;
  }

  Future<List<Map<String, dynamic>>> getDataPublic() async {
    var publicaciones = <Map<String, dynamic>>[].obs;

    try {
      CollectionReference publicacionesCollection =
          FirebaseFirestore.instance.collection('publicaciones');

      QuerySnapshot querySnapshot = await publicacionesCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          publicaciones.add(data);
        }
      } else {
        SnackbarUtils.error("No se encontraron datos");
      }
      return publicaciones;
    } catch (e) {
      SnackbarUtils.error('Error al obtener datos, intente más tarde!');
      return [];
    }
  }
}
