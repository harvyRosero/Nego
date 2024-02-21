import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  // Datos simulados del usuario
  var userName = 'Nombre de Usuario'.obs;
  var bio = 'Biografía del usuario...'.obs;

  Future<Map<String, String?>> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? photo = prefs.getString('photo');
    String? name = prefs.getString('name');
    String? gmail = prefs.getString('gmail');

    return {
      'photo': photo,
      'name': name,
      'gmail': gmail,
    };
  }

  // Función para cambiar el índice seleccionado
  

  void editProfile() {
    // Lógica para editar el perfil
  }

  void logout() {
    // Lógica para cerrar sesión
  }
}
