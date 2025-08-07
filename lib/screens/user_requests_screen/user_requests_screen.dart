import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/viewModels/user/user_request_controller/user_request_controller.dart';

class UserRequestsScreen extends StatefulWidget {
  const UserRequestsScreen({super.key});

  @override
  State<UserRequestsScreen> createState() => _UserRequestsScreenState();
}

class _UserRequestsScreenState extends State<UserRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserRequestController());
    return Obx(() {
      if (controller.rideRequests.isEmpty) {
        return const Center(child: Text("No ride requests."));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.rideRequests.length,
        itemBuilder: (context, index) {
          final request = controller.rideRequests[index];
          final id = request['id'];
          final status = request['status'] ?? 'pending';
          final countdown = controller.countdownMap[id] ?? 60;
          final String pickUp = request['pickup_address'];
          final String dest = request['selected_dest'];
          final String driverName = request['driver_name'];

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoBox("Driver", driverName),
                  const SizedBox(height: 8),
                  _buildInfoBox("Pickup", pickUp),
                  const SizedBox(height: 8),
                  _buildInfoBox("Destination", dest),
                  const SizedBox(height: 8),
                  _buildInfoBox(
                    "Estimated Price",
                    "${request['trip_price']} MMK",
                  ),
                  const SizedBox(height: 16),

                  if (status == 'pending') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "⏳ Expires in: $countdown sec",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: countdown <= 10 ? Colors.red : Colors.black,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('requests')
                                .doc(id)
                                .delete();
                            controller.rideRequests.removeWhere(
                              (r) => r['id'] == id,
                            );
                          },
                        ),
                      ],
                    ),
                  ] else if (status == 'accepted') ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "✅ Driver accepted and is coming to you.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('requests')
                                  .doc(id)
                                  .update({'status': 'completed'});
                              controller.rideRequests.removeWhere(
                                (r) => r['id'] == id,
                              );
                              Get.toNamed('/history');
                            },
                            icon: const Icon(Icons.check_circle),
                            label: const Text("Complete Ride"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (status == 'completed') ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Ride completed.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      );
    });
  }
}

Widget _buildInfoBox(String label, String value) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(10),
    ),
    child: RichText(
      text: TextSpan(
        text: '$label: ',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}
