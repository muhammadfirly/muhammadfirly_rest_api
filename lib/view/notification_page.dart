import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muhammadfirly_rest_api/controller/voucher_controller.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});

  final VoucherController voucherController = Get.find<VoucherController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              voucherController.clearNotifications();
              Get.snackbar(
                'Notifikasi',
                'Semua notifikasi dibersihkan.',
                backgroundColor: Colors.black,
                colorText: Colors.white,
              );
            },
            tooltip: 'Bersihkan Semua',
          ),
        ],
      ),
      body: Obx(() {
        if (voucherController.notifications.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada notifikasi baru.',
              style: TextStyle(color: Colors.black54),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: voucherController.notifications.length,
          itemBuilder: (context, index) {
            final notification = voucherController.notifications[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8.0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(Icons.notifications, color: Colors.black87),
                title: Text(
                  notification,
                  style: const TextStyle(color: Colors.black87),
                ),
                subtitle: Text(
                  'Baru saja - ${DateTime.now().hour}:${DateTime.now().minute}',
                  style: const TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  Get.snackbar(
                    'Detail Notifikasi',
                    notification,
                    backgroundColor: Colors.black,
                    colorText: Colors.white,
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}