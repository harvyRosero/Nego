import 'package:get/get.dart';
import 'package:agro/screens/login_screen.dart';
import 'package:agro/screens/company_info_screen.dart';
import 'package:agro/screens/search_screen.dart';
import 'package:agro/screens/home_screen.dart';
import 'package:agro/screens/add_ad_screen.dart';
import 'package:agro/screens/create_company_screen.dart';

class AppRoutes {
  static String login = '/';
  static const String home = '/home';
  static const String companyInfo = '/companyInfo';
  static const String search = '/search';
  static const String adMaker = '/adAdd';
  static const String createCompany = '/createComapany';

  static final routes = [
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: companyInfo, page: () => CompanyInfo()),
    GetPage(name: search, page: () => SearchScreen()),
    GetPage(name: adMaker, page: () => AddAdScreen()),
    GetPage(name: createCompany, page: () => CreateCompanyScreen()),
  ];
}
