import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllOrdersController extends GetxController {
  var ordersHistoryList = <Map<String, dynamic>>[].obs;
  late SharedPreferences _prefs;

  @override
  void onInit() {
    super.onInit();
    fetchOrdersHistory();
  }

  var filteredOrdersList = <Map<String, dynamic>>[].obs;

  void fetchOrdersHistory() async {
    _prefs = await SharedPreferences.getInstance();
    String userId = _prefs.getString('userId') ?? '';
    try {
      CollectionReference ordersHistoryCollection =
          FirebaseFirestore.instance.collection('ordersHistory');

      QuerySnapshot querySnapshot =
          await ordersHistoryCollection.where('uid', isEqualTo: userId).get();

      filteredOrdersList.value = querySnapshot.docs
          .map((doc) =>
              Map<String, dynamic>.from(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'No se pudo obtener datos.');
    }
  }
}
