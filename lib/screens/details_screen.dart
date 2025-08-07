import 'package:flutter/material.dart';
import 'package:project_one/screens/location_screen.dart';

class DetailsScreen extends StatelessWidget {
  final double destinationLat;
  final double destinationLng;
  final String placeName;
  final String? image;
  final String? address;

  const DetailsScreen({
    super.key,
    required this.destinationLat,
    required this.destinationLng,
    required this.placeName,
    this.image,
    this.address,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          onPressed: () {
            if (destinationLng != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LocationScreen(
                    destinationLat: destinationLat,
                    destinationLng: destinationLng,
                  ),
                ),
              );
            } else {
              // Handle missing lat/lng gracefully
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Location data not available')),
              );
            }
          },

          child: const Text(
            "Go",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image != null)
                Stack(
                  children: [
                    Container(
                      height: h / 2,
                      width: w,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(image!),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.arrow_back, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      placeName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (address != null)
                      Text(
                        address!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      "This destination is available for ride booking. Click Go to proceed.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
