import 'package:cloud_firestore/cloud_firestore.dart';

class DriverPaymentStatusUpdater {
  static Future<void> updateExpiredDrivers() async {
    final now = DateTime.now();
    final drivers = await FirebaseFirestore.instance
        .collection('drivers')
        .get();

    for (var doc in drivers.docs) {
      final data = doc.data();
      final nextDue = (data['nextDueDate'] as Timestamp?)?.toDate();

      if (nextDue != null && nextDue.isBefore(now)) {
        await doc.reference.update({'paid': 'unpaid', 'isActive': false});
        print("${data['driver_name']} set to unpaid");
      }
    }
  }
}
