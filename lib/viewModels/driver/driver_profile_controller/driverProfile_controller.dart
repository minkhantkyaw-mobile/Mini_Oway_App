import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DriverprofileController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;
  var imageUrl = ''.obs;
  var joinedDate = ''.obs;

  //For Images To Upload
  var imageUrlToChange = ''.obs;
  var isLoading = false.obs;

  final _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadDriverProfile();
  }

  void loadDriverProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email.value = user.email ?? '';

      final doc = await FirebaseFirestore.instance
          .collection('drivers')
          .doc(user.uid)
          .get();

      final data = doc.data();
      if (data != null) {
        name.value = data['driver_name'] ?? '';
        phoneNumber.value = data['phone'] ?? '';
        imageUrl.value = data['driver_image'] ?? '';
        Timestamp timestamp = data['createdAt'];
        DateTime date = timestamp.toDate();
        joinedDate.value = "${date.day}/${date.month}/${date.year}";
      }
    }
  }

  // ✅ Pick and upload image
  Future<void> pickAndUploadImage() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      isLoading.value = true;
      File imageFile = File(picked.path);
      final base64Image = base64Encode(await imageFile.readAsBytes());
      final fileName = path.basename(imageFile.path);

      const uploadUrl = "https://upload.imagekit.io/api/v1/files/upload";

      final privateKey = "private_A+shldOCAZR5u30oea69k95axIU=";
      const folder = "/Oway/Users";

      final response = await http.post(
        Uri.parse(uploadUrl),
        headers: {
          'Authorization':
          'Basic ${base64Encode(utf8.encode(privateKey + ":"))}',
        },
        body: {'file': base64Image, 'fileName': fileName, 'folder': folder},
      );

      if (response.statusCode == 200) {
        final url = jsonDecode(response.body)['url'];
        imageUrlToChange.value = url;

        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          await FirebaseFirestore.instance.collection('drivers').doc(uid).update({
            'driver_image': url,
          });
        }
        imageUrl.value = url;
        Get.snackbar("✅ Success", "Image uploaded successfully");
      } else {
        print("❌ Upload failed: ${response.body}");
        Get.snackbar("❌ Error", "Upload failed");
      }
    } catch (e) {
      print("❌ Exception: $e");
      Get.snackbar("❌ Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
