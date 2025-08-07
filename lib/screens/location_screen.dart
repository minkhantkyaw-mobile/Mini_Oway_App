import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_one/screens/main_layout/main_layout_screen.dart';
import 'package:project_one/screens/pick_location/pick_location_screen.dart';
import 'package:project_one/viewModels/phone_call/phone_call_function.dart';
import 'package:project_one/viewModels/request_ride/request_ride.dart';
import 'package:http/http.dart' as http;

import '../viewModels/mainLayout_controller/mainLayout_controller.dart';

class LocationScreen extends StatefulWidget {
  final double? destinationLat;
  final double? destinationLng;

  const LocationScreen({super.key, this.destinationLat, this.destinationLng});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  PersistentBottomSheetController? _bottomSheetController;
  List<Marker> _markers = [];
  final PhoneCallFunction phoneCallFunction = Get.find<PhoneCallFunction>();
  LatLng? _selectedDestination;
  String? _selectedAddress;

  String? _lastDriverId;
  String? _lastDriverName;
  String? _lastDriverPhone;
  String? _lastVehicle;
  bool? _lastAvailable;
  String? _lastUserId;
  String? _lastUserName;
  double? _userLat;
  double? _userLong;
  LatLng? _lastDriverLatLng;

  List<LatLng> mockDriverToUserRoute = [
    LatLng(21.9409, 96.0891),
    LatLng(21.9450, 96.0850),
    LatLng(21.9500, 96.0800),
  ];

  List<LatLng> mockUserToDestRoute = [
    LatLng(21.9409, 96.0891),
    LatLng(21.9380, 96.0950),
    LatLng(21.9350, 96.1000),
  ];

  /// For Who Came from Detail Screen
  double? _distanceKm;
  int? _price;

  List<Polyline> _polylines = [];

  /// For drviers to move
  StreamSubscription? _driversSubscription;

  @override
  void initState() {
    super.initState();
    _userLat = 21.9409;
    _userLong = 96.0891;

    //  this block to initialize destination
    if (widget.destinationLat != null && widget.destinationLng != null) {
      _selectedDestination = LatLng(
        widget.destinationLat!,
        widget.destinationLng!,
      );
      print("🧭 Destination from detail screen: $_selectedDestination");
    }

    // _subscribeToDriverLocations().then((_) {
    //   if (_lastDriverLatLng != null &&
    //       widget.destinationLat != null &&
    //       widget.destinationLng != null) {
    //     print("get current");
    //     _getCurrentLocationAndCalculatePrice(
    //       widget.destinationLat!,
    //       widget.destinationLng!,
    //     );
    //   } else {
    //     print("Do not get ");
    //     // _initLocation(); // fallback if no driver
    //   }
    // });

    // Start listening to driver updates:
    _subscribeToDriverLocations();
  }

  void _setMockRouteLines() {
    setState(() {
      _polylines = [
        Polyline(
          points: mockDriverToUserRoute,
          strokeWidth: 4.5,
          color: Colors.blue,
        ),
        Polyline(
          points: mockUserToDestRoute,
          strokeWidth: 4.5,
          color: Colors.green,
        ),
      ];
    });
  }

  Future<void> _getCurrentLocationAndCalculatePrice(
    double destLat,
    double destLng,
  ) async {
    if (_lastDriverLatLng == null) {
      print("🚫 No driver selected yet. Cannot calculate price.");
      return;
    }

    final destination = LatLng(destLat, destLng);
    final address = await getAddressFromLatLng(destination);

    // Update state first
    _selectedDestination = destination;
    _selectedAddress = address;

    // Then trigger the UI refresh
    setState(() {}); // <== This is enough to rebuild

    // Now run the route and marker update
    _updateRouteLinesWithORS();
    _subscribeToDriverLocations();
  }

  // Future<void> _getCurrentLocationAndCalculatePrice(
  //   double destLat,
  //   double destLng,
  // ) async {
  //   if (_lastDriverLatLng == null) {
  //     print("🚫 No driver selected yet. Cannot calculate price.");
  //     return;
  //   }

  //   _selectedDestination = LatLng(destLat, destLng);
  //   _selectedAddress = await getAddressFromLatLng(_selectedDestination!);
  //   _loadDriverMarkers();
  // }

  Future<String> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      } else {
        return "No address available";
      }
    } catch (e) {
      print("Error in reverse geocoding: $e");
      return "Error fetching address";
    }
  }

  Future<void> _chooseDestination() async {
    Get.back();
    await Future.delayed(const Duration(milliseconds: 200));
    final picked = await Get.to<LatLng>(() => PickLocationScreen());

    if (picked != null && _lastDriverLatLng != null) {
      final address = await getAddressFromLatLng(picked);

      final Distance distance = Distance();

      final double distanceDriverToUser = distance.as(
        LengthUnit.Kilometer, // ✅ Ensure this is used
        _lastDriverLatLng!,
        LatLng(_userLat!, _userLong!),
      );

      final double distanceUserToDestination = distance.as(
        LengthUnit.Kilometer, // ✅ Again, confirm units
        LatLng(_userLat!, _userLong!),
        picked,
      );

      final double totalDistance =
          distanceDriverToUser + distanceUserToDestination;
      final int pricePerKm = 500;
      final int totalPrice = (totalDistance * pricePerKm)
          .round(); // ✅ Should be correct now

      setState(() {
        _selectedDestination = picked;
        _selectedAddress = address;
        print("This is selected Addresss : $_selectedAddress");
        _updateRouteLinesWithORS();
      });
      _subscribeToDriverLocations();
      _showBottomSheetWithDestination(
        driverId: _lastDriverId!,
        name: _lastDriverName ?? '',
        phone: _lastDriverPhone ?? '',
        vehicle: _lastVehicle ?? '',
        available: _lastAvailable ?? true,
        userId: _lastUserId ?? '',
        userName: _lastUserName ?? '',
        driverLatLng: _lastDriverLatLng!,
        context: context,
        phoneCallFunction: phoneCallFunction,
        requestRideController: Get.find<RequestRide>(),
        totalPrice: totalPrice,
      );
    }
  }

  void _showModalBottomSheetWithDestination({
    required String driverId,
    required String name,
    required String phone,
    required String vehicle,
    required bool available,
    required String userId,
    required String userName,
    required LatLng driverLatLng,
    required BuildContext context,
    required PhoneCallFunction phoneCallFunction,
    required RequestRide requestRideController,
    int? totalPrice,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Driver Details
                  Row(
                    children: [
                      const Icon(Icons.person, size: 20, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 20, color: Colors.green),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => phoneCallFunction.makePhoneCall(phone),
                        child: Text(
                          phone,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_car,
                        size: 20,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Text("Vehicle: $vehicle"),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 20,
                        color: Colors.teal,
                      ),
                      const SizedBox(width: 8),
                      Text("Available: ${available ? 'Yes' : 'No'}"),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 20,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Destination: ${_selectedAddress ?? 'Not set'}",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.attach_money,
                        size: 20,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Price: ${totalPrice?.toString() ?? 'Calculating...'} MMK",
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons (2 rows)
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.cancel),
                        label: const Text("Cancel"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => phoneCallFunction.makePhoneCall(phone),
                        icon: const Icon(Icons.call),
                        label: const Text("Call"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _chooseDestination(),
                        icon: const Icon(Icons.map),
                        label: const Text("Choose Destination"),
                      ),
                      ElevatedButton.icon(
                        onPressed: (totalPrice == null)
                            ? null
                            : () {
                                Navigator.of(context).pop();
                                requestRideController.requestRide(
                                  driverId: driverId,
                                  driverName: name,
                                  userId: userId,
                                  userName: userName,
                                  userLat: _userLat!,
                                  userLong: _userLong!,
                                  destinationLat:
                                      _selectedDestination?.latitude ?? 0.0,
                                  destinationLong:
                                      _selectedDestination?.longitude ?? 0.0,
                                  totalPrice: totalPrice,
                                  selectedDestination: _selectedAddress ?? '',
                                );
                                // Delay slightly to allow bottom sheet pop
                                Future.delayed(
                                  Duration(milliseconds: 1000),
                                  () {
                                    final layoutController =
                                        Get.find<MainLayoutController>();
                                    layoutController.selectedIndex.value = 7;
                                    Get.offAll(() => MainLayoutScreen());
                                  },
                                );
                              },

                        icon: const Icon(Icons.send),
                        label: const Text("Request"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (totalPrice == null)
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheetWithDestination({
    required String driverId,
    required String name,
    required String phone,
    required String vehicle,
    required bool available,
    required String userId,
    required String userName,
    required LatLng driverLatLng,
    required BuildContext context,
    required PhoneCallFunction phoneCallFunction,
    required RequestRide requestRideController,
    int? totalPrice,
  }) {
    final scaffoldState = Scaffold.of(context);
    // Store the controller so you can close it manually

    _bottomSheetController = scaffoldState.showBottomSheet((context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Driver Details
                Row(
                  children: [
                    const Icon(Icons.person, size: 20, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 20, color: Colors.green),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => phoneCallFunction.makePhoneCall(phone),
                      child: Text(
                        phone,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.directions_car,
                      size: 20,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text("Vehicle: $vehicle"),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 20,
                      color: Colors.teal,
                    ),
                    const SizedBox(width: 8),
                    Text("Available: ${available ? 'Yes' : 'No'}"),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 20, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Destination: ${_selectedAddress ?? 'Not set'}",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.attach_money,
                      size: 20,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Price: ${totalPrice?.toString() ?? 'Calculating...'} MMK",
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Action Buttons (2 rows)
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.cancel),
                      label: const Text("Cancel"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => phoneCallFunction.makePhoneCall(phone),
                      icon: const Icon(Icons.call),
                      label: const Text("Call"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _chooseDestination(),
                      icon: const Icon(Icons.map),
                      label: const Text("Choose Destination"),
                    ),
                    ElevatedButton.icon(
                      onPressed: (totalPrice == null)
                          ? null
                          : () {
                              Navigator.of(context).pop();
                              requestRideController.requestRide(
                                driverId: driverId,
                                driverName: name,
                                userId: userId,
                                userName: userName,
                                userLat: _userLat!,
                                userLong: _userLong!,
                                destinationLat:
                                    _selectedDestination?.latitude ?? 0.0,
                                destinationLong:
                                    _selectedDestination?.longitude ?? 0.0,
                                totalPrice: totalPrice,
                                selectedDestination: _selectedAddress ?? '',
                              );
                            },
                      icon: const Icon(Icons.send),
                      label: const Text("Request"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (totalPrice == null)
                            ? Colors.grey
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _onRequestPressed({
    required String driverId,
    required String name,
    required String userId,
    required String userName,
    required int totalPrice,
    required RequestRide requestRideController,
    required BuildContext context,
    // ... add any other needed parameters
  }) async {
    if (_bottomSheetController != null) {
      _bottomSheetController!.close();
      _bottomSheetController = null;
    }

    // Call your request ride function
    requestRideController.requestRide(
      driverId: driverId,
      driverName: name,
      userId: userId,
      userName: userName,
      userLat: _userLat!,
      // assuming _userLat is available
      userLong: _userLong!,
      destinationLat: _selectedDestination?.latitude ?? 0.0,
      destinationLong: _selectedDestination?.longitude ?? 0.0,
      totalPrice: totalPrice,
      selectedDestination: _selectedAddress ?? '',
    );

    // Then switch the screen or navigate
    final layoutController = Get.find<MainLayoutController>();
    layoutController.selectedIndex.value = 7; // open UserRequestsScreen
  }

  Future<List<LatLng>> fetchRouteFromORS(LatLng start, LatLng end) async {
    final apiKey =
        'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6ImQ1YzU1Y2Y1ZGM2MDQ0MTdhZDk1NDUwYmYxMGQ0ZWM0IiwiaCI6Im11cm11cjY0In0=';

    final url = Uri.parse(
      "https://api.openrouteservice.org/v2/directions/driving-car"
      "?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final coords = data['features'][0]['geometry']['coordinates'];

        return coords.map<LatLng>((p) => LatLng(p[1], p[0])).toList();
      } else {
        throw Exception("ORS status ${response.statusCode}");
      }
    } catch (e) {
      print("❌ ORS route error: $e");
      return [];
    }
  }

  Future<void> _updateRouteLinesWithORS() async {
    if (_lastDriverLatLng == null ||
        _userLat == null ||
        _userLong == null ||
        _selectedDestination == null) {
      if (!mounted) return;
      setState(() {
        _polylines = [];
      });
      return;
    }

    // _setMockRouteLines();
    final userLatLng = LatLng(_userLat!, _userLong!);

    try {
      final driverToUserRoute = await fetchRouteFromORS(
        _lastDriverLatLng!,
        userLatLng,
      );
      final userToDestRoute = await fetchRouteFromORS(
        userLatLng,
        _selectedDestination!,
      );

      if (!mounted) return;
      setState(() {
        _polylines = [
          Polyline(
            points: driverToUserRoute,
            strokeWidth: 4.5,
            color: Colors.blue,
          ),
          Polyline(
            points: userToDestRoute,
            strokeWidth: 4.5,
            color: Colors.green,
          ),
        ];
      });
    } catch (e) {
      print("ORS route failed: $e");
      Get.snackbar("Route Error", "Could not draw route");
    }
  }

  void _subscribeToDriverLocations() {
    _driversSubscription = FirebaseFirestore.instance
        .collection('drivers')
        .snapshots()
        .listen((snapshot) async {
          final user = FirebaseAuth.instance.currentUser;
          final userId = user?.uid ?? '';
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
          final userName = userDoc.data()?['name'] ?? 'Unknown User';
          final requestRideController = Get.put(RequestRide());

          final userMarker = Marker(
            point: LatLng(_userLat!, _userLong!),
            width: 120,
            height: 60,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "Your Location",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const Icon(
                  Icons.person_pin_circle,
                  color: Colors.red,
                  size: 30,
                ),
              ],
            ),
          );

          final List<Marker> updatedMarkers = snapshot.docs
              .where((doc) => doc.data()['available'] == true)
              .map((doc) {
                final data = doc.data();
                final String driverId = doc.id;
                final double lat = (data['lat'] is double)
                    ? data['lat']
                    : double.tryParse(data['lat'].toString()) ?? 0.0;
                final double long = (data['long'] is double)
                    ? data['long']
                    : double.tryParse(data['long'].toString()) ?? 0.0;
                final String name = data['driver_name'] ?? 'Unknown';
                final String vehicle = data['vehicle_type'] ?? 'Unknown';
                final String phone = data['phone'] ?? 'Unknown';
                final bool available = data['available'] ?? true;

                return Marker(
                  point: LatLng(lat, long),
                  width: 100,
                  height: 80,
                  child: GestureDetector(
                    onTap: () async {
                      // Your existing marker tap logic here...

                      _lastDriverId = driverId;
                      _lastDriverName = name;
                      _lastDriverPhone = phone;
                      _lastVehicle = vehicle;
                      _lastAvailable = available;
                      _lastUserId = userId;
                      _lastUserName = userName;
                      _lastDriverLatLng = LatLng(lat, long);

                      if (_selectedDestination == null) {
                        _showBottomSheetWithDestination(
                          driverId: driverId,
                          name: name,
                          phone: phone,
                          vehicle: vehicle,
                          available: available,
                          userId: userId,
                          userName: userName,
                          driverLatLng: _lastDriverLatLng!,
                          totalPrice: null,
                          context: context,
                          phoneCallFunction: phoneCallFunction,
                          requestRideController: requestRideController,
                        );
                        return;
                      }

                      // Calculate price and update UI same way...

                      final Distance distance = const Distance();

                      final double driverToUser = distance.as(
                        LengthUnit.Kilometer,
                        _lastDriverLatLng!,
                        LatLng(_userLat!, _userLong!),
                      );

                      final double userToDest = distance.as(
                        LengthUnit.Kilometer,
                        LatLng(_userLat!, _userLong!),
                        _selectedDestination!,
                      );

                      final double totalDistance = driverToUser + userToDest;
                      final int totalPrice = (totalDistance * 500).round();

                      final selectedAddress = await getAddressFromLatLng(
                        _selectedDestination!,
                      );

                      if (!mounted)
                        return; // Check mounted to avoid setState after dispose

                      setState(() {
                        _selectedAddress = selectedAddress;
                      });
                      await _updateRouteLinesWithORS();

                      _showModalBottomSheetWithDestination(
                        driverId: driverId,
                        name: name,
                        phone: phone,
                        vehicle: vehicle,
                        available: available,
                        userId: userId,
                        userName: userName,
                        driverLatLng: _lastDriverLatLng!,
                        totalPrice: totalPrice,
                        context: context,
                        phoneCallFunction: phoneCallFunction,
                        requestRideController: requestRideController,
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: Text(
                            vehicle,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.location_on_sharp,
                          color: Color.fromARGB(255, 0, 70, 128),
                          size: 40,
                        ),
                      ],
                    ),
                  ),
                );
              })
              .toList();

          final List<Marker> tempMarkers = [userMarker, ...updatedMarkers];

          if (_selectedDestination != null) {
            final destinationMarker = Marker(
              point: _selectedDestination!,
              width: 140,
              height: 60,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[800],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "Your Destination",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const Icon(Icons.location_on, color: Colors.green, size: 30),
                ],
              ),
            );
            tempMarkers.add(destinationMarker);
          }

          setState(() {
            _markers = tempMarkers;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(initialCenter: LatLng(21.9588, 96.0891)),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.project_one',
          ),
          MarkerLayer(markers: _markers),
          if (_polylines.isNotEmpty &&
              _polylines.any((polyline) => polyline.points.isNotEmpty))
            PolylineLayer(polylines: _polylines),
        ],
      ),
    );
  }
}
