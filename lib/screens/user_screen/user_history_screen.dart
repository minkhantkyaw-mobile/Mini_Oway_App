import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/screens/user_screen/user_receipt_screen.dart';
import 'package:project_one/viewModels/user/user_history_controller/user_history_controller.dart';

class UserHistoryScreen extends StatelessWidget {
  const UserHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserHistoryController());

    return Obx(() {
      if (controller.acceptedRequests.isEmpty) {
        return const Center(
          child: Text(
            "No accepted rides yet.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
      }
      final dataLength = controller.acceptedRequests.length;

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: dataLength,
        itemBuilder: (context, index) {
          final request = controller.acceptedRequests[index];
          final String driverId = request['driver_id'];
          final String driverName = request['driver_name'];
          final String fees = request['trip_price'].toString();
          final String pickUp = request['pickup_address'];
          final String dest = request['destination_address'];

          return Card(
            elevation: 5,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            shadowColor: Colors.blueGrey.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Top row with icon, driver name & price, and button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.drive_eta,
                        color: Colors.blueAccent,
                        size: 36,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                driverName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Price: $fees MMK",
                                style: TextStyle(
                                  color: Colors.blueGrey[700],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.to(
                            UserReceiptScreen(
                              driverName: driverName,
                              driverId: driverId,
                              pickUpAddress: pickUp,
                              destAddress: dest,
                              tripPrice: fees,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFFDFDED6,
                          ), // your original light color
                          elevation: 2, // subtle shadow
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Pickup location row
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.redAccent,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "From: $pickUp",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Destination location row
                  Row(
                    children: [
                      const Icon(Icons.flag, color: Colors.green, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "To: $dest",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
