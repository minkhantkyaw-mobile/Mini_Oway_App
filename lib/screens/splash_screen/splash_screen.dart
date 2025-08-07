import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/screens/user_or_driver_screen.dart';
import 'package:project_one/widgets/custom_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Wait for 1 second then navigate
    Future.delayed(const Duration(milliseconds: 2000), () {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (_) => ChooseuserAdminScreen()),
      // );
      Get.off(UserOrDriverScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 60),

          // Logo
          Center(
            child: Image.network(
              "https://framerusercontent.com/images/r4bqA98NZdxraufAO0IxKjxH6U.png?scale-down-to=512",
            ),
          ),

          const SizedBox(height: 200),

          const Center(child: CircularProgressIndicator(color: Colors.white)),
        ],
      ),
    );
  }
}
