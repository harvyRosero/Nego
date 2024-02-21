import 'package:get/get.dart';
import 'package:agro/screens/login_screen.dart';
import 'package:agro/screens/home_screen.dart';
import 'package:agro/screens/profile_screen.dart';
import 'package:agro/screens/form_screeen.dart';

class AppRoutes {
  static String login = '/';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String form = '/form';

  static final routes = [
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: profile, page: () => ProfileScreen()),
    GetPage(name: form, page: () => FormScreen()),
  ];
}
