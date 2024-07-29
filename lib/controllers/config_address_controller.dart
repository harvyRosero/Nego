import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConfigAddressController extends GetxController {
  var locations = <Map<String, dynamic>>[].obs;
  var selectedLocation = Rx<LatLng?>(null);
  var currentLocation = Rx<LatLng?>(null);
  var selectedLocationMarker = ''.obs;
  var selectedLatMarker = ''.obs;
  var selectedLngMarker = ''.obs;

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
  }
}
