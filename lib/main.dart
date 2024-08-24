import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:agro/routes/app_routes.dart';
import 'package:agro/controllers/login/login_controller.dart';
import 'utils/app_colors.dart';
import 'services/push_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final PushNotificationsProvider pushNotificationsProvider =
      PushNotificationsProvider();
  final LoginController controller = Get.put(LoginController());
  bool isSignedIn = await controller.checkUser();
  if (isSignedIn) {
    pushNotificationsProvider.initNotifications();
  }
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
        appBarTheme: const AppBarTheme(
          color: AppColors.blanco,
          iconTheme: IconThemeData(color: AppColors.grisLetras),
          titleTextStyle: TextStyle(
              color: AppColors.grisLetras,
              fontSize: 17,
              fontWeight: FontWeight.bold),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.gris,
          selectionColor: AppColors.grisLetras.withOpacity(0.5),
          selectionHandleColor: AppColors.verdeLetras,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: AppColors.verdeNavbar,
          ),
        ),
      ),
      initialRoute: isSignedIn ? AppRoutes.home : AppRoutes.preLogin,
      getPages: AppRoutes.routes,
    );
  }
}
