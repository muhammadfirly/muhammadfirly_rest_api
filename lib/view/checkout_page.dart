import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:muhammadfirly_rest_api/model/product_model.dart';
import 'package:muhammadfirly_rest_api/model/order_model.dart';
import 'package:muhammadfirly_rest_api/controller/order_controller.dart';
import 'package:uuid/uuid.dart';
import 'package:muhammadfirly_rest_api/view/profile_page.dart';

class CheckoutPage extends StatefulWidget {
  final Product product;

  const CheckoutPage({super.key, required this.product});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? _selectedShippingOption;
  String? _selectedPaymentMethod;

  final Map<String, double> _shippingCosts = {
    'reguler': 10.00,
    'hemat': 5.00,
    'instant': 25.00,
    'sameday': 20.00,
    'nextday': 15.00,
  };

  final TextEditingController _addressController = TextEditingController();

  final OrderController orderController = Get.put(OrderController());
  final Uuid _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _addressController.text =
        'Jalan Spring Avenue, Kel. Lambang Jaya, Kec. Tambun Selatan, Kab. Bekasi, Jawa Barat, 17510';
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Alamat Pengiriman'),
            Card(
              margin: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alamat Anda:',
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _addressController,
                      readOnly: true,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.snackbar(
                            'Fitur',
                            'Integrasi Google Maps untuk pemilihan alamat akan dikembangkan selanjutnya!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.blueAccent,
                            colorText: Colors.white,
                          );
                        },
                        icon: const Icon(Icons.map, color: Colors.white),
                        label: const Text(
                          'Fitur peta off sementara!',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildSectionTitle('Detail Pesanan'),
            Card(
              margin: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.product.thumbnail,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                        errorWidget:
                            (context, url, error) =>
                                const Icon(Icons.error, size: 40),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.title,
                            style: Get.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Brand: ${widget.product.brand}',
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            'Kategori: ${widget.product.category}',
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${widget.product.price.toStringAsFixed(2)}',
                            style: Get.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildSectionTitle('Voucher'),
            Card(
              margin: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: TextField(
                        style: TextStyle(
                          color: Colors.black87,
                        ), // Warna teks input
                        decoration: InputDecoration(
                          hintText: 'Masukkan kode voucher',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Get.snackbar(
                          'Voucher',
                          'Fitur klaim voucher belum diimplementasikan!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.black,
                          colorText: Colors.white,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Klaim'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildSectionTitle('Opsi Pengiriman'),
            Card(
              margin: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _buildShippingOptionRadio(
                    'Reguler (3-5 Hari)',
                    'reguler',
                    10.00,
                  ),
                  _buildShippingOptionRadio('Hemat (5-7 Hari)', 'hemat', 5.00),
                  _buildShippingOptionRadio(
                    'Instant (2 Jam)',
                    'instant',
                    25.00,
                  ),
                  _buildShippingOptionRadio(
                    'Same Day (6-8 Jam)',
                    'sameday',
                    20.00,
                  ),
                  _buildShippingOptionRadio(
                    'Next Day (1 Hari)',
                    'nextday',
                    15.00,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _buildSectionTitle('Metode Pembayaran'),
            Card(
              margin: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text(
                      'Seabank Bayar Instant',
                      style: TextStyle(color: Colors.black87),
                    ),
                    value: 'seabank',
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                    activeColor: Colors.black,
                  ),
                  RadioListTile<String>(
                    title: const Text(
                      'Saldo Payfeer',
                      style: TextStyle(color: Colors.black87),
                    ),
                    value: 'payfeer_saldo',
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                    activeColor: Colors.black,
                  ),
                  RadioListTile<String>(
                    title: const Text(
                      'Feerlater',
                      style: TextStyle(color: Colors.black87),
                    ),
                    value: 'feerlater',
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                    activeColor: Colors.black,
                  ),
                  RadioListTile<String>(
                    title: const Text(
                      'COD (Cash On Delivery)',
                      style: TextStyle(color: Colors.black87),
                    ),
                    value: 'cod',
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                    activeColor: Colors.black,
                  ),
                  ExpansionTile(
                    title: const Text(
                      'Transfer Bank',
                      style: TextStyle(color: Colors.black87),
                    ),
                    collapsedIconColor: Colors.black87,
                    iconColor: Colors.black87,
                    children: [
                      RadioListTile<String>(
                        title: const Text(
                          'BCA',
                          style: TextStyle(color: Colors.black87),
                        ),
                        value: 'transfer_bca',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                        activeColor: Colors.black,
                      ),
                      RadioListTile<String>(
                        title: const Text(
                          'Mandiri',
                          style: TextStyle(color: Colors.black87),
                        ),
                        value: 'transfer_mandiri',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                        activeColor: Colors.black,
                      ),
                      RadioListTile<String>(
                        title: const Text(
                          'BNI',
                          style: TextStyle(color: Colors.black87),
                        ),
                        value: 'transfer_bni',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                        activeColor: Colors.black,
                      ),
                      RadioListTile<String>(
                        title: const Text(
                          'Permata',
                          style: TextStyle(color: Colors.black87),
                        ),
                        value: 'transfer_permata',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                        activeColor: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _buildSectionTitle('Rincian Pembayaran'),
            Card(
              margin: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildPaymentSummaryRow(
                      'Harga Produk',
                      '\$${widget.product.price.toStringAsFixed(2)}',
                    ),
                    _buildPaymentSummaryRow('Diskon Voucher', '-\$0.00'),
                    _buildPaymentSummaryRow(
                      'Biaya Pengiriman',
                      _getShippingCostString(),
                    ),
                    const Divider(color: Colors.grey),
                    _buildPaymentSummaryRow(
                      'Total Pembayaran',
                      '\$${_getTotalPayment().toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomCheckoutBar(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Get.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildShippingOptionRadio(String title, String value, double cost) {
    return RadioListTile<String>(
      title: Text(
        '$title - \$${cost.toStringAsFixed(2)}',
        style: const TextStyle(color: Colors.black87),
      ),
      value: value,
      groupValue: _selectedShippingOption,
      onChanged: (val) {
        setState(() {
          _selectedShippingOption = val;
        });
      },
      activeColor: Colors.black,
    );
  }

  Widget _buildPaymentSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
                isTotal
                    ? Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    )
                    : Get.textTheme.bodyMedium?.copyWith(color: Colors.black54),
          ),
          Text(
            value,
            style:
                isTotal
                    ? Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )
                    : Get.textTheme.bodyMedium?.copyWith(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  double _getShippingCost() {
    return _shippingCosts[_selectedShippingOption] ?? 0.00;
  }

  String _getShippingCostString() {
    final cost = _getShippingCost();
    return cost > 0 ? '+\$${cost.toStringAsFixed(2)}' : '\$0.00';
  }

  double _getTotalPayment() {
    return widget.product.price + _getShippingCost();
  }

  Widget _buildBottomCheckoutBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Harga',
                  style: Get.textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                Text(
                  '\$${_getTotalPayment().toStringAsFixed(2)}',
                  style: Get.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (_selectedShippingOption == null) {
                  Get.snackbar(
                    'Peringatan',
                    'Mohon pilih opsi pengiriman terlebih dahulu.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black,
                    colorText: Colors.white,
                  );
                  return;
                }
                if (_selectedPaymentMethod == null) {
                  Get.snackbar(
                    'Peringatan',
                    'Mohon pilih metode pembayaran terlebih dahulu.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black,
                    colorText: Colors.white,
                  );
                  return;
                }

                final String orderId = _uuid.v4();
                final String shippingAddress = _addressController.text;
                final double totalPayment = _getTotalPayment();
                final double shippingCost = _getShippingCost();

                final newOrder = Order(
                  orderId: orderId,
                  product: widget.product,
                  shippingAddress: shippingAddress,
                  selectedShippingOption: _selectedShippingOption!,
                  shippingCost: shippingCost,
                  selectedPaymentMethod: _selectedPaymentMethod!,
                  totalPayment: totalPayment,
                  orderDate: DateTime.now(),
                  status: 'Sedang Diproses',
                );

                orderController.addOrder(newOrder);

                Get.offAll(() => ProfilePage());

                Get.snackbar(
                  'Navigasi',
                  'Anda dialihkan ke halaman Profil untuk melihat detail pesanan.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.black,
                  colorText: Colors.white,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Buat Pesanan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}