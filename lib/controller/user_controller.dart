import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muhammadfirly_rest_api/model/user_model.dart';
import 'package:muhammadfirly_rest_api/model/product_model.dart';
import 'package:muhammadfirly_rest_api/services/api_service.dart';
import 'package:muhammadfirly_rest_api/utils/shared_prefs.dart';
import 'package:muhammadfirly_rest_api/controller/product_controller.dart';

class UserController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  var currentUser = Rx<User?>(null);
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var orderedProducts = <Product>[].obs;

  @override
  void onInit() {
    print('UserController onInit: Memulai inisialisasi...');
    _loadInitialUserData();
    fetchCurrentUserProfile();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print(
        'UserController addPostFrameCallback: Memanggil fetchOrderedProducts...',
      );
      fetchOrderedProducts();
    });
    super.onInit();
  }

  Future<void> _loadInitialUserData() async {
    print('UserController: Memuat data user awal dari SharedPrefs...');
    final userData = await SharedPrefs.getUserData();
    if (userData != null) {
      currentUser.value = User.fromJson(userData);
      print(
        'UserController: Data user awal dimuat: ${currentUser.value?.name}',
      );
    } else {
      print('UserController: Tidak ada data user awal di SharedPrefs.');
    }
  }

  Future<void> fetchCurrentUserProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    print('UserController: Memulai fetchCurrentUserProfile...');
    try {
      final user = await _apiService.fetchUserProfile();
      currentUser.value = user;
      print('UserController: Profil user berhasil dimuat: ${user?.name}');
    } catch (e) {
      print('Error fetching user profile: $e');
      errorMessage.value =
          'Gagal memuat profil: ${e.toString().split(':').last.trim()}';
      if (!e.toString().contains('No authentication token found')) {
        Get.snackbar(
          'Error',
          'Gagal memuat profil pengguna: ${e.toString().split(':').last.trim()}',
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      currentUser.value = null;
    } finally {
      isLoading.value = false;
      print(
        'UserController: fetchCurrentUserProfile selesai. isLoading: ${isLoading.value}',
      );
    }
  }

  Future<void> fetchOrderedProducts() async {
    print('UserController: Memulai fetchOrderedProducts...');
    try {
      final productController = Get.find<ProductController>();
      print(
        'UserController: ProductController ditemukan. Jumlah produk utama: ${productController.products.length}',
      );

      if (productController.products.isNotEmpty) {
        orderedProducts.value = [
          productController.products[0],
          if (productController.products.length > 1)
            productController.products[1],
        ];
        print(
          'UserController: orderedProducts diisi dari productController.products. Jumlah: ${orderedProducts.length}',
        );
      } else {
        print(
          'UserController: productController.products kosong. Menggunakan data mock hardcoded.',
        );
        orderedProducts.value = [
          Product(
            id: 99,
            title: 'Parfum Pesanan A (Mock)',
            description: 'Deskripsi singkat parfum pesanan A.',
            price: 75.0,
            discountPercentage: 0,
            rating: 4.0,
            stock: 1,
            brand: 'Brand X',
            category: 'Eau de Parfum',
            thumbnail:
                'https://placehold.co/600x400/000000/FFFFFF?text=Pesanan+A',
            images: 'https://placehold.co/600x400/000000/FFFFFF?text=Pesanan+A',
          ),
          Product(
            id: 100,
            title: 'Parfum Pesanan B (Mock)',
            description: 'Deskripsi singkat parfum pesanan B.',
            price: 110.0,
            discountPercentage: 5,
            rating: 4.5,
            stock: 1,
            brand: 'Brand Y',
            category: 'Eau de Toilette',
            thumbnail:
                'https://placehold.co/600x400/000000/FFFFFF?text=Pesanan+B',
            images: 'https://placehold.co/600x400/000000/FFFFFF?text=Pesanan+B',
          ),
        ];
        print(
          'UserController: orderedProducts diisi dengan data mock hardcoded. Jumlah: ${orderedProducts.length}',
        );
      }
    } catch (e) {
      print('Error fetching ordered products (mock): $e');
      orderedProducts.value = [];
      Get.snackbar(
        'Error',
        'Gagal memuat daftar pesanan: ${e.toString().split(':').last.trim()}',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    print(
      'UserController: fetchOrderedProducts selesai. Jumlah orderedProducts: ${orderedProducts.length}',
    );
  }
}