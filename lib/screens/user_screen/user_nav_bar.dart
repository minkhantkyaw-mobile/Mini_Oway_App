import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/viewModels/user/user_home/user_home_controller.dart';
import 'package:project_one/viewModels/user/user_receipt_controller/user_receipt_controller.dart';

class UserNavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final Widget child;

  const UserNavBar({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<UserNavBar> createState() => _UserNavBarState();
}

class _UserNavBarState extends State<UserNavBar> {
  Widget _getTitle(int index) {
    print("THis is imageurl : ${UserReceiptController.imageUrl.value}");
    switch (index) {
      case 0:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Welcome To Mandalay',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Obx(
              () => SizedBox(
                width: 50,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    UserReceiptController.imageUrl.value.isNotEmpty
                        ? UserReceiptController.imageUrl.value
                        : 'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?semt=ais_hybrid&w=740&q=80',
                    // fallback image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        );
      case 1:
        return const Text('Mandalay');
      case 2:
        return const Text('Profile');
      case 3:
        return const Text('History');
      case 4:
        return const Text('Location');
      case 5:
        return const Text('Document');
      case 6:
        return const Text('Favorite');
      case 7:
        return const Text('Request');
      case 8:
        return const Text('Logout');
      default:
        return const Text('Welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserHomeController());

    return Scaffold(
      backgroundColor: Color(0XFFFBF5DE),
      appBar: AppBar(
        backgroundColor: const Color(0XFFFBF5DE),
        elevation: 0,
        title: _getTitle(widget.selectedIndex),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.black, size: 30),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 249, 246, 231),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: const EdgeInsets.symmetric(vertical: 0),
              decoration: const BoxDecoration(color: Color(0XFFFBF5DE)),
              child: Obx(() {
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        controller.imageUrl.value.isNotEmpty
                            ? controller.imageUrl.value
                            : 'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?semt=ais_hybrid&w=740&q=80', // fallback image
                      ),
                    ),
                    Text(
                      '${controller.name.value}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${controller.phone.value}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.location_on,
                          size: 18,
                          color: Colors.red,
                        ),
                        Text(
                          '${controller.address.value}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
            buildDrawerItem(index: 0, icon: Icons.home, title: 'Home'),
            buildDrawerItem(index: 1, icon: Icons.drive_eta, title: 'Oway'),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              child: buildDrawerItem(
                index: 2,
                icon: Icons.person,
                title: 'Profile',
              ),
            ),

            buildDrawerItem(
              index: 3,
              icon: Icons.description,
              title: 'History',
            ),
            buildDrawerItem(
              index: 4,
              icon: Icons.location_on,
              title: 'Location',
            ),
            buildDrawerItem(
              index: 5,
              icon: Icons.edit_document,
              title: 'Document',
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              child: buildDrawerItem(
                index: 6,
                icon: Icons.favorite,
                title: 'Favorite',
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              child: buildDrawerItem(
                index: 7,
                icon: Icons.send,
                title: 'Requests',
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              child: buildDrawerItem(
                index: 8,
                icon: Icons.logout,
                title: 'LogOut',
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(child: widget.child),
    );
  }

  Widget buildDrawerItem({
    required int index,
    required IconData icon,
    required String title,
  }) {
    final isSelected = widget.selectedIndex == index;
    final activeColor = Colors.black; // choose your active color

    return ListTile(
      leading: Icon(
        icon,
        size: isSelected ? 25 : 20,
        color: isSelected ? activeColor : Colors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
          color: isSelected ? activeColor : Colors.black,
        ),
      ),
      tileColor: isSelected ? activeColor.withOpacity(0.15) : null,
      onTap: () {
        widget.onItemSelected(index);
        Navigator.pop(context);
      },
    );
  }
}
