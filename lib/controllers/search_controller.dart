import 'package:agro/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySearchController extends GetxController {
  var searchQuery = ''.obs;
  var isLoading = false.obs;
  TextEditingController searchTextController = TextEditingController();
  var searchResults = <ProductData>[].obs;
  late String city;
  var categoriesData = <String, dynamic>{}.obs;

  @override
  void onInit() async {
    super.onInit();
    await _loadCity();
    _getCategoriesData();
    ever(searchQuery, (String query) {
      if (query.isNotEmpty) {
        searchProducts(query);
      } else {
        searchResults.clear();
      }
    });
  }

  Future<void> _getCategoriesData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('DataApp')
          .doc('categories$city')
          .get();

      if (documentSnapshot.exists) {
        categoriesData.value = documentSnapshot.data() as Map<String, dynamic>;
      } else {
        Get.snackbar("Error", 'El documento no existe');
      }
    } catch (e) {
      Get.snackbar("Error", 'Error al obtener los datos.');
    }
  }

  Future<void> _loadCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    city = prefs.getString('ciudad') ?? '';
  }

  Future<void> fetchProductsByCategory(String category) async {
    String cadena = 'Productos$city';
    try {
      searchResults.value = [];
      isLoading.value = true;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(cadena)
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
    if (city.isEmpty) {
      Get.snackbar('Error', 'No se ha seleccionado una ciudad.');
      return;
    }

    String collectionPath = 'Productos$city';
    try {
      final searchLower = query.toLowerCase();

      // Realizar búsquedas en múltiples campos (tags en este caso)
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(collectionPath)
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
    }
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}
