// driver_payment_history_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminDriverHistoryScreen extends StatelessWidget {
  final String driverId;

  const AdminDriverHistoryScreen({super.key, required this.driverId});

  @override
  Widget build(BuildContext context) {
    print("This is driverID : $driverId");
    return Scaffold(
      appBar: AppBar(title: const Text("Payment History")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('driverpaymenthistory')
            .where('driverId', isEqualTo: driverId)
            .orderBy('paidAtDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          print("This is docs : $docs");
          if (docs.isEmpty) {
            return const Center(child: Text("No payment history found."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final paidAt = (data['paidAtDate'] as Timestamp).toDate();
              final formattedDate = DateFormat(
                'yyyy-MM-dd HH:mm',
              ).format(paidAt);

              return ListTile(
                leading: const Icon(Icons.payments),
                title: Text("MMK ${data['amount']} - ${data['method']}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date: $formattedDate"),
                    Text("Note: ${data['note']}"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
