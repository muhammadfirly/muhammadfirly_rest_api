import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muhammadfirly_rest_api/model/product_model.dart';
import 'package:muhammadfirly_rest_api/services/api_service.dart';
import 'package:muhammadfirly_rest_api/controller/user_controller.dart';

class ProductController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  var products = <Product>[].obs;
  var isLoading = true.obs;
  var searchText = ''.obs;
  var selectedCategory = ''.obs;
  var flashSaleProducts = <Product>[].obs;
  var cartItems = <Product>[].obs;
  var isLoggedIn = false.obs; // Pastikan ini ada

  @override
  void onInit() {
    _apiService.login;
    fetchProducts();
    fetchFlashSaleProducts();
    super.onInit();
  }

  Future<void> login(String email, String password) async {
    try {
      final success = await _apiService.login(email, password);
      isLoggedIn.value = success;
      if (success) {
        Get.find<UserController>().fetchCurrentUserProfile();
      }
    } catch (e) {
      isLoggedIn.value = false;
      Get.snackbar(
        'Login Gagal',
        e.toString().split(':').last.trim(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void logout() async {
    await _apiService.logout();
    isLoggedIn.value = false;
    Get.find<UserController>().currentUser.value = null;
    Get.offAllNamed('/login');
    Get.snackbar(
      'Logout',
      'Anda berhasil logout.',
      backgroundColor: Colors.black,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      final result = await _apiService.fetchProducts(
        query: searchText.value.isEmpty ? null : searchText.value,
        category:
            selectedCategory.value.isEmpty ? null : selectedCategory.value,
      );
      products.value = result;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat produk: ${e.toString().split(':').last.trim()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      print(e);
      products.value = [];
    } finally {
      isLoading(false);
    }
  }

  Future<List<Product>> fetchFlashSaleProducts() async {
    try {
      final result = await _apiService.fetchFlashSaleProducts();
      flashSaleProducts.value = result;
      return result;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat Flash Sale: ${e.toString().split(':').last.trim()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      print(e);
      flashSaleProducts.value = [];
      return [];
    }
  }

  void searchProducts(String query) {
    searchText.value = query;
    fetchProducts();
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    fetchProducts();
  }

  void addToCart(Product product) {
    cartItems.add(product);
    Get.snackbar(
      'Berhasil!',
      '${product.title} ditambahkan ke keranjang.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void removeFromCart(Product product) {
    cartItems.remove(product);
    Get.snackbar(
      'Dihapus',
      '${product.title} dihapus dari keranjang.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}