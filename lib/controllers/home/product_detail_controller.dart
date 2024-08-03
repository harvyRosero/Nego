import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:agro/models/selected_product_model.dart';
import 'package:agro/controllers/home/cart_item_controller.dart';

class ProductDetailController extends GetxController {
  final RxInt quantity = 1.obs;
  final RxDouble totalValue = 0.0.obs;
  final CartItemController cartItemController = Get.find<CartItemController>();

  void addToCart(SelectedProductData product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? productListStr = prefs.getString('productos');
    List<dynamic> productList =
        productListStr != null ? json.decode(productListStr) : [];

    productList.removeWhere((item) => item['pId'] == product.pId);

    productList.add(product.toMap());

    await prefs.setString('productos', json.encode(productList));
    cartItemController.itemCount.value = productList.length;
    Get.snackbar('Informacion', 'Se agrego un producto');
  }
}
