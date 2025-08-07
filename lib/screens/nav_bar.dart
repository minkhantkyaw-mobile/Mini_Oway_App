import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:project_one/screens/favorite_screen.dart';
import 'package:project_one/screens/home_screen.dart';
import 'package:project_one/screens/location_screen.dart';
import 'package:project_one/screens/taxi_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late final List<Widget> page;
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    page = [HomeScreen(), FavoriteScreen(), TaxiScreen(), LocationScreen()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 186, 211, 255),

        padding: const EdgeInsets.all(10.0),
        child: GNav(
          textStyle: TextStyle(fontWeight: FontWeight.bold),
          color: Colors.white,
          activeColor: Colors.black,
          gap: 6,
          tabBackgroundGradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 176, 210, 238),
              const Color.fromARGB(255, 244, 174, 244),
            ],
          ),
          tabShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 114, 113, 113),
              blurRadius: 7,
            ),
          ],
          padding: EdgeInsetsGeometry.all(12),
          tabs: [
            GButton(icon: Icons.home, text: "Home"),
            GButton(icon: Icons.favorite, text: "Favorite"),
            GButton(icon: Icons.car_repair, text: "Taxi"),
            GButton(icon: Icons.location_on, text: "Location"),
          ],
          onTabChange: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
      body: page[selectedIndex],
    );
  }

  navBarPage(iconName) {
    return Center(child: Icon(iconName, size: 100, color: Colors.black));
  }
}
