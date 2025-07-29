import 'package:get/get.dart';
import 'package:muhammadfirly_rest_api/model/voucher_model.dart';

class VoucherController extends GetxController {
  var availableVouchers = <Voucher>[].obs;
  var claimedVouchers = <Voucher>[].obs;
  var notifications = <String>[].obs;

  @override
  void onInit() {
    availableVouchers.addAll([
      Voucher(
        id: 'VCR001',
        title: 'Diskon 10% Semua Parfum',
        description: 'Potongan 10% untuk pembelian parfum apa saja.',
        discountAmount: '10%',
        expiryDate: '31 Des 2025',
        imageUrl:
            'https://via.placeholder.com/150/FFD700/000000?text=Voucher+10%25',
      ),
      Voucher(
        id: 'VCR002',
        title: 'Gratis Ongkir Min. Rp 50rb',
        description: 'Nikmati gratis ongkir dengan minimal belanja Rp 50.000.',
        discountAmount: 'Gratis Ongkir',
        expiryDate: '15 Nov 2025',
        imageUrl:
            'https://via.placeholder.com/150/00BFFF/FFFFFF?text=Gratis+Ongkir',
      ),
      Voucher(
        id: 'VCR003',
        title: 'Cashback 20% Parfum Pria',
        description:
            'Dapatkan cashback 20% untuk pembelian parfum pria tertentu.',
        discountAmount: '20% Cashback',
        expiryDate: '10 Okt 2025',
        imageUrl:
            'https://via.placeholder.com/150/8A2BE2/FFFFFF?text=Cashback+20%25',
      ),
    ]);
    super.onInit();
  }

  void claimVoucher(Voucher voucher) {
    if (!voucher.isClaimed) {
      int index = availableVouchers.indexOf(voucher);
      if (index != -1) {
        availableVouchers[index].isClaimed = true;
        claimedVouchers.add(availableVouchers[index]);
        availableVouchers.removeAt(index);
        Get.snackbar(
          'Voucher Diklaim!',
          'Voucher ${voucher.title} berhasil diklaim.',
        );
        addNotification('Voucher "${voucher.title}" telah berhasil diklaim!');
      }
    } else {
      Get.snackbar('Info', 'Voucher ini sudah diklaim.');
    }
  }

  void addNotification(String message) {
    notifications.insert(0, message);
  }

  void clearNotifications() {
    notifications.clear();
  }
}