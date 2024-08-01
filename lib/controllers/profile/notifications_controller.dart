import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigNotificationsController extends GetxController {
  var emailNotification = false.obs;
  var smsNotification = false.obs;
  var whatsappNotification = false.obs;

  late SharedPreferences prefs;

  @override
  void onInit() {
    super.onInit();
    _loadPreferences();
  }

  void _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    emailNotification.value = prefs.getBool('emailNotification') ?? false;
    smsNotification.value = prefs.getBool('smsNotification') ?? false;
    whatsappNotification.value = prefs.getBool('whatsappNotification') ?? false;
  }

  void toggleEmailNotification() {
    emailNotification.value = !emailNotification.value;
    prefs.setBool('emailNotification', emailNotification.value);
  }

  void toggleSmsNotification() {
    smsNotification.value = !smsNotification.value;
    prefs.setBool('smsNotification', smsNotification.value);
  }

  void toggleWhatsappNotification() {
    whatsappNotification.value = !whatsappNotification.value;
    prefs.setBool('whatsappNotification', whatsappNotification.value);
  }
}
