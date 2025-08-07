import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class OwayListController extends GetxController {
  RxList<Map<String, dynamic>> drivers = <Map<String, dynamic>>[].obs;
  RxString selectedTownship = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDrivers();
  }

  void fetchDrivers() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('drivers')
          .get();

      drivers.value = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching drivers: $e");
    }
  }

  void setSelectedTownship(String township) {
    selectedTownship.value = township;
  }
}
