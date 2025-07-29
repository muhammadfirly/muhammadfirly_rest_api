import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muhammadfirly_rest_api/controller/voucher_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FreeShippingPage extends StatelessWidget {
  FreeShippingPage({super.key});

  final VoucherController voucherController = Get.put(VoucherController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Voucher & Gratis Ongkir',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (voucherController.availableVouchers.isEmpty &&
            voucherController.claimedVouchers.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada voucher tersedia.',
              style: TextStyle(color: Colors.black54),
            ),
          );
        }
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Voucher Tersedia (${voucherController.availableVouchers.length})',
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            voucherController.availableVouchers.isEmpty
                ? const Center(
                  child: Text(
                    'Tidak ada voucher yang dapat diklaim.',
                    style: TextStyle(color: Colors.black54),
                  ),
                )
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: voucherController.availableVouchers.length,
                  itemBuilder: (context, index) {
                    final voucher = voucherController.availableVouchers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: voucher.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) =>
                                    const CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error),
                          ),
                        ),
                        title: Text(
                          voucher.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              voucher.description,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Berlaku hingga: ${voucher.expiryDate}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed:
                              () => voucherController.claimVoucher(voucher),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: const Text(
                            'Klaim',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            const Divider(
              height: 20,
              thickness: 2,
              indent: 8,
              endIndent: 8,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Voucher Diklaim (${voucherController.claimedVouchers.length})',
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            voucherController.claimedVouchers.isEmpty
                ? const Center(
                  child: Text(
                    'Anda belum mengklaim voucher apa pun.',
                    style: TextStyle(color: Colors.black54),
                  ),
                )
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: voucherController.claimedVouchers.length,
                  itemBuilder: (context, index) {
                    final voucher = voucherController.claimedVouchers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      elevation: 1,
                      color: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: voucher.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) =>
                                    const CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error),
                          ),
                        ),
                        title: Text(
                          voucher.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              voucher.description,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Diklaim!',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                    );
                  },
                ),
          ],
        );
      }),
    );
  }
}