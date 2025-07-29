import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muhammadfirly_rest_api/model/product_model.dart';
import 'package:muhammadfirly_rest_api/model/user_model.dart';
import 'package:muhammadfirly_rest_api/utils/shared_prefs.dart';

class ApiService {
  final String _baseUrl = 'http://172.20.10.3:3000';

  //final String _baseUrl = 'http://10.0.2.2:3000'; // for Android emulator
  //final String _baseUrl = 'http://127.0.0.1:3000'; // for web or desktop

  ApiService();

  // Metode login
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      print("Login Response Status: ${response.statusCode}");
      print("Login Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          final token = responseData['access_token'];
          final user = responseData['user'];

          await SharedPrefs.saveAuthToken(token);
          await SharedPrefs.saveUserData(user);

          return true;
        } else {
          throw Exception(responseData['message'] ?? 'Login failed');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ?? 'Failed to connect to server or login failed',
        );
      }
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }

  Future<User?> fetchUserProfile() async {
    final token = await SharedPrefs.getAuthToken();
    if (token == null) {
      print('No authentication token found. User not logged in.');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/users/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Fetch Profile Response Status: ${response.statusCode}");
      print("Fetch Profile Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return User.fromJson(responseData);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print('Unauthorized access to profile. Clearing token...');
        await SharedPrefs.clearAuthData();
        throw Exception('Unauthorized. Please login again.');
      } else {
        throw Exception('Failed to load user profile: ${response.body}');
      }
    } catch (e) {
      print('Error in fetchUserProfile: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await SharedPrefs.clearAuthData();
  }

  Future<List<Product>> fetchProducts({String? query, String? category}) async {
    Map<String, String> params = {};
    if (query != null && query.isNotEmpty) {
      params['q'] = query;
    }
    if (category != null && category.isNotEmpty) {
      params['category'] = category;
    }

    final uri = Uri.parse(
      '$_baseUrl/products',
    ).replace(queryParameters: params);
    final response = await http.get(uri);

    print("Products Response status: ${response.statusCode}");
    print("Products Response body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> rawList = responseData['data'];
      return rawList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load products: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<Product> fetchProductDetail(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/products/$id'));
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to load product detail: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<List<Product>> fetchFlashSaleProducts() async {
    final allProducts = await fetchProducts();
    allProducts.sort(
      (a, b) => b.discountPercentage.compareTo(a.discountPercentage),
    );
    return allProducts.take(5).toList();
  }
}