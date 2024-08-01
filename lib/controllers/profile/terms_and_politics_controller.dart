import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TermsAndPoliticsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var securityPoliticsData = {}.obs;
  var tyc = ''.obs;
  var pdp = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchsecurityPoliticsData();
  }

  Future<void> _fetchsecurityPoliticsData() async {
    try {
      DocumentSnapshot supportDoc = await _firestore
          .collection('DataApp')
          .doc('politicasDePrivacidad')
          .get();
      if (supportDoc.exists) {
        securityPoliticsData.value = supportDoc.data() as Map<String, dynamic>;
        String pdp2 = securityPoliticsData['pdp'];
        String tyc2 = securityPoliticsData['tyc'];

        tyc.value = tyc2;
        pdp.value = pdp2;
      }
    } catch (e) {
      Get.snackbar('Error (sc)', 'No se pudo obtener datos.');
    }
  }
}
