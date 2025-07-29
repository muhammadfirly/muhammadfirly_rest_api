import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:muhammadfirly_rest_api/model/order_model.dart';
import 'package:muhammadfirly_rest_api/model/product_model.dart';

class OrderController extends GetxController {
  final RxList<Order> _orders = <Order>[].obs;

  List<Order> get orders => _orders.toList();

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void addOrder(Order order) {
    _orders.add(order);
    Get.snackbar(
      'Sukses!',
      'Pesanan Anda telah berhasil dibuat dan disimpan.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((order) => order.orderId == orderId);
    if (index != -1) {
      _orders[index].status = newStatus;
      _orders.refresh();
      Get.snackbar(
        'Status Pesanan Diperbarui',
        'Status pesanan $orderId telah diperbarui menjadi $newStatus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Gagal',
        'Pesanan dengan ID $orderId tidak ditemukan.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void removeOrder(String orderId) {
    final initialLength = _orders.length;
    _orders.removeWhere((order) => order.orderId == orderId);
    if (_orders.length < initialLength) {
      Get.snackbar(
        'Pesanan Dihapus',
        'Pesanan dengan ID $orderId telah dihapus.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Gagal',
        'Pesanan dengan ID $orderId tidak ditemukan.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  List<Order> getOrdersByStatus(String status) {
    return _orders.where((order) => order.status == status).toList();
  }

  Future<void> fetchOrders() async {
    if (_orders.isEmpty) {
      _loadDummyOrders();
    }
  }

  void _loadDummyOrders() {
    final dummyProduct1 = Product(
      id: 1,
      title: 'Carolina Herrera Good Girl',
      description: 'Parfum mewah dengan aroma bunga dan oriental.',
      price: 1500000,
      discountPercentage: 15,
      rating: 4.8,
      stock: 30,
      brand: 'Carolina Herrera',
      category: 'Parfum Wanita',
      thumbnail: 'assets/images/carolinaherrera.png',
      images: 'assets/images/carolinaherrera.png',
    );

    final dummyProduct2 = Product(
      id: 2,
      title: 'Dior Sauvage',
      description: 'Parfum pria dengan aroma segar dan maskulin.',
      price: 1800000,
      discountPercentage: 10,
      rating: 4.7,
      stock: 40,
      brand: 'Dior',
      category: 'Parfum Pria',
      thumbnail: 'assets/images/diorsauvage.png',
      images: 'assets/images/diorsauvage.png',
    );

    final dummyProduct3 = Product(
      id: 3,
      title: 'Chanel No. 5',
      description: 'Parfum klasik legendaris untuk wanita elegan.',
      price: 2000000,
      discountPercentage: 0,
      rating: 4.9,
      stock: 25,
      brand: 'Chanel',
      category: 'Parfum Wanita',
      thumbnail: 'assets/images/chanelno5.png',
      images: 'assets/images/chanelno5.png',
    );

    final dummyProduct4 = Product(
      id: 4,
      title: 'Versace Bright Crystal',
      description: 'Aroma bunga cerah dan feminin.',
      price: 1000000,
      discountPercentage: 20,
      rating: 4.6,
      stock: 60,
      brand: 'Versace',
      category: 'Parfum Wanita',
      thumbnail: 'assets/images/versacebc.png',
      images: 'assets/images/versacebc.png',
    );

    final dummyProduct5 = Product(
      id: 5,
      title: 'Jo Malone Wood Sage & Sea Salt',
      description: 'Aroma woody dan salty yang menyegarkan.',
      price: 1600000,
      discountPercentage: 5,
      rating: 4.7,
      stock: 35,
      brand: 'Jo Malone',
      category: 'Unisex Perfume',
      thumbnail: 'assets/images/jomalone.png',
      images: 'assets/images/jomalone.png',
    );

    _orders.addAll([
      Order(
        orderId: 'ORD-20250726-001',
        product: dummyProduct1,
        quantity: 1,
        shippingAddress: 'Jl. Melati No. 10, Kebayoran Baru, Jakarta Selatan',
        selectedShippingOption: 'Reguler',
        shippingCost: 20000,
        selectedPaymentMethod: 'Bank Transfer',
        totalPayment: 1520000,
        orderDate: DateTime.now().subtract(const Duration(days: 5)),
        status: 'Completed',
      ),
      Order(
        orderId: 'ORD-20250726-002',
        product: dummyProduct2,
        quantity: 2,
        shippingAddress: 'Jl. Cemara No. 5, Dago, Bandung',
        selectedShippingOption: 'Express',
        shippingCost: 35000,
        selectedPaymentMethod: 'Credit Card',
        totalPayment: (1800000 * 2) + 35000,
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        status: 'Pending',
      ),
      Order(
        orderId: 'ORD-20250726-003',
        product: dummyProduct3,
        quantity: 1,
        shippingAddress: 'Jl. Anggrek No. 22, Surabaya Pusat',
        selectedShippingOption: 'Reguler',
        shippingCost: 25000,
        selectedPaymentMethod: 'E-Wallet',
        totalPayment: 2025000,
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        status: 'Processing',
      ),
      Order(
        orderId: 'ORD-20250726-004',
        product: dummyProduct4,
        quantity: 1,
        shippingAddress: 'Perumahan Indah Blok A No. 7, Medan',
        selectedShippingOption: 'Standard',
        shippingCost: 18000,
        selectedPaymentMethod: 'Bank Transfer',
        totalPayment: 1018000,
        orderDate: DateTime.now().subtract(const Duration(hours: 10)),
        status: 'Pending',
      ),
      Order(
        orderId: 'ORD-20250726-005',
        product: dummyProduct5,
        quantity: 3,
        shippingAddress: 'Apartemen Sejahtera Lantai 15, Yogyakarta',
        selectedShippingOption: 'Express',
        shippingCost: 40000,
        selectedPaymentMethod: 'Credit Card',
        totalPayment: (1600000 * 3) + 40000,
        orderDate: DateTime.now().subtract(const Duration(minutes: 30)),
        status: 'Processing',
      ),
    ]);
  }
}