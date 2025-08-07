import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminDriverListController extends GetxController {
  RxList<Map<String, dynamic>> drivers = <Map<String, dynamic>>[].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDrivers();
  }

  void fetchDrivers() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('drivers')
        .get();

    drivers.value = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'driver_name': data['driver_name'] ?? '',
        'driver_image': data['driver_image'] ?? '',
        'email': data['email'] ?? '',
        'phone': data['phone'] ?? '',
        'address': data['address'] ?? 'No address',
        'paid': data['paid'] ?? 'unknown',
        'createdAt': data['createdAt'],
        'lat': data['lat'] ?? '',
        'long': data['long'] ?? '',
        'vehicle_type': data['vehicle_type'] ?? 'Not specified',
        'is_available': data['is_available'] ?? false,
        'available': data['available'] ?? false,
        'approved': data['approved'] ?? false,
        'lastPaidDate': data['lastPaidDate'],
        'nextDueDate': data['nextDueDate'],
      };
    }).toList();
  }

  List<Map<String, dynamic>> get filteredDrivers {
    if (searchQuery.value.isEmpty) return drivers;
    return drivers.where((driver) {
      final name = (driver['driver_name'] ?? '').toLowerCase();
      final email = (driver['email'] ?? '').toLowerCase();
      return name.contains(searchQuery.value.toLowerCase()) ||
          email.contains(searchQuery.value.toLowerCase());
    }).toList();
  }
}
