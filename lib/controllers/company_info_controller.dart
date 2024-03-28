import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<String> uploadImage(File image) async {
  var url = '';
  final file = await ImagePicker().pickImage(source: ImageSource.gallery);
  String filename = DateTime.now().microsecondsSinceEpoch.toString();

  Reference reference = FirebaseStorage.instance.ref();
  Reference referenceImages = reference.child('images');
  Reference referenceUpload = referenceImages.child(filename);

  try {
    await referenceUpload.putFile(File(file!.path));
  } catch (e) {
    print(e);
  }
  return url;
}

Future<XFile?> getImage() async {
  final ImagePicker picker = ImagePicker();

  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  return image;
}

// Future<bool> uploadImage(File image) async {
//   final String nameFile = image.path.split("/").last;
//   final Reference ref = storage.ref().child("images").child(nameFile);
//   final UploadTask uploadTask = ref.putFile(image);
//   print(uploadTask);

//   final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
//   print(snapshot);

//   final String url = await snapshot.ref.getDownloadURL();
//   print(url);
//   return false;
// }

// Future<String> uploadImage(File image) async {
//   try {
//     final String nameFile = image.path.split("/").last;
//     final Reference ref = storage.ref().child("images").child(nameFile);
//     final UploadTask uploadTask = ref.putFile(image);
//     print(uploadTask);

//     // Esperar a que la carga se complete
//     await uploadTask;

//     if (uploadTask.snapshot.state == TaskState.success) {
//       print("Upload complete");
//       final String url =
//           await ref.getDownloadURL(); // Obtener la URL de descarga
//       print(url);
//       return url; // Devolver la URL de descarga
//     } else {
//       throw Exception('Error al cargar la imagen');
//     }
//   } catch (e) {
//     print('Error durante la carga de la imagen: $e');
//     throw e; // Relanzar el error para que sea manejado por el llamador
//   }
// }
