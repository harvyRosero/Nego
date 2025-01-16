import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agro/models/selected_product_model.dart';
import 'package:agro/controllers/home/cart_item_controller.dart';

class ShoppingCartController extends GetxController {
  RxList<SelectedProductData> cartProducts = <SelectedProductData>[].obs;
  final CartItemController cartItemController = Get.find<CartItemController>();
  RxDouble totalSum = 0.0.obs;
  var category = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCartProducts();
  }

  Future<void> loadCartProducts() async {
    final prefs = await SharedPreferences.getInstance();
    String? productListStr = prefs.getString('productos');
    category.value = prefs.getString('category') ?? '';
    if (productListStr != null) {
      List<dynamic> productList = json.decode(productListStr);
      cartProducts.value =
          productList.map((item) => SelectedProductData.fromMap(item)).toList();
      cartItemController.itemCount.value = productList.length;
      _calculateTotalSum();
    }
  }

  void removeFromCart(String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? productListStr = prefs.getString('productos');
    List<dynamic> productList =
        productListStr != null ? json.decode(productListStr) : [];

    productList.removeWhere((item) => item['pId'] == productId);

    await prefs.setString('productos', json.encode(productList));
    loadCartProducts();

    cartItemController.itemCount.value = productList.length;
  }

  Future<void> updateCartItemCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? productListStr = prefs.getString('productos');
    List<dynamic> productList =
        productListStr != null ? json.decode(productListStr) : [];

    cartItemController.itemCount.value = productList.length;
  }

  void _calculateTotalSum() {
    double sum = 0.0;
    for (var product in cartProducts) {
      sum += product.total;
    }
    totalSum.value = sum;
  }
}
