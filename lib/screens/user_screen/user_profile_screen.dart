import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/viewModels/user/user_delete_controller/user_delete_controller.dart';
import 'package:project_one/viewModels/user/user_loggout_controller/user_loggout_controller.dart';
import 'package:project_one/viewModels/user/user_profile_controller/user_profile_controller.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController nameEditController = TextEditingController();
  int selectedIndex = -1;
  bool isEditSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    Get.put(UserDeleteController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserProfileController());
    return Scaffold(
      backgroundColor: const Color(0XFFFBF5DE),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
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
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 50),
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
                          nameEditController.text = controller
                              .name
                              .value; // Pre-fill with current name

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Edit Name"),
                              content: TextField(
                                controller: nameEditController,
                                decoration: const InputDecoration(
                                  hintText: "Enter new name",
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final newName = nameEditController.text
                                        .trim();
                                    if (newName.isNotEmpty) {
                                      controller.updateUserName(
                                        newName,
                                      ); // ✅ Call your controller function
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Save"),
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

                  const SizedBox(height: 5),
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
                  const SizedBox(height: 10),
                  // buildDrawerItem(
                  //   index: 0,
                  //   icon: Icons.dark_mode,
                  //   title: 'Dark Mode',
                  //   trailing: Switch(value: false, onChanged: (value) {}),
                  // ),
                  // buildDrawerItem(
                  //   index: 1,
                  //   icon: Icons.flag,
                  //   title: 'Language',
                  //   trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  // ),
                  buildDrawerItem(
                    index: 2,
                    icon: Icons.key,
                    title: 'Change Password',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                  buildDrawerItem(
                    index: 3,
                    icon: Icons.logout,
                    title: 'Logout',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                  buildDrawerItem(
                    index: 4,
                    icon: Icons.delete,
                    title: 'Delete Account',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
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
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: isSelected ? activeColor.withOpacity(0.15) : Colors.white,
        borderRadius: BorderRadius.circular(12.0),
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
        trailing: trailing,
        onTap: () async {
          setState(() {
            selectedIndex = index;
          });

          if (title == 'Logout') {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirm Logout'),
                content: const Text('Are you sure you want to log out?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              Get.find<UserLoggoutController>()
                  .handleLogout(); // 👈 Call your controller's logout method
            }
          }

          if (title == 'Delete Account') {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Account'),
                content: const Text(
                  'Are you sure you want to permanently delete your account? This action cannot be undone.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              print("User Want to delete");
              Get.find<UserDeleteController>().deleteAccount();
            }
          }
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
    padding: const EdgeInsets.symmetric(vertical: 15),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(backtitile, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    ),
  );
}
