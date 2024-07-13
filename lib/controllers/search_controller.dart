import 'package:get/get.dart';

class MySearchController extends GetxController {
  var publicaciones = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getDataPublic();
  }

  Future<void> getDataPublic() async {
    try {
      isLoading(true);
      // Simula una llamada a la API
      await Future.delayed(Duration(seconds: 2));
      var data = [
        {
          'userName': 'User 1',
          'content': 'Content 1',
          'photoProfile': null,
          'imgUrl': null
        },
        {
          'userName': 'User 2',
          'content': 'Content 2',
          'photoProfile': null,
          'imgUrl': null
        },
        {
          'userName': 'User 4',
          'content': 'Content 4',
          'photoProfile': null,
          'imgUrl': null
        },
      ];
      publicaciones.value = data;
    } finally {
      isLoading(false);
    }
  }
}
