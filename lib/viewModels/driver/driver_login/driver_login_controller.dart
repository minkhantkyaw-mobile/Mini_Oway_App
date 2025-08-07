import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/screens/driver_screen/driver_billing_screen.dart';

class DriverLoginController extends GetxController {
  static DriverLoginController instance = Get.find();
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
          .collection('drivers')
          .doc(uid)
          .get();

      final driverData = userDoc.data();
      final paidStatus = driverData?['paid'] ?? 'unpaid';
      final Timestamp createdAtTimestamp = driverData?['createdAt'];
      final Timestamp nextDueDateTimestamp = driverData?['nextDueDate'];

      final DateTime createdAt = createdAtTimestamp.toDate();
      final DateTime nextDueDate = nextDueDateTimestamp.toDate();
      final DateTime now = DateTime.now();
      final DateTime expiryDate = nextDueDate.add(Duration(days: 30));

      // Validate login eligibility
      if (paidStatus == 'paid') {
        Get.back(); // Close loading dialog
        return driverData?['driver_name'];
      } else if (paidStatus == 'onemonthfreetrial' &&
          now.isBefore(expiryDate)) {
        Get.back();
        return driverData?['driver_name'];
      } else {
        // Trial expired or unpaid
        // Optionally update Firestore to mark as unpaid
        await FirebaseFirestore.instance.collection('drivers').doc(uid).update({
          'paid': 'unpaid',
          'isActive': false,
        });

        await _auth.signOut();

        Get.back(); // Close loading
        // Navigate to billing screen with driver UID or data
        Get.offAll(() => BillingScreen(driverId: uid));
        Get.snackbar(
          "Access Denied",
          "Your trial has ended. Please pay to continue.",
        );
        return null;
      }
    } on FirebaseAuthException catch (e) {
      Get.back(); // close loading dialog
      Get.snackbar("Error", e.message ?? "Login failed");
      return null;
    }
  }
}
