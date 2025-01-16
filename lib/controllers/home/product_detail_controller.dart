import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:agro/models/selected_product_model.dart';
import 'package:agro/controllers/home/cart_item_controller.dart';

class ProductDetailController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxInt quantity = 1.obs;
  final RxDouble totalValue = 0.0.obs;
  final CartItemController cartItemController = Get.find<CartItemController>();
  var productData = {}.obs;
  var productsSug = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var name = ''.obs;
  var description = ''.obs;
  var stock = 0.obs;
  var rating = 0.0.obs;
  var category = ''.obs;
  var price = 0.0.obs;
  var promo = 0.0.obs;
  var img = ''.obs;
  var estado = ''.obs;
  var pId = ''.obs;
  var flag = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await obtenerProductos();
  }

  void addToCart(SelectedProductData product) async {
    if (quantity.value == 0) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? productListStr = prefs.getString('productos');
    String? category0 = prefs.getString('category');

    List<dynamic> productList =
        productListStr != null ? json.decode(productListStr) : [];

    if (product.categoria == category0) {
      productList.removeWhere((item) => item['pId'] == product.pId);
    } else {
      productList.clear();
      await prefs.remove('productos');
    }

    productList.add(product.toMap());
    await prefs.setString('productos', json.encode(productList));
    await prefs.setString('category', category.value);

    cartItemController.itemCount.value = productList.length;
    Get.snackbar('Informacion', 'Se agrego un producto');
  }

  Future<void> getArguments(Map<String, dynamic> arguments) async {
    pId.value = arguments['pId'];
    category.value = arguments['category'];
    flag.value = arguments['flag'];
    fetchProductById(pId.value);
  }

  Future<void> fetchProductById(String docId) async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String city = prefs.getString('ciudad').toString();

    String cadena = 'Productos$city';
    try {
      DocumentSnapshot doc =
          await _firestore.collection(cadena).doc(docId).get();

      if (doc.exists) {
        productData.value = doc.data() as Map<String, dynamic>;
        isLoading.value = false;
      } else {
        Get.snackbar("Informacion", "No existe el producto.");
      }
    } catch (e) {
      Get.snackbar('Error (c_pdc)', "Error al obtener el producto");
    }

    name.value = productData['name'] ?? '';
    img.value = productData['imageUrl'] ?? '';
    description.value = productData['description'] ?? '';
    stock.value = productData['stock'] ?? 0;
    category.value = productData['category'] ?? '';
    price.value = productData['price'] ?? 0.0;
    promo.value = productData['promo'] ?? 0.0;
    pId.value = productData['id'] ?? '';
    estado.value = productData['estado'] ?? '';
    rating.value = productData['rating'] ?? 0.0;
  }

  Future<void> obtenerProductos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String city = prefs.getString('ciudad') ?? '';

    String cadena = 'Productos$city';
    try {
      Query query = _firestore
          .collection(cadena)
          .where('category', isEqualTo: category.value) // Filtrar por category
          .orderBy('createdAt', descending: true)
          .limit(15);

      QuerySnapshot querySnapshot = await query.get();

      List<Map<String, dynamic>> productosObtenidos = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      productsSug.value = productosObtenidos;
    } catch (e) {
      Get.snackbar("Error", 'Error al obtener los productos');
    }
  }
}
