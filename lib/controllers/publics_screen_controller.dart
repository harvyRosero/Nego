import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro/widgets/snackbars.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PublicScreenController extends GetxController {
  var publicaciones = <Map<String, dynamic>>[].obs;
  var empresas = <Map<String, dynamic>>[].obs;
  var filteredPublicaciones = <Map<String, dynamic>>[].obs;
  var selectedButton = 'Noticias'.obs;

  @override
  void onInit() {
    super.onInit();
    _getPublics();
    _getCompanies();
    ever(selectedButton, (_) => _filterPublicaciones());
  }

  Future<String?> getPhotoUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('photo');
  }

  void _getPublics() {
    FirebaseFirestore.instance.collection('publicaciones').snapshots().listen(
      (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          publicaciones.assignAll(
            querySnapshot.docs.map((doc) {
              var data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList(),
          );
          _filterPublicaciones();
        } else {
          publicaciones.clear();
          _filterPublicaciones();
        }
      },
      onError: (error) {
        SnackbarUtils.error('Error al obtener datos: $error');
      },
    );
  }

  void _getCompanies() {
    FirebaseFirestore.instance.collection('empresas').snapshots().listen(
      (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          empresas.assignAll(
            querySnapshot.docs.map((doc) {
              var data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList(),
          );
          _filterPublicaciones();
        } else {
          empresas.clear();
          _filterPublicaciones();
        }
      },
      onError: (error) {
        SnackbarUtils.error('Error al obtener datos: $error');
      },
    );
  }

  void selectButton(String text) {
    selectedButton.value = text;
  }

  void _filterPublicaciones() {
    if (selectedButton.value == 'Empresas') {
      filteredPublicaciones.assignAll(empresas);
    } else {
      filteredPublicaciones.assignAll(publicaciones);
    }
  }
}
