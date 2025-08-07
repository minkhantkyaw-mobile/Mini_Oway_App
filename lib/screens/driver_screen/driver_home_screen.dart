import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_one/viewModels/driver/driver_controller/driver_controller.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final DriverController controller = Get.put(DriverController());
  final MapController mapController = MapController();
  bool hasMoved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Obx(() {
        LatLng fallbackLocation = LatLng(21.9588, 96.0891);
        final pos = controller.currentPosition.value;
        if (pos == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // Move map when position changes
        if (!hasMoved) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            mapController.move(fallbackLocation, 15);
            hasMoved = true;
          });
        }

        return Column(
          children: [
            // Map
            SizedBox(
              height: 300,
              child: Obx(
                () => FlutterMap(
                  mapController: mapController,
                  options: MapOptions(initialCenter: pos),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                      userAgentPackageName: 'com.example.project_one',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: fallbackLocation,
                          width: 50,
                          height: 50,
                          child: Icon(
                            Icons.my_location,
                            color: Colors.blue,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                    if (controller.route.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: controller.route,
                            strokeWidth: 8.0,
                            color: const Color.fromARGB(255, 1, 19, 131),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            // Availability toggle
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Availables'),
                  Obx(
                    () => Switch(
                      value: controller.available.value,
                      onChanged: controller.toggleAvailable,
                    ),
                  ),
                ],
              ),
            ),

            // Ride requests list
            Expanded(
              child: Obx(() {
                final isAvailable = controller.available.value;
                // print(isAvailable);
                final requestList = controller.rideRequests;
                if (controller.rideRequests.isEmpty) {
                  return const Center(
                    child: Text('No ride requests currently'),
                  );
                }
                // print("Requests : ${controller.rideRequests}");

                return Stack(
                  children: [
                    ListView.builder(
                      itemCount: controller.rideRequests.length,
                      itemBuilder: (context, index) {
                        final request = controller.rideRequests[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            title: Text(request['user_name'] ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder<String>(
                                  future: controller.getAddressFromLatLng(
                                    request['user_lat'],
                                    request['user_long'],
                                  ),
                                  builder: (context, snapshot) {
                                    final pickupAddress =
                                        snapshot.data ?? 'Loading...';
                                    return GestureDetector(
                                      onTap: () {
                                        final lat =
                                            double.tryParse(
                                              request['user_lat'] ?? '',
                                            ) ??
                                            0.0;
                                        final long =
                                            double.tryParse(
                                              request['user_long'] ?? '',
                                            ) ??
                                            0.0;
                                        controller.drawRouteToPickup(lat, long);
                                      },
                                      child: Text(
                                        'Pickup: $pickupAddress',
                                        maxLines: 1,
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 8),
                                FutureBuilder<String>(
                                  future: controller.getAddressFromLatLng(
                                    request['destination_lat'],
                                    request['destination_long'],
                                  ),
                                  builder: (context, snapshot) {
                                    final destAddress =
                                        snapshot.data ?? 'Loading...';
                                    return GestureDetector(
                                      onTap: () {
                                        final lat =
                                            double.tryParse(
                                              request['destination_lat'] ?? '',
                                            ) ??
                                            0.0;
                                        final long =
                                            double.tryParse(
                                              request['destination_long'] ?? '',
                                            ) ??
                                            0.0;
                                        controller.drawRouteToPickup(lat, long);
                                      },
                                      child: Text(
                                        'Destination: $destAddress',
                                        maxLines: 1,
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 12),

                                Text(
                                  'Trip Price: ${request['trip_price'] ?? ''} MMK',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                if (request['status'] == 'pending')
                                  Obx(() {
                                    final requestId = request['id'] as String;
                                    final timeLeft =
                                        controller.countdownMap[requestId] ??
                                        'Time Up';

                                    return Text(
                                      '⏳ Respond in: ${timeLeft}s',
                                      style: const TextStyle(
                                        color: Colors.deepOrange,
                                      ),
                                    );
                                  }),
                                if (request['status'] == 'rejected')
                                  const Text(
                                    '❌ You rejected this request',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                if (request['status'] == 'accepted' &&
                                    request['confirmed'] == true)
                                  const Text(
                                    '✅ User confirmed the trip',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                if (request['status'] == 'accepted' &&
                                    request['confirmed'] != true)
                                  const Text(
                                    '✅ You accepted the trip',
                                    style: TextStyle(color: Colors.orange),
                                  ),
                              ],
                            ),
                            trailing: () {
                              final status = request['status'];
                              // print(status);
                              final confirmed = request['confirmed'] == true;

                              if (status == 'pending') {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        final requestId = request['id'];
                                        controller.rejectRequest(requestId);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        final requestId = request['id'];
                                        controller.acceptRequest(requestId);
                                      },
                                    ),
                                  ],
                                );
                              }

                              if (status == 'rejected') {
                                return const Icon(
                                  Icons.block,
                                  color: Colors.grey,
                                );
                              }

                              if (status == 'accepted' && confirmed) {
                                return const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                );
                              }

                              return const SizedBox();
                            }(),
                          ),
                        );
                      },
                    ),
                    if (!isAvailable)
                      Positioned.fill(
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                            child: Container(
                              color: Colors.black.withOpacity(0.2),
                              alignment: Alignment.center,
                              child: const Text(
                                '🕓 Unavailable - Toggle to accept requests',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ],
        );
      }),
      // bottomNavigationBar: Obx(() {
      //   return BottomNavigationBar(
      //     currentIndex: controller.selectedIndex.value,
      //     onTap: controller.changeNavIndex,
      //     items: const [
      //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //       BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.settings),
      //         label: 'Settings',
      //       ),
      //     ],
      //   );
      // }),
    );
  }
}
