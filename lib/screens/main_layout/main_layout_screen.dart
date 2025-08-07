import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/screens/document_screen/user_document_screen.dart';
import 'package:project_one/screens/favorite_screen/user_favorite_screen.dart';
import 'package:project_one/screens/home_screen.dart';
import 'package:project_one/screens/location_screen.dart';
import 'package:project_one/screens/oway_list_screen/oway_list_screen.dart';
import 'package:project_one/screens/user_logout_screen/user_logout_screen.dart';
import 'package:project_one/screens/user_requests_screen/user_requests_screen.dart';
import 'package:project_one/screens/user_screen/user_history_screen.dart';
import 'package:project_one/screens/user_screen/user_nav_bar.dart';
import 'package:project_one/screens/user_screen/user_profile_screen.dart';
import 'package:project_one/viewModels/mainLayout_controller/mainLayout_controller.dart';
import 'package:project_one/viewModels/user/user_loggout_controller/user_loggout_controller.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int selectedIndex = 0;
  final userLoggoutController = Get.put(UserLoggoutController());

  Widget _getScreen(int index) {
    if (index == 8) {
      // Just trigger logout (after build) and return an empty container
      Future.microtask(() => userLoggoutController.handleLogout());
      return const SizedBox.shrink(); // returns an invisible widget, nothing shows
    }

    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const OwayListScreen();
      case 2:
        return const UserProfileScreen();
      case 3:
        return const UserHistoryScreen();
      case 4:
        return const LocationScreen();
      case 5:
        return const UserDocumentScreen();
      case 6:
        return  FavoriteDriverScreen();
      case 7:
        return const UserRequestsScreen();
      default:
        return const Center(child: Text('Not found'));
    }
  }

  final layoutController = Get.put(MainLayoutController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => UserNavBar(
        selectedIndex: layoutController.selectedIndex.value,
        onItemSelected: (index) {
          layoutController.selectedIndex.value = index;
        },
        child: _getScreen(layoutController.selectedIndex.value),
      ),
    );
  }
}
