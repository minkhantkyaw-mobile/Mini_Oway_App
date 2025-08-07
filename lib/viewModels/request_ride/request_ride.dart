import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/viewModels/mainLayout_controller/mainLayout_controller.dart';

class RequestRide extends GetxController {
  Future<void> requestRide({
    required String driverId,
    required String driverName,
    required String userId,
    required String userName,
    required double userLat,
    required double userLong,
    required double destinationLat,
    required double destinationLong,
    required int totalPrice,
    required String selectedDestination,
  }) async {
    // Show circular loading dialog
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    try {
      // ✅ Check if the user already has a pending request
      final alreadyRequested = await hasPendingRequest(userId);

      if (alreadyRequested) {
        if (Get.isDialogOpen ?? false) Get.back();
        Get.snackbar(
          "Already Requested",
          "You already have a pending request. Please wait until it’s accepted or expired.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      await FirebaseFirestore.instance.collection('requests').add({
        'driver_id': driverId,
        'driver_name': driverName,
        'user_id': userId,
        'user_name': userName,
        'user_lat': userLat.toStringAsFixed(2),
        'user_long': userLong.toStringAsFixed(2),
        'destination_lat': destinationLat.toStringAsFixed(2),
        'destination_long': destinationLong.toStringAsFixed(2),
        'status': 'pending',
        'timestamp': DateTime.now().toIso8601String(),
        'trip_price': totalPrice,
        'selected_dest': selectedDestination,
      });
      // Close the progress dialog and the bottom sheet
      if (Get.isDialogOpen ?? false) Get.back(); // close loading
      if (Get.isBottomSheetOpen ?? false) Get.back(); // close bottom sheet
      Get.snackbar("Success", "Ride request sent to $driverName");
      Get.find<MainLayoutController>().goToTab(7); // To open UserRequestsScreen
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back(); // ensure dialog closes on error
      }

      Get.snackbar("Error", "Failed to request ride");
      print("Request error: $e");
    }
  }

  Future<bool> hasPendingRequest(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('user_id', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .get();

    return snapshot.docs.isNotEmpty;
  }
}
