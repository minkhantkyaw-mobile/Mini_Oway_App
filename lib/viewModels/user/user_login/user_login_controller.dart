import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/screens/main_layout/main_layout_screen.dart';

class UserLoginController extends GetxController {
  static UserLoginController instance = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final uid = _auth.currentUser!.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      final userName = userDoc['name'];

      Get.back(); // close loading dialog
      Get.offAll(()=> MainLayoutScreen());
      return userName;
    } on FirebaseAuthException catch (e) {
      Get.back(); // close loading dialog
      Get.snackbar("Error", e.message ?? "Login failed");
      return null;
    }
  }
}
