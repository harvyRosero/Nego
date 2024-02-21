import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/controllers/profile_controller.dart';
import 'package:agro/controllers/login_controller.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController _profileController = Get.put(ProfileController());
  final LoginController _loginController = Get.put(LoginController());

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: SingleChildScrollView(
          child: FutureBuilder<Map<String, String?>>(
        future: _profileController.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final userData = snapshot.data!;
            final photo = userData['photo'];
            final name = userData['name'];
            final gmail = userData['gmail'];

            // Usa los datos como necesites
            return Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage('$photo'),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    '$name',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$gmail',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Información adicional del perfil...',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),

                  IconButton(
                      onPressed: () {
                        _loginController.logout();
                      },
                      icon: const Icon(Icons.logout_outlined))
                  // Agrega más widgets según sea necesario
                ],
              ),
            );
          }
        },
      )),
    );
  }
}
