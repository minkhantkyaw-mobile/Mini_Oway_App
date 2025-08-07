import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:project_one/screens/driver_screen/driver_home_screen.dart';

class DriverController extends GetxController {
  //For Notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //For Current Location
  final Rxn<LatLng> currentPosition = Rxn<LatLng>();
  final RxBool available = false.obs;
  final RxInt selectedIndex = 0.obs;
  final RxList<Map<String, dynamic>> rideRequests =
      <Map<String, dynamic>>[].obs;

  StreamSubscription<Position>? _positionStream;
  StreamSubscription<QuerySnapshot>? _requestStream;

  final RxList<LatLng> route = <LatLng>[].obs;
  final Rxn<LatLng> mapCenter = Rxn<LatLng>();
  final Rxn<LatLng> destination = Rxn<LatLng>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxMap<String, int> countdownMap = <String, int>{}.obs;
  final Map<String, Timer> _countdownTimers = {};

  @override
  void onInit() {
    super.onInit();
    listenLocation();
    listenToRequests();
    loadAvailability();
    _initNotifications();
  }

  //Initialize Notis
  void _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload == 'ride_request') {
          // Navigate when user taps the notification
          Get.to(() => DriverHomeScreen()); // Replace with your request screen
        }
      },
    );
  }

  //For Noti to Show
  void _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'ride_request_channel',
          'Ride Requests',
          channelDescription: 'Notifications for new ride requests',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // notification id
      title,
      body,
      platformChannelSpecifics,
      payload: 'ride_request', // optional payload
    );
  }

  @override
  void onClose() {
    _positionStream?.cancel();
    _requestStream?.cancel();
    super.onClose();
  }

  //For Driver Location
  void listenLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Location Service', 'Please enable location services');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        Get.snackbar('Permission', 'Location permission denied');
        return;
      }
    }

    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        ).listen((Position position) {
          // currentPosition.value = LatLng(position.latitude, position.longitude);
          currentPosition.value = LatLng(21.9588, 96.0891);
        });
  }

  final loggedInDriverId = FirebaseAuth.instance.currentUser?.uid;

  //Get Requests from Firebase
  void listenToRequests() {
    if (loggedInDriverId == null) {
      print("Driver not logged in.");
      return;
    }
    print("Logined Driver ID : $loggedInDriverId");
    _requestStream = FirebaseFirestore.instance
        .collection('requests')
        .where('status', isEqualTo: 'pending')
        .where('driver_id', isEqualTo: loggedInDriverId)
        .snapshots()
        .listen((snapshot) {
          final now = DateTime.now();

          for (var doc in snapshot.docs) {
            final data = doc.data();
            final requestId = doc.id;

            final timestamp = data['timestamp'] is Timestamp
                ? (data['timestamp'] as Timestamp).toDate()
                : DateTime.tryParse(data['timestamp'] ?? '') ?? now;

            final updatedData = Map<String, dynamic>.from(data);
            updatedData['id'] = requestId;
            updatedData['secondsPassed'] = now.difference(timestamp).inSeconds;

            final secondsPassed = now.difference(timestamp).inSeconds;

            // ✅ Ignore and delete expired requests
            if (secondsPassed > 60) {
              FirebaseFirestore.instance
                  .collection('requests')
                  .doc(requestId)
                  .delete();
              continue;
            }

            // Reverse geocode user_lat/long and destination_lat/long
            final userLat = data['user_lat'] ?? '';
            final userLong = data['user_long'] ?? '';
            final destLat = data['destination_lat'] ?? '';
            final destLong = data['destination_long'] ?? '';

            updatedData['pickup_address'] = getAddressFromLatLng(
              userLat,
              userLong,
            );
            updatedData['destination_address'] = getAddressFromLatLng(
              destLat,
              destLong,
            );

            final index = rideRequests.indexWhere((r) => r['id'] == requestId);
            if (index != -1) {
              rideRequests[index] = updatedData;
            } else {
              rideRequests.add(updatedData);
              _showNotification("New ride request", "Tap to view");
              startCountdown(requestId); // Will auto-expire after 60s
            }
          }
        });
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

  void toggleAvailable(bool value) async {
    try {
      available.value = value;

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      await FirebaseFirestore.instance.collection('drivers').doc(uid).update({
        'available': value,
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update availability',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error updating availability: $e');
    }
  }

  // Load the available value from firestore
  Future<void> loadAvailability() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('drivers')
        .doc(uid)
        .get();
    if (doc.exists && doc.data()!.containsKey('available')) {
      available.value = doc['available'];
    }
  }

  //For Driver to Accept Requests
  void acceptRequest(String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .update({'status': 'accepted'});

      // Optionally update local state
      final index = rideRequests.indexWhere((r) => r['id'] == requestId);
      if (index != -1) {
        rideRequests[index]['status'] = 'accepted';
        rideRequests.refresh();
      }

      stopCountdown(requestId); // Stop countdown

      Get.snackbar("Accepted", "You have accepted the request");
    } catch (e) {
      Get.snackbar("Error", "Failed to accept request: $e");
    }
  }

  // For Driver to Reject The Requests
  void rejectRequest(String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .delete();
      // Remove from the list
      rideRequests.removeWhere((req) => req['id'] == requestId);

      Get.snackbar(
        'Request Rejected',
        'The request is rejected',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to reject request',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error rejecting request: $e');
    }
  }

  void drawRouteToPickup(double lat, double lng) {
    print("Draw Route");
    if (currentPosition.value == null) return;

    mapCenter.value = currentPosition.value;
    destination.value = LatLng(lat, lng);
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    if (mapCenter.value == null || destination.value == null) return;

    final start = mapCenter.value!;
    final end = destination.value!;
    final apiKey =
        'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6ImQ1YzU1Y2Y1ZGM2MDQ0MTdhZDk1NDUwYmYxMGQ0ZWM0IiwiaCI6Im11cm11cjY0In0='; // Replace with your actual ORS API key

    final url = Uri.parse(
      "https://api.openrouteservice.org/v2/directions/driving-car"
      "?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final coords = data['features'][0]['geometry']['coordinates'];

        final points = coords.map<LatLng>((p) => LatLng(p[1], p[0])).toList();
        route.assignAll(points);
      } else {
        Get.snackbar(
          "Route Error",
          "Failed with status ${response.statusCode}",
        );
      }
    } catch (e) {
      Get.snackbar("Route Error", "Exception: $e");
    }
  }

  void startCountdown(String requestId) {
    if (_countdownTimers.containsKey(requestId)) return;

    countdownMap[requestId] = 100;
    _countdownTimers[requestId] = Timer.periodic(const Duration(seconds: 1), (
      timer,
    ) async {
      final current = countdownMap[requestId] ?? 0;

      if (current <= 1) {
        timer.cancel();
        _countdownTimers.remove(requestId);
        countdownMap.remove(requestId);

        await FirebaseFirestore.instance
            .collection('requests')
            .doc(requestId)
            .delete();
        rideRequests.removeWhere((r) => r['id'] == requestId);

        Get.snackbar("Expired", "Request timed out and was removed");
      } else {
        countdownMap[requestId] = current - 1;
      }
    });
  }

  void stopCountdown(String requestId) {
    _countdownTimers[requestId]?.cancel();
    _countdownTimers.remove(requestId);
    countdownMap.remove(requestId);
  }

  void sendPushNotificationToDriver(String driverId, String message) {
    // To be implemented with FCM later
  }

  void changeNavIndex(int index) => selectedIndex.value = index;

  void logout() {
    FirebaseAuth.instance.signOut();
    Get.snackbar('Logout', 'Logged out');
  }
}
