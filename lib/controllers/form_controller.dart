import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:agro/models/farm_model.dart';
import 'package:agro/models/transportist_model.dart';
import 'package:agro/models/store_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro/widgets/snackbars.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class FormController extends GetxController {
  RxString selectedImage = RxString('');
  RxString selectedImagePortada = RxString('');
  RxBool isButtonSelected = false.obs;

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

  Future<XFile?> getImagePortada() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImagePortada.value = image.path;
    } else {
      SnackbarUtils.info('No se selecciono ninguna imagen');
    }
    return image;
  }

  Future<String> sendImage() async {
    String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference storageReference = FirebaseStorage.instance.ref();
    Reference referenceDirImages = storageReference.child('images');

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

  Future<String> sendImagePortada() async {
    String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference storageReference = FirebaseStorage.instance.ref();
    Reference referenceDirImages = storageReference.child('images');

    Reference referenceImagesToUpload =
        referenceDirImages.child(uniqueFileName);

    try {
      await referenceImagesToUpload.putFile(File(selectedImagePortada.value));
      String downloadURL = await referenceImagesToUpload.getDownloadURL();
      return downloadURL;
    } catch (e) {
      SnackbarUtils.error('¡Ocurrió un error inesperado!');
      return '';
    }
  }

  void sendDataToFirebase(
      nombre,
      descripcion,
      departamento,
      ubicacion,
      lugarCercano,
      producto,
      contacto,
      imagePerfil,
      imagePortada,
      fechaCreacion) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('uid');
    FarmData farmData = FarmData(
        categoria: 'Empresa Agricultora',
        nombre: nombre,
        descripcion: descripcion,
        departamento: departamento,
        ubicacion: ubicacion,
        lugarCercano: lugarCercano,
        producto: producto,
        contacto: contacto,
        userId: userId.toString(),
        imagePerfil: imagePerfil,
        imagePortada: imagePortada,
        fechaCreacion: fechaCreacion);

    Map<String, dynamic> datosMapa = farmData.toMap();

    FirebaseFirestore.instance
        .collection('empresas')
        .add(datosMapa)
        .then((value) {
      SnackbarUtils.success('¡Datos enviados correctaente!');
    }).catchError((error) {
      SnackbarUtils.error('¡Ocurrio un Error al enviar dato!');
    });
  }

  void sendDataTrasnportisToFirebase(nombre, descripcion, camion, ubicacion,
      capacidad, contacto, image, imagePortada) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('uid');
    TransportistData transportistData = TransportistData(
        categoria: 'Transportista',
        nombre: nombre,
        descripcion: descripcion,
        camion: camion,
        ubicacion: ubicacion,
        capacidadCarga: capacidad,
        contacto: contacto,
        userId: userId.toString(),
        image: image,
        imagePortada: imagePortada);

    Map<String, dynamic> datosMapa = transportistData.toMap();
    FirebaseFirestore.instance
        .collection('empresas')
        .add(datosMapa)
        .then((value) {
      SnackbarUtils.success('¡Datos enviados correctaente!');
    }).catchError((error) {
      SnackbarUtils.error('¡Ocurrio un Error al enviar dato!');
    });
  }

  void sendDataStoreToFirebase(
      tienda, descripcion, ubicacion, contacto, image, imagePortada) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('uid');
    StoreData storeData = StoreData(
      categoria: 'Tienda',
      tienda: tienda,
      descripcion: descripcion,
      ubicacion: ubicacion,
      contacto: contacto,
      userId: userId.toString(),
      image: image,
      imagePortada: imagePortada,
    );

    Map<String, dynamic> datosMapa = storeData.toMap();

    FirebaseFirestore.instance
        .collection('empresas')
        .add(datosMapa)
        .then((value) {
      SnackbarUtils.success('¡Datos enviados correctaente!');
    }).catchError((error) {
      SnackbarUtils.error('¡Ocurrio un Error al enviar dato!');
    });
  }

  void validateAndSendData(
      String nombre,
      String descripcion,
      String departamento,
      String ubicacion,
      String lugarCercano,
      String producto,
      String contacto) async {
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;

    String fechaCreacion = '$month de $year';
    if (selectedImage.value.isEmpty) {
      SnackbarUtils.warning('Debe seleccioinar una imagen');
    }
    if (nombre.isEmpty ||
        ubicacion.isEmpty ||
        lugarCercano.isEmpty ||
        producto.isEmpty ||
        contacto.isEmpty) {
      SnackbarUtils.warning('¡Debe llenar todos los campos!');
    } else {
      isButtonSelected.value = true;
      String imgPerfil = await sendImage();
      String imgPortada = await sendImagePortada();
      if (imgPerfil.isNotEmpty) {
        sendDataToFirebase(
            nombre,
            descripcion,
            departamento,
            ubicacion,
            lugarCercano,
            producto,
            contacto,
            imgPerfil,
            imgPortada,
            fechaCreacion);

        Get.offAllNamed('home');
      }
    }
  }

  void validateAndSendDataTransportist(
      String nombre,
      String descripcion,
      String camion,
      String ubicacion,
      String capacidad,
      String contacto) async {
    if (selectedImage.value.isEmpty) {
      SnackbarUtils.warning('Debe seleccioinar una imagen');
    }
    if (nombre.isEmpty ||
        camion.isEmpty ||
        descripcion.isEmpty ||
        ubicacion.isEmpty ||
        capacidad.isEmpty ||
        contacto.isEmpty) {
      SnackbarUtils.warning('Debe llenar todos los campos!');
    } else {
      isButtonSelected.value = true;
      String urlImg = await sendImage();
      String urlImgPortada = await sendImagePortada();
      if (urlImg.isNotEmpty) {
        sendDataTrasnportisToFirebase(nombre, descripcion, camion, ubicacion,
            capacidad, contacto, urlImg, urlImgPortada);
      }
      Get.offAllNamed('home');
    }
  }

  void validateAndSendDataStore(String tienda, String descripcion,
      String ubicacion, String contacto) async {
    if (selectedImage.value.isEmpty) {
      SnackbarUtils.warning('Debe seleccioinar una imagen');
    }
    if (tienda.isEmpty ||
        descripcion.isEmpty ||
        ubicacion.isEmpty ||
        contacto.isEmpty) {
      SnackbarUtils.warning('Debe llenar todos los campos!');
    } else {
      isButtonSelected.value = true;
      String urlImg = await sendImage();
      String urlImgPortada = await sendImagePortada();
      if (urlImg.isNotEmpty) {
        sendDataStoreToFirebase(
            tienda, descripcion, ubicacion, contacto, urlImg, urlImgPortada);
      }
      Get.offAllNamed('home');
    }
  }
}
