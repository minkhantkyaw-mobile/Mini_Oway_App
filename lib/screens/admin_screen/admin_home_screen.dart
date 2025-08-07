import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/screens/admin_screen/driver_list_screen.dart';
import 'package:project_one/screens/admin_screen/user_list_screen.dart';
import 'package:project_one/screens/splash_screen/splash_screen.dart';
import 'package:project_one/widgets/curved_navigation_bar.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int index = 0;

  final List<Widget> screens = [DriverListScreen(), UserListScreen()];

  final List<String> titles = ['Driver List', 'User List', 'Logout'];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.drive_eta, size: 30, color: Colors.black),
          Text(
            "Driver List",
            style: TextStyle(
              fontSize: 9,
              color: Colors.purpleAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 30, color: Colors.black),
          Text(
            "User List",
            style: TextStyle(
              fontSize: 9,
              color: Colors.purpleAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout, size: 30, color: Colors.black),
          Text(
            "Logout",
            style: TextStyle(
              fontSize: 9,
              color: Colors.purpleAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0XFFFBF5DE),
      appBar: AppBar(
        backgroundColor: Color(0XFFFBF5DE),
        title: Text(
          titles[index],
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: screens[index],

      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        index: index,
        items: items,
        onTap: (i) async {
          if (i == 2) {
            // Logout
            final confirm = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Confirm Logout"),
                content: const Text("Are you sure you want to logout?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Logout"),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              await FirebaseAuth.instance.signOut();
              Get.offAll(() => SplashScreen()); // or Navigator.pushReplacement
            }
          } else {
            setState(() => index = i);
          }
        },
        color: const Color(0xFFDFDED6),
        backgroundColor: const Color(0XFFFBF5DE),
      ),
    );
  }
}
