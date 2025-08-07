import 'package:flutter/material.dart';
import 'package:project_one/screens/driver_screen/driver_home_screen.dart';
import 'package:project_one/screens/driver_screen/driver_profile_screen.dart';
import 'package:project_one/widgets/curved_navigation_bar.dart';

class DriverNavBar extends StatefulWidget {
  const DriverNavBar({super.key});

  @override
  State<DriverNavBar> createState() => _DriverNavBarState();
}

class _DriverNavBarState extends State<DriverNavBar> {
  int index = 0;
  final List<Widget> screens = [DriverHomeScreen(), DriverProfileScreen()];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, size: 30, color: Colors.black),
          Text(
            "Home",
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
            "Profile",
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
      backgroundColor: Color(0XFFFBF5DE),

      body: screens[index],

      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        index: index,
        items: items,
        onTap: (index) => setState(() {
          this.index = index;
        }),
        // (i) => setState(() => index = i),
        color: const Color(0xFFDFDED6),
        backgroundColor: Color(0XFFFBF5DE),
      ),
    );
  }
}
