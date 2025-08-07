import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_one/screens/location_screen.dart';

class PickLocationScreen extends StatefulWidget {
  const PickLocationScreen({super.key});

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  LatLng? _picked;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick Location")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(21.9588, 96.0891), // Mandalay
          onTap: (tapPos, latLng) {
            setState(() {
              _picked = latLng;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          if (_picked != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _picked!,
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_on, color: Colors.red),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: _picked != null
          ? FloatingActionButton(
              onPressed: () {
                print("picked Locaiton : $_picked");
                if (Get.isSnackbarOpen) {
                  Get.closeCurrentSnackbar();
                }
                Get.back(result: _picked);
              },
              child: const Icon(Icons.check),
            )
          : null,
    );
  }
}
