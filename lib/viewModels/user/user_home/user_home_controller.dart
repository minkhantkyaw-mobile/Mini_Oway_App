import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class UserHomeController extends GetxController {
  var restaurants = <Map<String, dynamic>>[].obs;
  var pagodas = <Map<String, dynamic>>[].obs;

  var availableDrivers = <Map<String, dynamic>>[].obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observables
  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString phone = ''.obs;
  RxString address = ''.obs;
  RxString imageUrl = ''.obs;

  final Map<String, List<LatLng>> driverRoutes = {
    'driver1': [
      LatLng(21.9588, 96.0891),
      LatLng(21.9603, 96.0918),
      LatLng(21.9620, 96.0950),
      LatLng(21.9610, 96.0935),
    ],
    'driver2': [
      LatLng(21.9300, 96.1200),
      LatLng(21.9330, 96.1225),
      LatLng(21.9350, 96.1240),
      LatLng(21.9370, 96.1255),
    ],
    // Add more drivers later...
  };
  final List<Timer> _timers = [];

  @override
  void onInit() {
    super.onInit();
    print("Thisi s main");
    fetchRestaurants();
    fetchPagodas();
    startSimulatedMovement();
    fetchAvailableDrivers();
    fetchUserProfile();
  }

  @override
  void onClose() {
    for (var timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
    super.onClose();
  }

  Future<void> fetchRestaurants() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('mandalay_restaurant') // ✅ Make sure this is correct
          .get();

      restaurants.value = snapshot.docs.map((doc) => doc.data()).toList();
      print("These are restaurant : ${restaurants.value}");
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch restaurant data');
    }
  }

  Future<void> fetchPagodas() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('mandalay_pagoda_list') // ✅ Make sure this is correct
          .get();

      pagodas.value = snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch restaurant data');
    }
  }

  Future<void> startSimulatedMovement() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('drivers')
        .get();

    for (var doc in snapshot.docs) {
      final driverId = doc.id;
      final name = doc['driver_name'];

      List<LatLng> route;
      if (name == 'kk') {
        route = [
          LatLng(21.9588, 96.0891),
          LatLng(21.9603, 96.0918),
          LatLng(21.9620, 96.0950),
          LatLng(21.9610, 96.0935),
        ];
      } else if (name == 'U Hla') {
        route = [
          LatLng(22.0261, 96.1095),
          LatLng(21.9806252, 96.1066436),
          LatLng(21.95451, 96.09329),
          LatLng(21.9599, 96.0954),
        ];
      } else if (name == 'U Mya') {
        route = [
          LatLng(21.9562, 96.0823), // Zay Cho Market center
          LatLng(21.9546, 96.0847), // Man Myanmar Plaza (near Zay Cho)
          LatLng(21.9581, 96.0875), // Diamond Plaza Mandalay
          LatLng(21.9552, 96.0801), // Clock Tower (next to market)
        ];
      } else {
        route = [
          LatLng(21.9300, 96.1200),
          LatLng(21.9330, 96.1225),
          LatLng(21.9350, 96.1240),
          LatLng(21.9370, 96.1255),
        ];
      }

      int index = 0;
      Timer timer = Timer.periodic(Duration(seconds: 60), (_) {
        final nextLocation = route[index];
        FirebaseFirestore.instance.collection('drivers').doc(driverId).update({
          'lat': nextLocation.latitude.toString(),
          'long': nextLocation.longitude.toString(),
        });

        index = (index + 1) % route.length;
      });
      _timers.add(timer);
    }
  }

  void fetchAvailableDrivers() {
    FirebaseFirestore.instance
        .collection('drivers')
        .where('available', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
          availableDrivers.value = snapshot.docs
              .map((doc) => doc.data())
              .toList();
        });
  }

  void fetchUserProfile() async {
    final currentUser = _auth.currentUser;
    print("This is The Loggined User : $currentUser");
    if (currentUser == null) {
      Get.snackbar("Error", "No user logged in");
      return;
    }

    try {
      final doc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (doc.exists) {
        final data = doc.data();
        name.value = data?['name'] ?? '';
        email.value = data?['email'] ?? currentUser.email ?? '';
        phone.value = data?['phone'] ?? '';
        address.value = data?['address'] ?? '';
        imageUrl.value = data?['imageUrl'] ?? '';
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user data");
      print("Firestore error: $e");
    }
  }
}
