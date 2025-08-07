import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class UserReceiptController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observables
  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString phone = ''.obs;
  RxString address = ''.obs;
  static RxString imageUrl = ''.obs;

  var driverPhone = ''.obs;
  var driverLocation = ''.obs;
  var driverImage = ''.obs;

  final ScreenshotController screenshotController = ScreenshotController();

  var downloading = false.obs;
  var progress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  void fetchUserProfile() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      Get.snackbar("Error", "No user logged in");
      return;
    }

    try {
      final doc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (doc.exists) {
        final data = doc.data();
        name.value = data?['name'] ?? '';
        email.value = data?['email'] ?? currentUser.email ?? '';
        phone.value = data?['phone'] ?? '';
        address.value = data?['address'] ?? '';
        imageUrl.value = data?['imageUrl'] ?? '';
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user data");
      print("Firestore error: $e");
    }
  }

  Future<void> getDriverInfo(String driverId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('drivers')
          .doc(driverId)
          .get();
      if (snapshot.exists) {
        final data = snapshot.data();
        driverPhone.value = data?['phone'] ?? '';
        driverLocation.value = data?['address'] ?? '';
        driverImage.value = data?['driver_image'] ?? '';
      }
    } catch (e) {
      print('Driver info fetch error: $e');
    }
  }

  // Get save path depending on platform
  Future<String> getDownloadPath(String fileName) async {
    if (Platform.isAndroid) {
      final directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        return p.join(directory.path, fileName);
      } else {
        final dir = await getApplicationDocumentsDirectory();
        return p.join(dir.path, fileName);
      }
    } else {
      final dir = await getApplicationDocumentsDirectory();
      return p.join(dir.path, fileName);
    }
  }

  Future<void> downloadFile(String url, String fileName) async {
    try {
      downloading.value = true;
      progress.value = 0;

      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt;

        PermissionStatus status;

        if (sdkInt >= 33) {
          status = await Permission.videos.request();
        } else if (sdkInt >= 30) {
          status = await Permission.manageExternalStorage.request();
        } else {
          status = await Permission.storage.request();
        }

        if (!status.isGranted) {
          Get.snackbar("Permission", "Storage permission is required");
          downloading.value = false;
          return;
        }
      }

      final savePath = await getDownloadPath(fileName);
      print("Saving to path: $savePath");

      Get.dialog(_DownloadProgressDialog());

      await Dio().download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            progress.value = received / total;
          }
        },
      );

      Get.back(); // close progress dialog
      Get.snackbar("Download Complete", "Saved to $savePath");
    } catch (e, stackTrace) {
      Get.back();
      Get.snackbar("Download Failed", e.toString());
      print("Download failed: $e");
      print(stackTrace);
    } finally {
      downloading.value = false;
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        Future.delayed(const Duration(seconds: 1), () {
          if (Navigator.of(dialogContext).canPop()) {
            Navigator.of(dialogContext).pop();
          }
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: -55,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.teal,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(height: 20),
                    Text(
                      "Successfully",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Receipt saved to storage.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Download progress dialog widget
class _DownloadProgressDialog extends StatelessWidget {
  final UserReceiptController c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final percent = (c.progress.value * 100).toStringAsFixed(0);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Downloading...", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              LinearProgressIndicator(value: c.progress.value),
              const SizedBox(height: 10),
              Text("$percent%"),
            ],
          );
        }),
      ),
    );
  }
}
