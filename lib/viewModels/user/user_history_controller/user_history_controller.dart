import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class UserHistoryController extends GetxController {
  RxList<Map<String, dynamic>> acceptedRequests = <Map<String, dynamic>>[].obs;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    getUserHistory();
  }

  Future<void> getUserHistory() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('user_id', isEqualTo: currentUserId)
          .where('status', isEqualTo: 'completed')
          .orderBy('timestamp', descending: true)
          .get();

      // acceptedRequests.value = snapshot.docs.map((doc) => doc.data()).toList();
      final List<Map<String, dynamic>> requestsWithAddresses = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final pickupAddress = await getAddressFromLatLng(
          data['user_lat'],
          data['user_long'],
        );
        final destinationAddress = await getAddressFromLatLng(
          data['destination_lat'],
          data['destination_long'],
        );

        data['pickup_address'] = pickupAddress;
        data['destination_address'] = destinationAddress;

        requestsWithAddresses.add(data);
      }

      acceptedRequests.value = requestsWithAddresses;
    } catch (e) {
      print("History error : $e");
    }
  }

  // Make Lat and Long to User Firendly Place
  Future<String> getAddressFromLatLng(String lat, String lng) async {
    double dLat = double.parse(lat);
    double dLong = double.parse(lng);

    try {
      final placemarks = await placemarkFromCoordinates(dLat, dLong);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        print("${p.street}, ${p.locality}, ${p.administrativeArea}");
        return "${p.street}, ${p.locality}, ${p.administrativeArea}";
      }
    } catch (e) {
      print("Error reverse geocoding: $e");
    }

    return "Unknown";
  }
}
