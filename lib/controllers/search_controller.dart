import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySearchController extends GetxController {
  var searchQuery = ''.obs;
  TextEditingController searchTextController = TextEditingController();

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    // Aquí puedes agregar lógica adicional, como realizar una búsqueda en tiempo real
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}
