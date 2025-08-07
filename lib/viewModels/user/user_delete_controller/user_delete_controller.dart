import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:project_one/screens/splash_screen/splash_screen.dart';

class UserDeleteController extends GetxController {
  final isDeleting = false.obs;

  Future<void> deleteAccount() async {
    try {
      isDeleting.value = true;

      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;

      if (uid == null) throw Exception('User not found');
      // 🔥 Delete Firestore user document first
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      // 🔐 Then delete authentication account
      await user!.delete();
      isDeleting.value = false;

      Get.offAll(()=> SplashScreen());
      Get.snackbar("Success", "Account deleted successfully");
    } on FirebaseAuthException catch (e) {
      isDeleting.value = false;
      if (e.code == 'requires-recent-login') {
        Get.snackbar(
          'Re-authentication Required',
          'Please log in again and try deleting your account.',
        );
      } else {
        Get.snackbar('Error', e.message ?? 'Something went wrong');
      }
    } catch (e) {
      isDeleting.value = false;
      Get.snackbar('Error', 'Failed to delete account: $e');
      print(e);
    }
  }
}
