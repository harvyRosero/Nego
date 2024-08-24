import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro/widgets/snackbars.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:agro/models/product_model.dart';

class HomeProductListController extends GetxController {
  static const _pageSize = 10;
  late PagingController<int, ProductData> pagingController;
  DocumentSnapshot? lastDocument;
  var publicidadImages = <String>[].obs;
  final Set<String> fetchedProductIds = <String>{};

  @override
  void onInit() {
    pagingController = PagingController(firstPageKey: 0);

    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });

    fetchPublicidadData();
    super.onInit();
  }

  Future<void> fetchPage(int pageKey) async {
    try {
      Query query = FirebaseFirestore.instance
          .collection('Productos')
          .orderBy('name')
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
        SnackbarUtils.info('No se pudo obtener todos los datos');
        pagingController.error = e;
      }
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

        publicidadImages.value = [
          data['1'] as String? ?? '',
          data['2'] as String? ?? '',
          data['3'] as String? ?? '',
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
