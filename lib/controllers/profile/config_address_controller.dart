import 'package:agro/routes/app_routes.dart';
import 'package:agro/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigAddressController extends GetxController {
  var locations = <Map<String, dynamic>>[].obs;
  var selectedLocation = Rx<LatLng?>(null);
  var currentLocation = Rx<LatLng?>(null);
  var selectedLocationMarker = ''.obs;
  var selectedLatMarker = ''.obs;
  var selectedLngMarker = ''.obs;
  var selectedCity = ''.obs;

  final TextEditingController barrioController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController detallesDireccionController =
      TextEditingController();
  final TextEditingController celularController = TextEditingController();

  void setLocation(LatLng location) {
    currentLocation.value = location;
  }

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }

  void fetchLocations() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('ciudades').get();
    var fetchedLocations = snapshot.docs.map((doc) {
      var data = doc.data();
      return {
        'name': doc.id,
        'lat': double.parse(data['lat']),
        'lng': double.parse(data['lng']),
      };
    }).toList();
    locations.value = fetchedLocations;
  }

  void selectLocation(Map<String, dynamic> location) {
    selectedLocation.value = LatLng(location['lat'], location['lng']);
    selectedCity.value = location['name'];
  }

  void validateData() {
    if (selectedLatMarker.isEmpty || selectedLngMarker.isEmpty) {
      Get.snackbar('¡Ubicacion vacia!', 'No ha seleccionado su ubicacion.');
      return;
    }
    if (barrioController.text.isEmpty ||
        direccionController.text.isEmpty ||
        detallesDireccionController.text.isEmpty ||
        celularController.text.isEmpty) {
      Get.snackbar(
          '¡Campos vacios!', 'verifique que todos los campos esten llenos.');
      return;
    }
    _updateUserData();
  }

  Future<void> _updateUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? userId = prefs.getString('userId');
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'celular': celularController.text,
        'ciudad': selectedCity.value,
        'barrio': barrioController.text,
        'detallesUbicacion': detallesDireccionController.text,
        'lat': selectedLatMarker.value,
        'lng': selectedLngMarker.value,
        'direccion': direccionController.text
      });
      Get.offAllNamed(AppRoutes.home);
      SnackbarUtils.success('Tus datos fueron enviados');
    } catch (e) {
      SnackbarUtils.error("No se enviar datos");
    }
  }
}
