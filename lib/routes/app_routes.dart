import 'package:get/get.dart';
import 'package:agro/screens/login_screen.dart';
import 'package:agro/screens/profile_screen.dart';
import 'package:agro/screens/form_screeen.dart';
import 'package:agro/screens/company_info_screen.dart';
import 'package:agro/screens/search_screen.dart';
import 'package:agro/screens/home_screen.dart';
import 'package:agro/screens/ad_maker_screen.dart';

class AppRoutes {
  static String login = '/';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String form = '/form';
  static const String companyInfo = '/companyInfo';
  static const String search = '/search';
  static const String adMaker = '/adMaker';

  static final routes = [
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: profile, page: () => ProfileScreen()),
    GetPage(name: form, page: () => FormScreen()),
    GetPage(name: companyInfo, page: () => const CompanyInfo()),
    GetPage(name: search, page: () => SearchScreen()),
    GetPage(name: adMaker, page: () => AdMakerScreen()),
  ];
}
