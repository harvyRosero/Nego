import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agro/widgets/snackbars.dart';
import 'package:agro/models/posts_model.dart';

class AdMakerController extends GetxController {
  var imageUrl = ''.obs;
  RxString selectedImage = RxString('');
  var selectedOption = 'publicacion_normal'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void selectOption(String opcion) {
    selectedOption.value = opcion;
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedText = prefs.getString('photo');
    if (storedText != null) {
      imageUrl.value = storedText;
    }
  }

  Future<void> setText(String value) async {
    imageUrl.value = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('text', value);
  }

  Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = image.path;
    } else {
      SnackbarUtils.info('No se selecciono ninguna imagen');
    }
    return image;
  }

  Future<String> sendImage() async {
    String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference storageReference = FirebaseStorage.instance.ref();
    Reference referenceDirImages = storageReference.child('publicaciones');

    Reference referenceImagesToUpload =
        referenceDirImages.child(uniqueFileName);

    try {
      await referenceImagesToUpload.putFile(File(selectedImage.value));
      String downloadURL = await referenceImagesToUpload.getDownloadURL();
      return downloadURL; // La imagen se cargó con éxito
    } catch (e) {
      SnackbarUtils.error('¡Ocurrió un error inesperado!');
      return '';
    }
  }

  Future<void> sendDataPublication(String content) async {
    SnackbarUtils.warning("Enviando datos...");
    DateTime now = DateTime.now();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('uid');
    String? userN = prefs.getString('name');
    String? userPhoto = prefs.getString('photo');
    int day = now.day;
    int month = now.month;
    int year = now.year;

    if (selectedImage.isEmpty && content.isEmpty) {
      SnackbarUtils.info('¡No se han detectado datos!');
    } else if (selectedImage.isEmpty) {
      Posts posts = Posts(
          userId: userId.toString(),
          userName: userN.toString(),
          photoProfile: userPhoto.toString(),
          content: content,
          imgUrl: '',
          category: selectedOption.toString(),
          createdAt: '$day / $month / $year');

      Map<String, dynamic> dataPublic = posts.toMap();

      FirebaseFirestore.instance
          .collection('publicaciones')
          .add(dataPublic)
          .then((value) {
        SnackbarUtils.success('¡Datos enviados correctaente!');
      }).catchError((error) {
        SnackbarUtils.error('¡Ocurrio un Error al enviar los datos!');
      });
    } else {
      String urlImgPost = await sendImage();

      Posts posts = Posts(
          userId: userId.toString(),
          userName: userN.toString(),
          photoProfile: userPhoto.toString(),
          content: content,
          imgUrl: urlImgPost,
          category: selectedOption.toString(),
          createdAt: '$day-$month-$year');

      Map<String, dynamic> dataPublic = posts.toMap();

      FirebaseFirestore.instance
          .collection('publicaciones')
          .add(dataPublic)
          .then((value) {
        SnackbarUtils.success('¡Datos enviados correctaente!');
      }).catchError((error) {
        SnackbarUtils.error('¡Ocurrio un Error al enviar los datos!');
      });
    }
  }
}
