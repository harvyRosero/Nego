import 'package:agro/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MySearchController extends GetxController {
  var searchQuery = ''.obs;
  var isLoading = false.obs;
  TextEditingController searchTextController = TextEditingController();
  var searchResults = <ProductData>[].obs;

  @override
  void onInit() {
    super.onInit();
    ever(searchQuery, (String query) {
      if (query.isNotEmpty) {
        searchProducts(query);
      } else {
        searchResults.clear();
      }
    });
  }

  Future<void> fetchProductsByCategory(String category) async {
    try {
      searchResults.value = [];
      isLoading.value = true;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Productos')
          .where('category', isEqualTo: category)
          .get();

      searchResults.value = querySnapshot.docs.map((doc) {
        return ProductData.fromDocument(doc);
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Ocurrio un error.');
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  Future<void> searchProducts(String query) async {
    try {
      final searchLower = query.toLowerCase();

      // Realizar búsquedas en múltiples campos (name, category, tags)
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Productos')
          .where('tags', arrayContains: searchLower)
          .get();

      searchResults.value = querySnapshot.docs
          .map((doc) => ProductData.fromDocument(doc))
          .toList();
    } catch (e) {
      Get.snackbar(
        'Error en la búsqueda',
        'No se pudo realizar la búsqueda. Inténtalo de nuevo más tarde.',
      );
      Get.snackbar('Error (csc)', 'Error en la búsqueda');
    }
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}
