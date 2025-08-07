import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/screens/admin_screen/admin_driver_history_screen.dart';

class AdminDriverDetailScreen extends StatefulWidget {
  final Map<String, dynamic> driver;

  const AdminDriverDetailScreen({super.key, required this.driver});

  @override
  State<AdminDriverDetailScreen> createState() =>
      _AdminDriverDetailScreenState();
}

class _AdminDriverDetailScreenState extends State<AdminDriverDetailScreen> {
  late Map<String, dynamic> driver;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    driver = Map<String, dynamic>.from(widget.driver); // Make it mutable
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowExtendButton =
        (driver['paid'] == 'unpaid') ||
        (driver['nextDueDate'] != null &&
            (driver['nextDueDate'] as Timestamp).toDate().isBefore(
              DateTime.now(),
            ));

    return Scaffold(
      appBar: AppBar(title: Text(driver['driver_name'] ?? 'Driver Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Image
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: (driver['driver_image'] ?? '').isNotEmpty
                    ? NetworkImage(driver['driver_image'])
                    : null,
                child: (driver['driver_image'] ?? '').isEmpty
                    ? const Icon(Icons.person, size: 40)
                    : null,
                backgroundColor: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _detailRow("Name", driver['driver_name'] ?? 'N/A'),
                    _detailRow("Email", driver['email'] ?? 'N/A'),
                    _detailRow("Phone", driver['phone'] ?? 'N/A'),
                    _detailRow("Address", driver['address'] ?? 'N/A'),
                    _detailRow("Township", driver['township'] ?? 'N/A'),
                    _detailRow("Vehicle Type", driver['vehicle_type'] ?? 'N/A'),
                    _detailRow("Latitude", driver['lat'] ?? 'N/A'),
                    _detailRow("Longitude", driver['long'] ?? 'N/A'),
                    _detailRow("Payment Status", driver['paid'] ?? 'unknown'),
                    _detailRow(
                      "Active",
                      (driver['isActive'] ?? false).toString(),
                    ),
                    _detailRow(
                      "Available",
                      (driver['available'] ?? false).toString(),
                    ),
                    _detailRow(
                      "Approved",
                      (driver['approved'] ?? false).toString(),
                    ),
                    _detailRow(
                      "Join Date",
                      _formatTimestamp(driver['createdAt']),
                    ),
                    _detailRow("Password", driver['password'] ?? 'N/A'),
                    _detailRow(
                      "Last Paid Date",
                      _formatTimestamp(driver['lastPaidDate']),
                    ),
                    _detailRow(
                      "Next Due Date",
                      _formatTimestamp(driver['nextDueDate']),
                    ),
                  ],
                ),
              ),
            ),

            // // Info Section
            // _detailRow("Name", driver['driver_name'] ?? 'N/A'),
            // _detailRow("Email", driver['email'] ?? 'N/A'),
            // _detailRow("Phone", driver['phone'] ?? 'N/A'),
            // _detailRow("Address", driver['address'] ?? 'N/A'),
            // _detailRow("Township", driver['township'] ?? 'N/A'),
            // _detailRow("Vehicle Type", driver['vehicle_type'] ?? 'N/A'),
            // _detailRow("Latitude", driver['lat'] ?? 'N/A'),
            // _detailRow("Longitude", driver['long'] ?? 'N/A'),
            // _detailRow("Payment Status", driver['paid'] ?? 'unknown'),
            // _detailRow("Active", (driver['isActive'] ?? false).toString()),
            // _detailRow("Available", (driver['available'] ?? false).toString()),
            // _detailRow("Approved", (driver['approved'] ?? false).toString()),
            // _detailRow("Join Date", _formatTimestamp(driver['createdAt'])),
            // _detailRow("Password", driver['password'] ?? 'N/A'),
            // _detailRow(
            //   "Last Paid Date",
            //   _formatTimestamp(driver['lastPaidDate']),
            // ),
            // _detailRow(
            //   "Next Due Date",
            //   _formatTimestamp(driver['nextDueDate']),
            // ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (shouldShowExtendButton)
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.date_range),
                          label: const Text("Extend 1 Month"),
                          onPressed: _extendOneMonth,
                        ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.history),
                  label: const Text("View History"),
                  onPressed: () {
                    // TODO: Navigate to history screen
                    Get.to(
                      () => AdminDriverHistoryScreen(driverId: driver['id']),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _extendOneMonth() async {
    setState(() => isLoading = true);
    try {
      final driverId = driver['id'];
      final driverName = driver['driver_name'];
      final now = DateTime.now();
      final nextDue = DateTime(now.year, now.month + 1, now.day);

      await FirebaseFirestore.instance
          .collection('drivers')
          .doc(driverId)
          .update({
            'paid': 'paid',
            'isActive': true,
            'lastPaidDate': now,
            'nextDueDate': nextDue,
          });

      await FirebaseFirestore.instance.collection('driverpaymenthistory').add({
        'driverId': driverId,
        'driverName': driverName,
        'paidAtDate': now,
        'amount': '30000',
        'method': 'kbzpay',
        'note': 'Admin manually extended',
      });

      // Update local state
      setState(() {
        driver['paid'] = 'paid';
        driver['isActive'] = true;
        driver['lastPaidDate'] = Timestamp.fromDate(now);
        driver['nextDueDate'] = Timestamp.fromDate(nextDue);
      });

      Get.snackbar(
        "Success",
        "Payment extended for 1 month",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to extend: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    try {
      DateTime dt = timestamp.toDate();
      return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}  ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return 'Invalid date';
    }
  }
}
