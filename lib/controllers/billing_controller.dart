import 'dart:convert';
import 'package:agro/controllers/home/cart_item_controller.dart';
import 'package:agro/models/selected_product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:agro/models/order_model.dart';

class BillingController extends GetxController {
  final CartItemController cartItemController = Get.find<CartItemController>();
  var isAgree = false.obs;
  var userName = ''.obs;
  var uid = ''.obs;
  var gmail = ''.obs;
  var direccion = ''.obs;
  var lng = ''.obs;
  var lat = ''.obs;
  var ciudad = ''.obs;
  var celular = ''.obs;
  var detallesUbicacion = ''.obs;
  var barrio = ''.obs;
  var appState = ''.obs;
  var key = ''.obs;
  var key0 = ''.obs;
  var value1 = ''.obs;
  var value0 = ''.obs;
  var category = ''.obs;
  var statusPayP = false.obs;
  var costoDom = 0.obs;

  RxList<SelectedProductData> cartProducts = <SelectedProductData>[].obs;
  RxDouble totalSum = 0.0.obs;

  @override
  void onInit() async {
    super.onInit();
    await getUserData();
    await _getDomicilioFromBusiness();
    _loadCartProducts();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid.value = prefs.getString('userId') ?? '';
    gmail.value = prefs.getString('gmail') ?? '';
    userName.value = prefs.getString('userName') ?? '';
    direccion.value = prefs.getString('direccion') ?? '';
    lat.value = prefs.getString('lat') ?? '';
    lng.value = prefs.getString('lng') ?? '';
    detallesUbicacion.value = prefs.getString('detallesUbicacion') ?? '';
    ciudad.value = prefs.getString('ciudad') ?? '';
    celular.value = prefs.getString('celular') ?? '';
    barrio.value = prefs.getString('barrio') ?? '';
    category.value = prefs.getString('category') ?? '';
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
    totalSum.value = sum + costoDom.value;
  }

  Future<void> sendOrderToFirebase() async {
    appState.value = (await _getEstadoFromServicio())!;
    if (direccion.value.isEmpty) {
      Get.snackbar('Informacion', 'No tiene una direccion agreda!');
      return;
    }
    if (appState.value != 'activo') {
      Get.snackbar('Informacion',
          'Nuestro servicio se encuentra inactivo por ahora, intenta en otro horario!');
      return;
    }
    DatabaseReference myOrdersRef =
        FirebaseDatabase.instance.ref().child('orders');

    MyOrder myOrder = MyOrder(
      uid: uid.value,
      userName: userName.value,
      gmail: gmail.value,
      direccion: direccion.value,
      lat: lat.value,
      lng: lng.value,
      ciudad: ciudad.value,
      celular: celular.value,
      detallesUbicacion: detallesUbicacion.value,
      barrio: barrio.value,
      category: category.value,
      state: 'Pedido recibido',
      deliveryId: '',
      totalSum: totalSum.value,
      products: cartProducts.toList(),
      createdAt: DateTime.now().toIso8601String(),
    );
    try {
      await myOrdersRef.push().set(myOrder.toMap());
      _clearCart();
      Get.snackbar('Informacion', '¡Pedido enviado!');
    } catch (e) {
      Get.snackbar('ERROR', 'No se pudo enviar tu pedido, intentalo más tarde');
    }
  }

  void _clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('productos');
    await prefs.remove('category');
  }

  Future<String?> _getEstadoFromServicio() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance
              .collection('DataApp')
              .doc('servicio')
              .get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        String? estado = docSnapshot.data()!['estado'] as String?;
        return estado;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> _getDomicilioFromBusiness() async {
    String cadena = '${category.value}${ciudad.value}';
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance
              .collection('Bussiness')
              .doc(cadena)
              .get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        costoDom.value = docSnapshot.data()!['Domicilio'];
      } else {
        Get.snackbar('Error', 'No se obtuvieron algunos datos');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error al obtener domicilio: $e');
    }
  }
}
