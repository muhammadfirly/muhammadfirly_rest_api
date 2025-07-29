import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:muhammadfirly_rest_api/controller/product_controller.dart';
import 'package:muhammadfirly_rest_api/controller/user_controller.dart';
import 'package:muhammadfirly_rest_api/controller/voucher_controller.dart';
import 'package:muhammadfirly_rest_api/controller/feed_controller.dart';
import 'package:muhammadfirly_rest_api/controller/order_controller.dart';
import 'package:muhammadfirly_rest_api/services/api_service.dart';
import 'package:muhammadfirly_rest_api/login.dart';
import 'package:muhammadfirly_rest_api/middleware/auth_middleware.dart';
import 'package:muhammadfirly_rest_api/products.dart';
import 'package:muhammadfirly_rest_api/view/category_page.dart';
import 'package:muhammadfirly_rest_api/view/free_shipping_page.dart';
import 'package:muhammadfirly_rest_api/view/flash_sale_page.dart';
import 'package:muhammadfirly_rest_api/view/feed_page.dart';
import 'package:muhammadfirly_rest_api/view/notification_page.dart';
import 'package:muhammadfirly_rest_api/view/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  Get.put(ApiService());
  Get.put(ProductController());
  Get.put(UserController());
  Get.put(VoucherController());
  Get.put(FeedController());
  Get.put(OrderController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lycommerce Fragrance',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black87,
            side: const BorderSide(color: Colors.black87),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.black),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          headlineMedium: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          headlineSmall: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          titleLarge: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          titleMedium: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          titleSmall: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black87),
          bodySmall: TextStyle(fontSize: 12.0, color: Colors.grey),
          labelLarge: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          labelMedium: TextStyle(fontSize: 12.0, color: Colors.white),
          labelSmall: TextStyle(fontSize: 10.0, color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.grey,
        ).copyWith(
          secondary: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black87,
        ),
      ),
      initialRoute: "/products",
      getPages: [
        GetPage(name: "/login", page: () => LoginPage()),
        GetPage(
          name: "/products",
          page: () => const ProductPage(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: "/categories",
          page: () => CategoryPage(),
        ), // Tambahkan const
        GetPage(name: "/free_shipping", page: () => FreeShippingPage()),
        GetPage(
          name: "/flash_sale",
          page: () => FlashSalePage(),
        ), // Tambahkan const
        GetPage(name: "/feed", page: () => FeedPage()),
        GetPage(name: "/notifications", page: () => NotificationPage()),
        GetPage(
          name: "/profile",
          page: () => ProfilePage(), // Ubah ini menjadi const
        ),
      ],
    );
  }
}
