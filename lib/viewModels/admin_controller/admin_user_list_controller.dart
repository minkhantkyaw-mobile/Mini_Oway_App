import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminUserListController extends GetxController {
  RxList<Map<String, dynamic>> users = <Map<String, dynamic>>[].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void fetchUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    users.value = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Add document ID
      return data;
    }).toList();
  }

  List<Map<String, dynamic>> get filteredUsers {
    if (searchQuery.value.isEmpty) return users;
    return users.where((user) {
      final name = (user['name'] ?? '').toLowerCase();
      final email = (user['email'] ?? '').toLowerCase();
      return name.contains(searchQuery.value.toLowerCase()) ||
          email.contains(searchQuery.value.toLowerCase());
    }).toList();
  }
}
