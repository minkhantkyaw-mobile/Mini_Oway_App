import 'package:flutter/material.dart';
import 'package:project_one/screens/nav_bar.dart';

class CustomScaffold extends StatelessWidget {
  final Widget? child;
  const CustomScaffold({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.7), // Adjust opacity as needed
              BlendMode.modulate, // or overlay, multiply, etc.
            ),
            child: Image.asset(
              'assets/images/OwayBackground.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          SafeArea(child: child!),
        ],
      ),
      // bottomNavigationBar: Bottomnavbar(),
    );
  }
}
