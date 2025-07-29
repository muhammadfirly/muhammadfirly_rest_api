import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:muhammadfirly_rest_api/controller/user_controller.dart';
import 'package:muhammadfirly_rest_api/controller/product_controller.dart';
import 'package:muhammadfirly_rest_api/controller/order_controller.dart';
import 'package:muhammadfirly_rest_api/model/user_model.dart';
import 'package:muhammadfirly_rest_api/model/order_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final ProductController productController = Get.find<ProductController>();
    final OrderController orderController = Get.find<OrderController>();

    userController.fetchCurrentUserProfile();
    orderController.fetchOrders();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              userController.fetchCurrentUserProfile();
              orderController.fetchOrders();
            },
            tooltip: 'Refresh Profil',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.defaultDialog(
                title: "Logout",
                middleText: "Anda yakin ingin keluar?",
                textConfirm: "Ya",
                textCancel: "Tidak",
                confirmTextColor: Colors.white,
                cancelTextColor: Colors.black,
                buttonColor: Colors.black87,
                onConfirm: () {
                  Get.back();
                  productController.logout();
                },
                onCancel: () {},
              );
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Obx(() {
        final User? user = userController.currentUser.value;
        final bool isLoadingUser = userController.isLoading.value;
        final String errorMessageUser = userController.errorMessage.value;

        if (isLoadingUser) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        }

        if (errorMessageUser.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text(
                    'Error memuat profil: $errorMessageUser',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => userController.fetchCurrentUserProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        if (user == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Gagal memuat data profil. Pastikan Anda sudah login.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Login Ulang'),
                  ),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    user.photoUrl != null && user.photoUrl!.isNotEmpty
                        ? CachedNetworkImageProvider(user.photoUrl!)
                        : null,
                child:
                    user.photoUrl == null || user.photoUrl!.isEmpty
                        ? Icon(Icons.person, size: 60, color: Colors.grey[700])
                        : null,
              ),
              const SizedBox(height: 20),
              Text(
                user.name,
                style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.email,
                style: Get.textTheme.titleMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 30),
              _buildProfileInfoCard(
                icon: Icons.email,
                title: 'Email',
                value: user.email,
              ),
              const SizedBox(height: 10),
              _buildProfileInfoCard(
                icon: Icons.lock,
                title: 'Password',
                value: '********',
                onTap: () {
                  Get.snackbar(
                    'Fitur Belum Tersedia',
                    'Fitur ubah password belum diimplementasikan.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black87,
                    colorText: Colors.white,
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildProfileInfoCard(
                icon: Icons.location_on,
                title: 'Alamat',
                value: user.address ?? 'Belum diatur',
                onTap: () {
                  Get.snackbar(
                    'Fitur Belum Tersedia',
                    'Fitur ubah alamat belum diimplementasikan.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black87,
                    colorText: Colors.white,
                  );
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  Get.snackbar(
                    'Fitur Belum Tersedia',
                    'Fitur edit profil belum diimplementasikan.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black87,
                    colorText: Colors.white,
                  );
                },
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text(
                  'Edit Profil',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Pesanan Anda:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              Obx(() {
                if (orderController.orders.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Anda belum memiliki pesanan.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orderController.orders.length,
                    itemBuilder: (context, index) {
                      Order order = orderController.orders[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ID Pesanan: ${order.orderId}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (order.product.thumbnail != null &&
                                      order.product.thumbnail!.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: CachedNetworkImage(
                                        // Menggunakan CachedNetworkImage
                                        imageUrl: order.product.thumbnail!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => const Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                        errorWidget:
                                            (context, url, error) => const Icon(
                                              Icons.image_not_supported,
                                              size: 80,
                                              color: Colors.grey,
                                            ),
                                      ),
                                    ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order.product.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Kuantitas: ${order.quantity}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        Text(
                                          'Harga per item: Rp${order.product.price.toStringAsFixed(0)}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Total Pembayaran: Rp${order.totalPayment.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Status: ${order.status}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          order.status == 'Completed'
                                              ? Colors.green
                                              : (order.status == 'Pending'
                                                  ? Colors.orange
                                                  : Colors.red),
                                    ),
                                  ),
                                  Text(
                                    'Tanggal Pesanan: ${order.orderDate.toLocal().toString().split(' ')[0]}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileInfoCard({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
        trailing: onTap != null ? const Icon(Icons.arrow_forward_ios) : null,
        onTap: onTap,
      ),
    );
  }
}