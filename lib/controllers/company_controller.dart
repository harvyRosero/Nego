import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var category = ''.obs;
  var products = <Map<String, dynamic>>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await obtenerProductos();
  }

  Future<void> getArguments(Map<String, dynamic> arguments) async {
    category.value = arguments['category'];
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

      products.value = productosObtenidos;
    } catch (e) {
      Get.snackbar("Error", 'Error al obtener los productos');
    }
  }
}
