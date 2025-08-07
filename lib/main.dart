import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_one/firebase_options.dart';
import 'package:project_one/screens/splash_screen/splash_screen.dart';
import 'package:project_one/theme/theme.dart';
import 'package:project_one/viewModels/driver/driver_login/driver_login_controller.dart';
import 'package:project_one/viewModels/driver_payment_updater/driver_payment_updater.dart';
import 'package:project_one/viewModels/phone_call/phone_call_function.dart';
import 'package:project_one/viewModels/user/user_login/user_login_controller.dart';
import 'package:project_one/viewModels/user/user_receipt_controller/user_receipt_controller.dart';
import 'package:project_one/viewModels/user/user_signup/user_signup_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.requestPermission();
  await GetStorage.init();
  // await DriverPaymentStatusUpdater.updateExpiredDrivers();
  Get.put(UserSignupController());
  Get.put(UserLoginController());
  Get.put(DriverLoginController());
  Get.put(PhoneCallFunction());
  Get.put(UserReceiptController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: SplashScreen(),
    );
  }
}
