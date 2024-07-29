import 'package:get/get.dart';
import 'package:agro/screens/login/login_screen.dart';
import 'package:agro/screens/search_screen.dart';
import 'package:agro/screens/home_screen.dart';
import 'package:agro/screens/login/pre_login_screen.dart';
import 'package:agro/screens/login/create_account_screen.dart';
import 'package:agro/screens/config_address_screen.dart';

class AppRoutes {
  static const String preLogin = '/';
  static const String login = '/login';
  static const String createAccount = '/createAccount';
  static const String home = '/home';
  static const String configAddress = '/configAddress';
  static const String search = '/search';
  static const String adMaker = '/adAdd';

  static final routes = [
    GetPage(name: preLogin, page: () => const PreLoginScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: createAccount, page: () => CreateAccountScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: configAddress, page: () => ConfigAddressScreen()),
    GetPage(name: search, page: () => SearchScreen()),
  ];
}
