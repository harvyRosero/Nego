import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map2Screen extends StatelessWidget {
  const Map2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = Get.arguments;
    final double lat = double.parse(arguments['lat']);
    final double lng = double.parse(arguments['lng']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu punto de entrega'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, lng),
          zoom: 16.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(lat, lng),
          ),
        },
      ),
    );
  }
}
