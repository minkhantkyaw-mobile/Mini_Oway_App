import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/viewModels/driver/driver_profile_controller/driverProfile_controller.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  int selectedIndex = -1;
  bool isEditSelected = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriverprofileController());
    return Scaffold(
      backgroundColor: const Color(0XFFFBF5DE),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 35,
            child: Text(
              'Profile',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 8),
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Obx(
                            () => ClipOval(
                          child: controller.imageUrl.value.isNotEmpty
                              ? Image.network(
                            controller.imageUrl.value,
                            width: 100, // same as diameter = 2 * radius
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              );
                            },
                          )
                              : null,
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.black38,
                          radius: 15,
                          child: Icon(Icons.camera_alt, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),

                ///For Driver Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 50),
                    Obx(
                      () => Text(
                        controller.name.value,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Edit Name"),
                            content: TextField(
                              decoration: InputDecoration(
                                hintText: "Enter New name",
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Handle saving logic here
                                  Navigator.pop(context);
                                },
                                child: Text("Save"),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 20,
                        color: isEditSelected ? Colors.red : Colors.black54,
                      ),
                    ),
                  ],
                ),
                Obx(
                      () => ElevatedButton.icon(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                      controller.pickAndUploadImage();
                    },
                    icon: controller.isLoading.value
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Icon(Icons.upload),
                    label: Text(
                      controller.isLoading.value
                          ? "Uploading..."
                          : "Pick & Upload Image",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Obx(() {
                  print("careate At : ${controller.joinedDate.value}");
                  return Column(
                    children: [
                      buildDriverInformationWiget(
                        title: 'Email',
                        backtitile: controller.email.value,
                      ),
                      buildDriverInformationWiget(
                        title: 'Phone Number',
                        backtitile: controller.phoneNumber.value,
                      ),
                      buildDriverInformationWiget(
                        title: 'Joined Date',
                        backtitile: controller.joinedDate.value,
                      ),
                    ],
                  );
                }),

                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [

                      buildDrawerItem(
                        index: 2,
                        icon: Icons.key,
                        title: 'Change Password',
                        trailing: Icon(Icons.arrow_forward_ios, size: 18),
                      ),
                      buildDrawerItem(
                        index: 3,
                        icon: Icons.logout,
                        title: 'Logout',
                        trailing: Icon(Icons.arrow_forward_ios, size: 18),
                      ),
                      buildDrawerItem(
                        index: 4,
                        icon: Icons.delete,
                        title: 'Delete Account',
                        trailing: Icon(Icons.arrow_forward_ios, size: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerItem({
    required int index,
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    final bool isSelected = selectedIndex == index;
    final activeColor = Colors.black;
    bool isDangerAction = title == 'Logout' || title == 'Delete Account';

    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: isSelected ? activeColor.withOpacity(0.15) : Colors.white,
        borderRadius: BorderRadius.circular(isSelected ? 12.0 : 12.0),
        border: Border.all(color: Colors.black, width: 1.0),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: isSelected ? 28 : 20,
          color: isDangerAction ? Colors.red : Colors.black,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
            color: isDangerAction ? Colors.red : Colors.black,
          ),
        ),
        tileColor: isSelected ? activeColor.withOpacity(0.15) : null,
        trailing: trailing,
        focusColor: Colors.transparent,
        onTap: () {
          setState(() {
            selectedIndex = index;
            if (selectedIndex == 1) {
              // Get.to(OwaylistScreen());
            } else if (selectedIndex == 2) {
              // Get.to(HistoryScreen());
            } else if (selectedIndex == 3) {
              // Get.to(LocationScreen());
            } else if (selectedIndex == 4) {
              // Get.to(DocumentScreen());
            } else if (selectedIndex == 5) {
              // Get.to(FavoriteScreen());
            } else if (selectedIndex == 6) {
              // Get.to(SettingScreen());
            } else {
              // Get.to(LogoutScreen());
            }
          });
        },
      ),
    );
  }
}

Widget buildDriverInformationWiget({
  required String title,
  required String backtitile,
}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 15),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        Text(backtitile, style: TextStyle(fontWeight: FontWeight.w500)),
      ],
    ),
  );
}
