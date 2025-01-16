import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro/widgets/snackbars.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:agro/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProductListController extends GetxController {
  static const _pageSize = 10;
  late PagingController<int, ProductData> pagingController;
  DocumentSnapshot? lastDocument;
  var publicidadImages = <String>[].obs;
  final Set<String> fetchedProductIds = <String>{};

  @override
  void onInit() {
    super.onInit();
    pagingController = PagingController(firstPageKey: 0);
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });

    fetchPublicidadData();
  }

  Future<void> refreshData() async {
    fetchedProductIds.clear();
    lastDocument = null;
    pagingController.refresh(); // Refresca la lista de productos
    await fetchPublicidadData(); // Refresca las imágenes de publicidad
  }

  Future<String> getUbicationData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String city = prefs.getString('ciudad').toString();
    return city;
  }

  Future<void> fetchPage(int pageKey) async {
    String city = await getUbicationData();
    String colleccion = 'Productos$city';
    try {
      Query query = FirebaseFirestore.instance
          .collection(colleccion)
          .orderBy('tipo')
          .limit(_pageSize);

      if (pageKey != 0 && lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      final snapshot = await query.get();

      if (isClosed) return;

      final newItems = snapshot.docs.map((doc) {
        return ProductData.fromDocument(doc);
      }).toList();

      final uniqueItems = newItems.where((item) {
        final isUnique = !fetchedProductIds.contains(item.id);
        if (isUnique) {
          fetchedProductIds.add(item.id);
        }
        return isUnique;
      }).toList();

      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs.last;
      }

      final isLastPage = uniqueItems.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(uniqueItems);
      } else {
        final nextPageKey = pageKey + uniqueItems.length;
        pagingController.appendPage(uniqueItems, nextPageKey);
      }
    } catch (e) {
      if (!isClosed) {
        SnackbarUtils.info('No se pudo obtener los datos. Intenta de nuevo.');
        pagingController.error = e;
      }
    }
  }

  Future<void> fetchPublicidadData() async {
    String city = await getUbicationData();
    String colleccion = 'Publicidad$city';

    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('DataApp')
          .doc(colleccion)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() ?? {};

        publicidadImages.value = data.values.whereType<String>().toList();
      } else {
        SnackbarUtils.info('El documento de publicidad no existe');
        publicidadImages.value = [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTghpUSAfKgYdJttzmFlEmtltJjeXkAjKl_Hw&s'
        ];
      }
    } catch (e) {
      SnackbarUtils.info(
          'No se pudo obtener los datos de publicidad. Intenta de nuevo.');
    }
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }
}
