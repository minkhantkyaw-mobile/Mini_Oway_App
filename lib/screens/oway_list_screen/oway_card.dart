import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../viewModels/favorite_controller/favorite_controller.dart';

class OwayCard extends StatelessWidget {
  final Map<String, dynamic> driver;


   OwayCard({super.key, required this.driver});


  @override
  Widget build(BuildContext context) {
    final Favoritecontroller controller = Get.find();
    final String driverId = driver['id'] ?? '';

    final rawUrl = driver['driver_image'];
    final imageUrl = (rawUrl != null && rawUrl is String && rawUrl.isNotEmpty)
        ? rawUrl
        : 'https://www.turners.co.nz/Assets/images/default-car.png';
    final driverData = driver;
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias, // clips the content to rounded border
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with gradient overlay and rating badge
          Stack(
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/default_driver.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Gradient overlay for better contrast on top-left texts
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Favorite icon badge
              Positioned(
                top: 12,
                right: 12,
                child: Obx(() {
                  final isFav = controller.isFavorite(driverId);
                  print(isFav);
                  return GestureDetector(
                    onTap: () => controller.toggleFavorite(driver),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isFav ? Colors.redAccent : Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.white : Colors.green,
                      ),
                    ),
                  );
                }),

              ),
            ],
          ),

          // Padding for texts
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Driver Name
                Row(
                  children: [
                    const Icon(Icons.person, size: 20, color: Colors.blueAccent),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        driver['driver_name'] ?? 'No Name',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Driver Phone
                Row(
                  children: [
                    const Icon(Icons.phone, size: 18, color: Colors.green),
                    const SizedBox(width: 6),
                    Text(
                      driver['phone'] ?? 'No Phone',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),

                    // Optional: call button
                    IconButton(
                      icon: const Icon(Icons.call, color: Colors.green),
                      onPressed: () {
                        // TODO: Add call functionality
                      },
                      tooltip: 'Call Driver',
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Driver Address
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        driver['township'] ?? 'No Address',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
