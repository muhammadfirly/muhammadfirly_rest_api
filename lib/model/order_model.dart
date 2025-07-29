import 'package:muhammadfirly_rest_api/model/product_model.dart';

class Order {
  final String orderId;
  final Product product;
  final int quantity;
  final String shippingAddress;
  final String selectedShippingOption;
  final double shippingCost;
  final String selectedPaymentMethod;
  final double totalPayment;
  final DateTime orderDate;
  String status;

  Order({
    required this.orderId,
    required this.product,
    this.quantity = 1,
    required this.shippingAddress,
    required this.selectedShippingOption,
    required this.shippingCost,
    required this.selectedPaymentMethod,
    required this.totalPayment,
    required this.orderDate,
    this.status = 'Pending',
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      shippingAddress: json['shippingAddress'],
      selectedShippingOption: json['selectedShippingOption'],
      shippingCost: (json['shippingCost'] as num).toDouble(),
      selectedPaymentMethod: json['selectedPaymentMethod'],
      totalPayment: (json['totalPayment'] as num).toDouble(),
      orderDate: DateTime.parse(json['orderDate']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'product': product.toJson(),
      'quantity': quantity,
      'shippingAddress': shippingAddress,
      'selectedShippingOption': selectedShippingOption,
      'shippingCost': shippingCost,
      'selectedPaymentMethod': selectedPaymentMethod,
      'totalPayment': totalPayment,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
    };
  }
}