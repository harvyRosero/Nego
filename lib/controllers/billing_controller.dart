import 'dart:convert';

import 'package:agro/models/selected_product_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillingController extends GetxController {
  var userName = ''.obs;
  var gmail = ''.obs;
  var direccion = ''.obs;
  var lng = ''.obs;
  var lat = ''.obs;
  var ciudad = ''.obs;
  var celular = ''.obs;
  var detallesUbicacion = ''.obs;
  var barrio = ''.obs;

  RxList<SelectedProductData> cartProducts = <SelectedProductData>[].obs;
  RxDouble totalSum = 0.0.obs;
  @override
  void onInit() {
    super.onInit();
    getUserData();
    _loadCartProducts();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    gmail.value = prefs.getString('gmail') ?? '';
    userName.value = prefs.getString('userName') ?? '';
    direccion.value = prefs.getString('direccion') ?? '';
    lat.value = prefs.getString('lat') ?? '';
    lng.value = prefs.getString('lng') ?? '';
    detallesUbicacion.value = prefs.getString('detallesUbicacion') ?? '';
    ciudad.value = prefs.getString('ciudad') ?? '';
    celular.value = prefs.getString('celular') ?? '';
    barrio.value = prefs.getString('barrio') ?? '';
  }

  Future<void> _loadCartProducts() async {
    final prefs = await SharedPreferences.getInstance();
    String? productListStr = prefs.getString('productos');
    if (productListStr != null) {
      List<dynamic> productList = json.decode(productListStr);
      cartProducts.value =
          productList.map((item) => SelectedProductData.fromMap(item)).toList();
      _calculateTotalSum();
    }
  }

  void _calculateTotalSum() {
    double sum = 0.0;
    for (var product in cartProducts) {
      sum += product.total;
    }
    totalSum.value = sum;
  }
}
