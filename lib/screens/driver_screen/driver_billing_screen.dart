import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/viewModels/phone_call/phone_call_function.dart';

class BillingScreen extends StatelessWidget {
  final String driverId;

  const BillingScreen({required this.driverId, super.key});

  @override
  Widget build(BuildContext context) {
    final phoneCallController = Get.put(PhoneCallFunction());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Billing & Activation"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                  size: 60,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Your Free Trial Has Expired",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  "To continue using the app, please pay the monthly fee below.",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: const [
                    Icon(Icons.attach_money_rounded, color: Colors.green),
                    SizedBox(width: 8),
                    Text("Amount: 30,000 MMK", style: TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Icon(Icons.phone_android, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      "Pay to KPay: 09-123456789",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Get.snackbar(
                        "Note",
                        "Please contact admin after payment.",
                      );
                      phoneCallController.makePhoneCall("09770106551");
                    },
                    label: const Text(
                      "I’ve Paid - Contact Admin",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
