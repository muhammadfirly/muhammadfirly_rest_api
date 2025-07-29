import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhammadfirly_rest_api/controller/product_controller.dart';
import 'package:muhammadfirly_rest_api/controller/user_controller.dart';
import 'package:muhammadfirly_rest_api/controller/voucher_controller.dart';
import 'package:muhammadfirly_rest_api/model/product_model.dart';
import 'package:muhammadfirly_rest_api/view/category_page.dart';
import 'package:muhammadfirly_rest_api/view/feed_page.dart';
import 'package:muhammadfirly_rest_api/view/flash_sale_page.dart';
import 'package:muhammadfirly_rest_api/view/free_shipping_page.dart';
import 'package:muhammadfirly_rest_api/view/notification_page.dart';
import 'package:muhammadfirly_rest_api/view/product_detail_bottom_sheet.dart';
import 'package:muhammadfirly_rest_api/view/profile_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductController productController = Get.find<ProductController>();
  final UserController userController = Get.find<UserController>();
  final VoucherController voucherController = Get.find<VoucherController>();
  late TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController(
      text: productController.searchText.value,
    );

    productController.searchText.listen((value) {
      if (_searchController.text != value) {
        _searchController.text = value;
      }
    });


    if (productController.products.isEmpty &&
        !productController.isLoading.value) {
      productController.fetchProducts();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (productController == null || productController.products == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.black),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Obx(() {
        if (productController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        }

        final displayedProducts = productController.products;

        if (displayedProducts.isEmpty) {
          final bool hasActiveFilterOrSearch =
              productController.searchText.value.isNotEmpty ||
              productController.selectedCategory.value.isNotEmpty;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  hasActiveFilterOrSearch
                      ? 'Tidak ada produk yang ditemukan dengan kriteria ini.'
                      : 'Tidak ada produk yang tersedia.',
                  style: const TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    productController.fetchProducts();
                    productController.searchProducts('');
                    productController.filterByCategory(
                      '',
                    );
                    _searchController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    hasActiveFilterOrSearch
                        ? 'Tampilkan Semua Produk'
                        : 'Coba Muat Ulang',
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            productController.fetchProducts();
            productController.searchProducts('');
            productController.filterByCategory('');
            _searchController
                .clear();
          },
          color: Colors.black,
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.7,
            ),
            itemCount: displayedProducts.length,
            itemBuilder: (context, index) {
              final product = displayedProducts[index];
              return _ProductCard(product: product);
            },
          ),
        );
      }),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.snackbar(
            'Fitur',
            'Tombol tambah ditekan! (Untuk tambah produk baru / aksi utama)',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black,
            colorText: Colors.white,
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ), //
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black87,
      elevation: 0,
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            productController.searchText.value = value;
            productController.searchProducts(
              value,
            );
          },
          onSubmitted: (value) {
            productController.searchProducts(value);
            Get.focusScope?.unfocus(); // Tutup keyboard
          },
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Cari parfum di sini...',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
            suffixIcon: Obx(
              () =>
                  productController.searchText.value.isNotEmpty
                      ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: () {
                          productController.searchProducts(
                            '',
                          );
                          _searchController.clear();
                          Get.focusScope?.unfocus();
                        },
                      )
                      : const SizedBox.shrink(),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 8.0,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
          onPressed: () {
            Get.snackbar(
              'Chat',
              'Fitur chat belum diimplementasikan',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.black,
              colorText: Colors.white,
            );
          },
        ),
        IconButton(
          icon: Obx(
            () => Badge(
              label: Text(
                productController.cartItems.length.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              isLabelVisible: productController.cartItems.isNotEmpty,
              backgroundColor: Colors.black,
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
            ),
          ),
          onPressed: () {
            Get.bottomSheet(
              _CartBottomSheet(
                cartItems: productController.cartItems,
                onRemove: productController.removeFromCart,
              ),
              isScrollControlled: true,
              backgroundColor:
                  Colors.transparent,
            );
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(
          50.0,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAppBarCategoryButton(Icons.category, 'Kategori', () {
                Get.to(() => CategoryPage());
              }),
              _buildAppBarCategoryButton(
                Icons.local_shipping,
                'Gratis Ongkir',
                () {
                  Get.to(() => FreeShippingPage());
                },
              ),
              _buildAppBarCategoryButton(Icons.flash_on, 'Flash Sale', () {
                Get.to(() => FlashSalePage());
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarCategoryButton(
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black87,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels:
          true,
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        const BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feed'),
        BottomNavigationBarItem(
          icon: Obx(
            () => Badge(
              label: Text(
                voucherController.notifications.length.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              isLabelVisible: voucherController.notifications.isNotEmpty,
              backgroundColor: Colors.black,
              child: const Icon(Icons.notifications),
            ),
          ),
          label: 'Notifikasi',
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Saya'),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            productController.searchProducts('');
            productController.filterByCategory('');
            _searchController.clear();
            Get.snackbar(
              'Navigasi',
              'Anda di halaman Beranda',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.black,
              colorText: Colors.white,
            );
            break;
          case 1:
            Get.to(() => FeedPage());
            break;
          case 2:
            Get.to(() => NotificationPage());
            break;
          case 3:
            Get.to(() => ProfilePage());
            break;
        }
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Get.bottomSheet(
            ProductDetailBottomSheet(product: product),
            isScrollControlled: true,
            backgroundColor:
                Colors.transparent,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child:
                  product.thumbnail.toLowerCase().endsWith('.svg')
                      ? SvgPicture.network(
                        product.thumbnail,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholderBuilder:
                            (BuildContext context) => const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                      )
                      : CachedNetworkImage(
                        imageUrl: product.thumbnail,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder:
                            (context, url) => const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => const Icon(Icons.error),
                      ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartBottomSheet extends StatelessWidget {
  final List<Product> cartItems;
  final Function(Product) onRemove;

  const _CartBottomSheet({required this.cartItems, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Keranjang Belanja (${cartItems.length} Item)',
            style: Get.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          if (cartItems.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Keranjang Anda kosong.',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            )
          else
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: Get.height * 0.6, // Maksimal 60% tinggi layar
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final product = cartItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child:
                            product.thumbnail.toLowerCase().endsWith('.svg')
                                ? SvgPicture.network(
                                  product.thumbnail,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  placeholderBuilder:
                                      (BuildContext context) => const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                        ),
                                      ),
                                )
                                : CachedNetworkImage(
                                  imageUrl: product.thumbnail,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context, url) => const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) =>
                                          const Icon(Icons.error),
                                ),
                      ),
                      title: Text(
                        product.title,
                        style: const TextStyle(color: Colors.black87),
                      ),
                      subtitle: Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.black,
                        ),
                        onPressed: () => onRemove(product),
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 20),
          if (cartItems.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total: \$${cartItems.fold(0.0, (sum, item) => sum + item.price).toStringAsFixed(2)}',
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (cartItems.isNotEmpty) {
                  Get.snackbar(
                    'Checkout',
                    'Lanjutkan ke proses pembayaran!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black,
                    colorText: Colors.white,
                  );
                  Get.back();
                  // TODO: Navigasi ke halaman checkout dengan item keranjang
                  // Contoh: Get.to(() => CheckoutPage(cartItems: cartItems));
                } else {
                  Get.snackbar(
                    'Keranjang Kosong',
                    'Tambahkan produk ke keranjang terlebih dahulu.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black,
                    colorText: Colors.white,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Lanjutkan ke Pembayaran',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}