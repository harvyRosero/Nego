import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro/widgets/snackbars.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:agro/models/product_model.dart';

class HomeProductListController extends GetxController {
  static const _pageSize = 10;

  final PagingController<int, ProductData> pagingController =
      PagingController(firstPageKey: 0);

  var publicidadImages =
      <String>[].obs; // Lista para almacenar URLs de imágenes

  @override
  void onInit() {
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
    fetchPublicidadData(); // Llamar a la función para obtener datos de publicidad al iniciar
    super.onInit();
  }

  Future<void> fetchPage(int pageKey) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('productos')
          .orderBy('nombre')
          .startAfter([pageKey])
          .limit(_pageSize)
          .get();

      final newItems = snapshot.docs.map((doc) {
        return ProductData.fromMap(doc.data());
      }).toList();

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (e) {
      SnackbarUtils.info('No se pudo obtener todos los datos');
      pagingController.error = e;
    }
  }

  Future<void> fetchPublicidadData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('DataApp')
          .doc('publicidad')
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() ?? {};

        // Extrae los valores de los campos que contienen URLs de imágenes
        publicidadImages.value = [
          data['1'] as String? ?? '',
          data['2'] as String? ?? '',
          data['3'] as String? ?? '',
          // Añadir más campos si es necesario
        ].where((url) => url.isNotEmpty).toList();
      } else {
        SnackbarUtils.info('El documento de publicidad no existe');
      }
    } catch (e) {
      SnackbarUtils.info('No se pudo obtener los datos de publicidad');
    }
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }
}
