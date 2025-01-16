import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SupportController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var supportData = {}.obs;
  var gmail = ''.obs;
  var telefono = ''.obs;
  var whatsapp = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchSupportData();
  }

  Future<void> _fetchSupportData() async {
    try {
      DocumentSnapshot supportDoc =
          await _firestore.collection('DataApp').doc('soporte').get();
      if (supportDoc.exists) {
        supportData.value = supportDoc.data() as Map<String, dynamic>;
        String telefono2 = supportData['telefono'];
        String gmail2 = supportData['gmail'];
        String whatsApp = supportData['whatsapp'];

        gmail.value = gmail2;
        telefono.value = telefono2;
        whatsapp.value = whatsApp;
      }
    } catch (e) {
      Get.snackbar('Error (sc)', 'No se pudo obtener datos de contacto.');
    }
  }
}
