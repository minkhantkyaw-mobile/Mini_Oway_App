import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:project_one/viewModels/mainLayout_controller/mainLayout_controller.dart';

class UserRequestController extends GetxController {
  //For Notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  StreamSubscription<QuerySnapshot>? _requestStream;
  final RxList<Map<String, dynamic>> rideRequests =
      <Map<String, dynamic>>[].obs;

  final RxMap<String, int> countdownMap = <String, int>{}.obs;
  final Map<String, Timer> _countdownTimers = {};

  @override
  void onInit() {
    super.onInit();
    listenToRequests();
    _initNotifications();
  }

  @override
  void onClose() {
    _requestStream?.cancel();
    super.onClose();
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
          Get.find<MainLayoutController>().goToTab(
            7,
          ); // To open UserRequestsScreen
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

  final loggedInUserId = FirebaseAuth.instance.currentUser?.uid;
  //Get Requests from Firebase
  void listenToRequests() {
    if (loggedInUserId == null) {
      print("Driver not logged in.");
      return;
    }
    print("Logined Driver ID : $loggedInUserId");
    _requestStream = FirebaseFirestore.instance
        .collection('requests')
        .where('status', whereIn: ['pending', 'accepted'])
        .where('user_id', isEqualTo: loggedInUserId)
        .snapshots()
        .listen((snapshot) async {
          final now = DateTime.now();

          for (var doc in snapshot.docs) {
            final data = doc.data();
            final requestId = doc.id;
            final status = data['status'] ?? 'pending';

            final timestamp = data['timestamp'] is Timestamp
                ? (data['timestamp'] as Timestamp).toDate()
                : DateTime.tryParse(data['timestamp'] ?? '') ?? now;

            final secondsPassed = now.difference(timestamp).inSeconds;

            final updatedData = Map<String, dynamic>.from(data);
            updatedData['id'] = requestId;
            updatedData['secondsPassed'] = secondsPassed;

            // Reverse geocode
            final userLat = data['user_lat'] ?? '';
            final userLong = data['user_long'] ?? '';
            final destLat = data['destination_lat'] ?? '';
            final destLong = data['destination_long'] ?? '';

            updatedData['pickup_address'] = await getAddressFromLatLng(
              userLat,
              userLong,
            );
            updatedData['destination_address'] = await getAddressFromLatLng(
              destLat,
              destLong,
            );

            final index = rideRequests.indexWhere((r) => r['id'] == requestId);

            if (status == 'accepted') {
              // Stop countdown if any
              stopCountdown(requestId);

              // Add a flag to show acceptance message in UI
              updatedData['isAccepted'] = true;

              // Update or add the request without deleting it
              if (index != -1) {
                rideRequests[index] = updatedData;
              } else {
                rideRequests.add(updatedData);
              }
            } else if (status == 'pending') {
              // Pending requests still expire after 60 seconds
              if (secondsPassed > 60) {
                // Expired pending request — delete it
                await FirebaseFirestore.instance
                    .collection('requests')
                    .doc(requestId)
                    .delete();
                rideRequests.removeWhere((r) => r['id'] == requestId);
                stopCountdown(requestId);

                Get.snackbar(
                  "Expired",
                  "Request timed out and was removed. You can request another driver.",
                );
              } else {
                // Not expired, add or update and start countdown if not started
                updatedData['isAccepted'] = false;

                if (index != -1) {
                  rideRequests[index] = updatedData;
                } else {
                  rideRequests.add(updatedData);
                  _showNotification("New ride request", "Tap to view");
                }

                if (!_countdownTimers.containsKey(requestId)) {
                  startCountdown(requestId);
                }
              }
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

  void startCountdown(String requestId) {
    if (_countdownTimers.containsKey(requestId)) return;

    countdownMap[requestId] = 60;
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

        Get.snackbar(
          "Expired",
          "Request timed out and was removed. You can request another driver.",
        );
      } else {
        countdownMap[requestId] = current - 1;

        /// ✅ Trigger UI update by "touching" rideRequests
        final index = rideRequests.indexWhere((r) => r['id'] == requestId);
        if (index != -1) {
          rideRequests[index] = Map<String, dynamic>.from(rideRequests[index]);
        }
      }
    });
  }

  void stopCountdown(String requestId) {
    if (_countdownTimers.containsKey(requestId)) {
      _countdownTimers[requestId]!.cancel();
      _countdownTimers.remove(requestId);
    }
    countdownMap.remove(requestId);
  }
}
