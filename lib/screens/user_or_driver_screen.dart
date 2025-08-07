import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/screens/admin_screen/admin_login.dart';
import 'package:project_one/screens/driver_screen/driver_signUp_screen.dart';
import 'package:project_one/screens/welcome_screen.dart';
import 'package:project_one/widgets/custom_scaffold.dart';

class UserOrDriverScreen extends StatelessWidget {
  const UserOrDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            MainAxisAlignment.start, // aligns children at the top
        children: [
          // Add some top padding for breathing room
          SizedBox(height: 60),

          // Logo
          Center(
            child: Image(
              image: NetworkImage(
                "https://framerusercontent.com/images/r4bqA98NZdxraufAO0IxKjxH6U.png?scale-down-to=512",
              ),
            ),
          ),

          SizedBox(height: 20),

          // Text and buttons container with padding
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Who are you?',
                  style: TextStyle(
                    color: Colors.blueAccent.shade400,
                    fontSize: 45.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),

                SizedBox(height: 40),

                ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => WelcomeScreen());
                  },
                  icon: Icon(Icons.person),
                  label: Text('I am a User'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),

                SizedBox(height: 24),

                ElevatedButton.icon(
                  onPressed: () {
                    Get.to(DriverSignupScreen());
                  },
                  icon: Icon(Icons.drive_eta),
                  label: Text('I am a Driver'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.to(AdminLogin());
                  },
                  icon: Icon(Icons.drive_eta),
                  label: Text('I am a Admin'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
