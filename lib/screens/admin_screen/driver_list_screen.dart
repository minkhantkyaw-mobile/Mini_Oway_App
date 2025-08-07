import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/screens/admin_screen/admin_driver_detail_screen.dart';

import '../../viewModels/admin_controller/admin_driver_list_controller.dart';

class DriverListScreen extends StatelessWidget {
  const DriverListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminDriverListController());

    return Scaffold(
      body: Obx(() {
        final driverList = controller.drivers;
        final filteredList = controller.filteredDrivers;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search by name or email",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) => controller.searchQuery.value = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Total: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${filteredList.length}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: filteredList.isEmpty
                    ? Center(child: Text("No drivers found"))
                    : ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final driver = filteredList[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                () => AdminDriverDetailScreen(driver: driver),
                              );
                            },
                            child: Card(
                              color: Colors.blueGrey,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.grey[200],
                                    backgroundImage: NetworkImage(
                                      driver['driver_image'] ?? '',
                                    ),
                                    onBackgroundImageError: (_, __) =>
                                        const Icon(Icons.person, size: 40),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: buildDriverList(
                                      name: driver['driver_name'] ?? '',
                                      email: driver['email'] ?? '',
                                      address:
                                          driver['address'] ?? 'No address',
                                      phone: driver['phone'] ?? '',
                                      payment: driver['paid'] ?? 'unknown',
                                      date: driver['createdAt'] != null
                                          ? (driver['createdAt'] as Timestamp)
                                                .toDate()
                                                .toString()
                                                .split(' ')
                                                .first
                                          : 'Unknown',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget buildDriverList({
    required String name,
    required String email,
    required String address,
    required String phone,
    required String payment,
    required String date,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoRow('Name:', name),
        _infoRow('Joined Date:', date),
        _infoRow('Email:', email),
        _infoRow('Payment:', payment),
      ],
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
