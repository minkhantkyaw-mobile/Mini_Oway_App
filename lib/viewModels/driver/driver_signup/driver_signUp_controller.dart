import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_one/screens/driver_screen/driver_login_screen.dart';
import 'package:http/http.dart' as http;

class DriverSignupController extends GetxController {
  static DriverSignupController instance = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var imageFile = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  Future<void> register(
    String name,
    String email,
    String lat,
    String long,
    String vehicleType,
    String password,
    String phoneNumber,
    String townShip,
    String address,
    BuildContext context, {
    String? profileImageUrl,
  }) async {
    try {
      print("lOgin cllick");
      Get.dialog(const Center(child: CircularProgressIndicator()));
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final now = DateTime.now();
      final nextDue = now.add(Duration(days: 30));

      await FirebaseFirestore.instance
          .collection('drivers')
          .doc(userCredential.user!.uid)
          .set({
            'available': true,
            'driver_name': name,
            'email': email,
            'createdAt': Timestamp.now(),
            'password': password,
            'lat': lat,
            'long': long,
            'phone': phoneNumber,
            'vehicle_type': vehicleType,
            'township': townShip,
            'address': address,
            'driver_image': profileImageUrl,
            'paid': 'onemonthfreetrial',
            'isActive': true,
            'approved': true,
            'lastPaidDate': Timestamp.fromDate(now),
            'nextDueDate': Timestamp.fromDate(nextDue),
          });
      // After creating the driver document:
      await addPaymentRecord(
        driverId: userCredential.user!.uid,
        driverName: name,
        amount: 0,
        method: 'free_trial',
        note: 'One month free trial on registration',
      );
      Get.offAll(() => DriverLoginScreen());
      Get.snackbar("Success", "Account created!");
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Signup failed");
      print(e.message);
    }
  }

  Future<void> addPaymentRecord({
    required String driverId,
    required String driverName,
    required double amount,
    required String method,
    String? note,
  }) async {
    final now = DateTime.now();

    await FirebaseFirestore.instance.collection('driverpaymenthistory').add({
      'driverId': driverId,
      'driverName': driverName,
      'paidAtDate': Timestamp.fromDate(now),
      'amount': amount,
      'method': method,
      'note': note ?? '',
    });
  }

  ///For Capturing Images
  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    try {
      if (picked != null) {
        imageFile.value = File(picked.path);
      }
    } catch (e) {
      print("Image Capturing Error : $e");
    }
  }

  Future<String?> uploadToImageKit(File imageFile) async {
    print("image upload");
    final url = Uri.parse("https://upload.imagekit.io/api/v1/files/upload");

    final privateKey =
        "private_A+shldOCAZR5u30oea69k95axIU="; // your private key
    try {
      final fileName = imageFile.path.split('/').last;
      final bytes = await imageFile.readAsBytes();

      var request = http.MultipartRequest('POST', url);

      request.files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: fileName),
      );

      request.fields['fileName'] = fileName;
      request.fields['folder'] = "/Oway/Drivers";

      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$privateKey:'));
      request.headers['Authorization'] = basicAuth;

      final response = await request.send();

      final responseString = await response.stream.bytesToString();
      // print("Status Code: ${response.statusCode}");
      // print("Response Body: $responseString");

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(responseString);
        final filePath =
            responseJson['filePath']; // e.g. /Oway App/Drivers/photo 2025.jpg
        final encodedFilePath = Uri.encodeFull(filePath);
        // Your domain from ImageKit URL + encoded path (no updatedAt param needed)
        print("encoded: $encodedFilePath");
        return "https://ik.imagekit.io/5jov3h637$encodedFilePath";
      } else {
        return null;
      }
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }
}
