import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/screens/welcome_screen.dart';

class UserSignupController extends GetxController {
  static UserSignupController instance = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register(
    String name,
    String email,
    String password,
    String phone,
    String address,
    BuildContext context,
  ) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'name': name,
            'email': email,
            'createdAt': Timestamp.now(),
            'password': password,
            'phone': phone,
            'address': address,
          });
      Get.offAll(() => WelcomeScreen());
      Get.snackbar("Success", "Account created!");
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Signup failed");
      print(e.message);
    }
  }
}
