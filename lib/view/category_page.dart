import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muhammadfirly_rest_api/controller/product_controller.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({super.key});

  final ProductController productController = Get.find<ProductController>();
  final List<String> categories = [
    'Eau de Parfum',
    'Eau de Toilette',
    'Eau de Cologne',
    'Extrait de Parfume',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kategori Parfum',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(Icons.category, color: Colors.black87),
              title: Text(
                category,
                style: const TextStyle(color: Colors.black87),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black54,
              ),
              onTap: () {
                productController.filterByCategory(category);
                Get.back();
                Get.snackbar(
                  'Filter',
                  'Menampilkan produk kategori: $category',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.black,
                  colorText: Colors.white,
                );
              },
            ),
          );
        },
      ),
    );
  }
}