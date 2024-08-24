import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersController extends GetxController {
  final DatabaseReference _ordersRef = FirebaseDatabase.instance.ref('orders');
  RxInt ordersCount = 0.obs;
  RxList<Map<dynamic, dynamic>> ordersList = <Map<dynamic, dynamic>>[].obs;
  late SharedPreferences _prefs;
  late String _userId;
  var showProducts = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializePreferences();
    _listenToOrdersChanges();
  }

  Future<void> _initializePreferences() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _userId = _prefs.getString('userId') ?? '';
      await getOrdersData();
    } catch (error) {
      Get.snackbar('Error (coc) ', 'No se pudo obtener datos');
    }
  }

  Future<void> getOrdersData() async {
    try {
      final DataSnapshot snapshot = await _ordersRef.get();

      if (snapshot.exists) {
        _processOrdersData(snapshot.value as Map<dynamic, dynamic>);
      } else {
        _clearOrders();
      }
    } catch (error) {
      Get.snackbar('Informacion', 'No hay datos para mostrar');
      _clearOrders();
    }
  }

  void sendDataToHistory(String pId, Map<String, dynamic> order) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DocumentReference documentRef =
          firestore.collection('ordersHistory').doc(pId);
      await documentRef.set(order);
      _deleteOrder(pId);
      Get.snackbar('Informacion', 'Se envio pedido con el ID: $pId');
    } catch (e) {
      Get.snackbar('Error (coc)', 'Error al enviar datos,');
    }
  }

  void _deleteOrder(String orderId) async {
    try {
      final DatabaseReference database = FirebaseDatabase.instance.ref();
      final DatabaseReference orderRef =
          database.child('orders').child(orderId);
      await orderRef.remove();
    } catch (e) {
      Get.snackbar('Error (coc)', 'Error deleting order');
    }
  }

  void _processOrdersData(Map<dynamic, dynamic> data) {
    ordersCount.value = 0;
    ordersList.clear();

    data.forEach((key, value) {
      final String documentId = key;
      final Map<dynamic, dynamic> orderData = value as Map<dynamic, dynamic>;
      final String uid0 = orderData['uid'];

      if (uid0 == _userId) {
        ordersList.add({
          'documentId': documentId,
          ...orderData,
        });
        ordersCount.value += 1;
      }
    });
  }

  void _clearOrders() {
    ordersCount.value = 0;
    ordersList.clear();
  }

  void _listenToOrdersChanges() {
    _ordersRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        _processOrdersData(event.snapshot.value as Map<dynamic, dynamic>);
      } else {
        _clearOrders();
      }
    }).onError((error) {
      Get.snackbar(
          'Error (coc)', 'Error no se pudieron obtener datos actualizados.');
    });
  }
}
