import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/viewModels/user/user_receipt_controller/user_receipt_controller.dart';
import 'package:screenshot/screenshot.dart';

class UserReceiptScreen extends StatelessWidget {
  final String driverName;
  final String driverId;
  final String pickUpAddress;
  final String destAddress;
  final String tripPrice;

  UserReceiptScreen({
    super.key,
    required this.driverName,
    required this.driverId,
    required this.pickUpAddress,
    required this.destAddress,
    required this.tripPrice,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserReceiptController());
    controller.getDriverInfo(driverId); // fetch once on screen open

    return Scaffold(
      backgroundColor: const Color(0XFFFBF5DE),
      appBar: AppBar(
        backgroundColor: const Color(0XFFFBF5DE),
        elevation: 0,
        centerTitle: true,
        title: const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Thank you ',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              TextSpan(
                text: 'for visiting with us!',
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Obx(() {
            return SingleChildScrollView(
              child: Screenshot(
                controller: controller.screenshotController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionDivider("Information"),
                    const SizedBox(height: 12),

                    _buildKeyValueRow("Your Name :", controller.name.value),
                    const SizedBox(height: 8),
                    _buildKeyValueRow("Phone Number :", controller.phone.value),
                    const SizedBox(height: 8),
                    _buildKeyValueRow("Email :", controller.email.value),

                    const SizedBox(height: 24),
                    _buildSectionDivider("Location"),
                    const SizedBox(height: 12),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                          children: [
                            const TextSpan(text: 'Fees :'),
                            TextSpan(text: ' $tripPrice MMK'),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    _buildDottedAddress(
                      context,
                      Icons.location_on,
                      Colors.red,
                      pickUpAddress,
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Icon(
                        Icons.swap_vert,
                        size: 30,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildDottedAddress(
                      context,
                      Icons.location_on,
                      Colors.red,
                      destAddress,
                    ),

                    const SizedBox(height: 24),
                    _buildSectionDivider("Driver"),
                    const SizedBox(height: 16),

                    DottedBorder(
                      color: Colors.black,
                      strokeWidth: 2,
                      dashPattern: const [6, 6],
                      radius: const Radius.circular(6),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    driverName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    controller.driverPhone.value,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          controller.driverLocation.value,
                                          style: const TextStyle(fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ClipOval(
                              child: Image.network(
                                controller.driverImage.value,
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 70,
                                    width: 70,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        _buildActionButton(
                          context,
                          icon: Icons.check_circle,
                          iconColor: Colors.green,
                          text: "Save Receipt To Storage",
                          textColor: Colors.green,
                          onTap: () {
                            // Trigger download like this:
                            controller.downloadFile(
                              "https://example.com/receipt.pdf",
                              "receipt.pdf",
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSectionDivider(String title) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.grey, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Colors.grey, thickness: 1)),
      ],
    );
  }

  Widget _buildKeyValueRow(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(key, style: const TextStyle(fontSize: 16)),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildDottedAddress(
    BuildContext context,
    IconData icon,
    Color iconColor,
    String address,
  ) {
    return DottedBorder(
      color: Colors.black,
      strokeWidth: 2,
      dashPattern: const [6, 6],
      radius: const Radius.circular(6),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                address,
                maxLines: 3,
                style: const TextStyle(fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String text,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: textColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: textColor, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
