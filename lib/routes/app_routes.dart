import 'package:get/get.dart';
import 'package:agro/screens/login/login_screen.dart';
import 'package:agro/screens/search_screen.dart';
import 'package:agro/screens/home/home_screen.dart';
import 'package:agro/screens/login/pre_login_screen.dart';
import 'package:agro/screens/login/create_account_screen.dart';
import 'package:agro/screens/profile/config_address_screen.dart';
import 'package:agro/screens/profile/map2_screen.dart';
import 'package:agro/screens/profile/config_account_screen.dart';
import 'package:agro/screens/profile/config_notifications_screen.dart';
import 'package:agro/screens/profile/all_orders_screen.dart';
import 'package:agro/screens/profile/support_screen.dart';
import 'package:agro/screens/profile/terms_and_politics_screen.dart';
import 'package:agro/widgets/home/detail_product_widget.dart';
import 'package:agro/screens/home/shopping_cart_screen.dart';

class AppRoutes {
  static const String preLogin = '/';
  static const String login = '/login';
  static const String createAccount = '/createAccount';
  static const String home = '/home';
  static const String configAddress = '/configAddress';
  static const String map2 = '/map';
  static const String configAccount = '/configAccount';
  static const String configNotifications = '/configNotifications';
  static const String allOrders = '/allOrders';
  static const String search = '/search';
  static const String support = '/support';
  static const String termsAndPolitics = '/termsAndPolitics';
  static const String detailProduct = '/detailProduct';
  static const String shoppingCart = '/shoppingCart';

  static final routes = [
    GetPage(name: preLogin, page: () => const PreLoginScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: createAccount, page: () => CreateAccountScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: configAddress, page: () => ConfigAddressScreen()),
    GetPage(name: map2, page: () => const Map2Screen()),
    GetPage(name: configAccount, page: () => ConfigAccountScreen()),
    GetPage(name: configNotifications, page: () => ConfigNotificationsScreen()),
    GetPage(name: allOrders, page: () => AllOrdersScreen()),
    GetPage(name: support, page: () => SupportScreen()),
    GetPage(name: termsAndPolitics, page: () => TermsAndPoliticsScreen()),
    GetPage(name: detailProduct, page: () => DetailProductWidget()),
    GetPage(name: shoppingCart, page: () => ShoppingCartScreen()),
    GetPage(name: search, page: () => SearchScreen()),
  ];
}
