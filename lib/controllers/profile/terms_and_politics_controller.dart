import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TermsAndPoliticsController extends GetxController {
  RxList<Map<String, dynamic>> dataList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> dataListTyc = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;
  RxBool showImages = false.obs;
  RxString selectedCategory = ''.obs;

  RxString selectedButton = ''.obs;

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      if (selectedCategory.value == 'pdp') {
        await _fetchDataAppPyd();
      } else if (selectedCategory.value == 'tyc') {
        await _fetchDataAppTyc();
      }
      showImages.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Hubo un problema al obtener los datos.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchDataAppPyd() async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('DataApp').doc('pdp').get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      dataList.value =
          data.entries.map((entry) => {entry.key: entry.value}).toList();
      dataList.sort((a, b) => a.keys.first.compareTo(b.keys.first));
    }
  }

  Future<void> _fetchDataAppTyc() async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('DataApp').doc('tyc').get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      dataListTyc.value =
          data.entries.map((entry) => {entry.key: entry.value}).toList();
      dataListTyc.sort((a, b) => a.keys.first.compareTo(b.keys.first));
    }
  }

  void updateDataList(String category) {
    selectedCategory.value = category;
    selectedButton.value = category; // Actualizar el botón seleccionado
    showImages.value = false;
    fetchData();
  }
}
