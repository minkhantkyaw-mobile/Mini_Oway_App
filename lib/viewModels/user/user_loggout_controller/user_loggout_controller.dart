import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../screens/user_screen/user_login_screen.dart';
import '../../mainLayout_controller/mainLayout_controller.dart';
class UserLoggoutController extends GetxController {
  void handleLogout() async {
   try{
     // Reset tab index to 0 so user doesn't return to logout screen
     final layoutController = Get.find<MainLayoutController>();
     layoutController.selectedIndex.value = 0;

     // Sign out the user
     await FirebaseAuth.instance.signOut();

     // Navigate to login screen and clear navigation stack
     Get.offAll(() => LoginScreen());
   }catch(e){
     Get.snackbar('Error', 'Failed to log out: $e');
   }
  }
}