import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:agro/routes/app_routes.dart';
import 'package:agro/controllers/login/login_controller.dart';
import 'utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final LoginController controller = Get.put(LoginController());
  bool isSignedIn = await controller.checkUser();

  runApp(MyApp(isSignedIn: isSignedIn));
}

class MyApp extends StatelessWidget {
  final bool isSignedIn;

  const MyApp({super.key, required this.isSignedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Nego',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.blanco,
      ),
      initialRoute:
          isSignedIn ? AppRoutes.home : AppRoutes.preLogin, // Ruta inicial
      getPages: AppRoutes.routes,
    );
  }
}
