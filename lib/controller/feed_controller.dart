import 'package:get/get.dart';
import 'package:muhammadfirly_rest_api/model/advertisement_model.dart';

class FeedController extends GetxController {
  var advertisements = <Advertisement>[].obs;

  @override
  void onInit() {
    advertisements.addAll([
      Advertisement(
        id: 'ADV001',
        title: 'Parfum Aroma Citrus Segar!',
        imageUrl:
            'assets/images/lemonde.png',
        description: 'Rasakan kesegaran aroma citrus sepanjang hari.',
      ),
      Advertisement(
        id: 'ADV002',
        title: 'Diskon Spesial Parfum Wanita',
        imageUrl:
            'assets/images/givenchylinterdit.png',
        description: 'Tampil menawan dengan koleksi parfum wanita terbaru.',
      ),
      Advertisement(
        id: 'ADV003',
        title: 'Parfum Pria Elegan dan Maskulin',
        imageUrl:
            'assets/images/versacebc.png',
        description: 'Pancarkan aura elegan dengan parfum pilihan kami.',
      ),
    ]);
    super.onInit();
  }
}