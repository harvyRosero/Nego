import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/controllers/profile/config_account_controller.dart';

class ConfigAccountScreen extends StatelessWidget {
  final ConfigAccountController controller = Get.put(ConfigAccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              return Text(
                'Nombre de Usuario: ${controller.userName.value}',
                style: TextStyle(fontSize: 20),
              );
            }),
            TextField(
              decoration: InputDecoration(labelText: 'Nuevo Nombre de Usuario'),
              onSubmitted: (value) {
                controller.updateUserName(value);
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Actualizar nombre de usuario con un valor de ejemplo
                controller.updateUserName('NuevoNombreDeUsuario');
              },
              child: Text('Actualizar Nombre de Usuario'),
            ),
          ],
        ),
      ),
    );
  }
}
