import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro/models/product_model.dart';
import 'package:agro/widgets/snackbars.dart';

class HomeProductListController extends GetxController {
  var productList = <ProductData>[].obs;
  var isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('productos').get();

      var products = snapshot.docs.map((doc) {
        return ProductData.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      productList.assignAll(products);
    } catch (e) {
      SnackbarUtils.info('No se pudo obtener todos los datos');
    } finally {
      isLoading(false);
    }
  }
}
