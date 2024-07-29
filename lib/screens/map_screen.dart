import 'package:agro/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:agro/controllers/config_address_controller.dart';

class MapScreen extends StatefulWidget {
  final LatLng location;

  const MapScreen({super.key, required this.location});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng _currentLocation;
  bool _isButtonVisible = false;
  final ConfigAddressController configAddressController =
      Get.put(ConfigAddressController());

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.location;
    configAddressController.setLocation(_currentLocation);
  }

  void _onMarkerDragEnd(LatLng newPosition) {
    setState(() {
      _currentLocation = newPosition;
      _isButtonVisible = true;
      configAddressController.setLocation(newPosition);
    });
  }

  void _onConfirmLocation() {
    Get.back(result: _currentLocation);
    Get.snackbar(
      'Ubicación seleccionada',
      'Lat: ${_currentLocation.latitude}, Lng: ${_currentLocation.longitude}',
    );
    configAddressController.selectedLocationMarker.value =
        'Lat: ${_currentLocation.latitude}, Lng: ${_currentLocation.longitude}';
    configAddressController.selectedLatMarker.value =
        _currentLocation.latitude.toString();
    configAddressController.selectedLngMarker.value =
        _currentLocation.longitude.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Indica tu ubicación"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(result: _currentLocation);
          },
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 14.0,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('selectedLocation'),
                position: _currentLocation,
                draggable: true,
                onDragEnd: _onMarkerDragEnd,
              ),
            },
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Mantén presionado el indicador rojo para moverlo',
                style: TextStyle(fontSize: 13, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (_isButtonVisible)
            Positioned(
              bottom: 30,
              left: 20,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.verdeNavbar,
                ),
                child: IconButton(
                  onPressed: _onConfirmLocation,
                  icon: const Icon(
                    Icons.check,
                    size: 60,
                    color: AppColors.verdeNavbar2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
