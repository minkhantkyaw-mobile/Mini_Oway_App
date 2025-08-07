import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneCallFunction extends GetxController {
  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      await launchUrl(callUri, mode: LaunchMode.externalApplication);

      // Get.snackbar("Error", "Could not launch $phoneNumber");
    } catch (e) {
      print('Call Error: $e');
      Get.snackbar("Exception", e.toString());
    }
  }
}
