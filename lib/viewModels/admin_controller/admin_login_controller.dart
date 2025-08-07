import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/screens/admin_screen/admin_home_screen.dart';

class AdminLoginController extends GetxController {
  static AdminLoginController instance = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String allowedAdminEmail = "admin@oway.gmail.com";

  Future<void> login(String email, String password) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("This is user credential: $userCredential");
      print("This is email : $email");
      print("This is allowed email : $allowedAdminEmail");

      if (email.trim().toLowerCase() == allowedAdminEmail.toLowerCase()) {
        Get.offAll(() => AdminHomeScreen());
      } else {
        await _auth.signOut();
        Get.snackbar(
          "Access Denied",
          "This account is not authorized as admin.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login Failed",
        e.message ?? "Error logging in",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
