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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        'name': doc
            .id, // Asumimos que el ID del documento es el nombre de la ciudad
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

    _sendUserData();
  }

  Future<void> _sendUserData() async {
    // Inicializa las SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final String? userId = prefs.getString('userId');
      final String? userName = prefs.getString('userName');
      final String? gmail = prefs.getString('gmail');
      final String? perfilImg = prefs.getString('perfilImg');

      // Verifica si el ID del usuario está disponible
      if (userId == null) {
        throw Exception('User ID not found in SharedPreferences');
      }

      // Prepara los datos del usuario
      final userData = {
        'userName': userName ?? '',
        'email': gmail ?? '',
        'direccion': direccionController.text,
        'perfilImg': perfilImg ?? '',
        'celular': celularController.text,
        'ciudad': selectedCity.value,
        'barrio': barrioController.text,
        'detallesUbicacion': detallesDireccionController.text,
        'lat': selectedLatMarker.value,
        'lng': selectedLngMarker.value,
      };

      // Envía los datos al Firestore
      await _firestore.collection('users').doc(userId).set(userData);

      // Actualiza SharedPreferences sólo si la operación en Firestore fue exitosa
      await prefs.setString('userId', userId);
      await prefs.setString('userName', userName ?? '');
      await prefs.setString('gmail', gmail ?? '');
      await prefs.setString('perfilImg', perfilImg ?? '');
      await prefs.setString('direccion', direccionController.text);
      await prefs.setString('ciudad', selectedCity.value);
      await prefs.setString('barrio', barrioController.text);
      await prefs.setString(
          'detallesUbicacion', detallesDireccionController.text);
      await prefs.setString('celular', celularController.text);
      await prefs.setString('lat', selectedLatMarker.value);
      await prefs.setString('lng', selectedLngMarker.value);

      // Redirige al usuario y muestra un mensaje de éxito
      Get.offAllNamed(AppRoutes.home);
      SnackbarUtils.success('Tus datos fueron enviados');
    } catch (e) {
      // Muestra un mensaje de error
      SnackbarUtils.error('Error al enviar los datos del usuario: $e');
    }
  }
}
