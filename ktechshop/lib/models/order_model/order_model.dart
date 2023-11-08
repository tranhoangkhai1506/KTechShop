import 'package:ktechshop/models/products_model/product_models.dart';

class OrderModel {
  String orderid;
  String payment;
  String status;
  List<ProductModel> products;
  double totalPrice;
  String userId;
  String? shippingAddress;

  OrderModel({
    required this.orderid,
    required this.payment,
    required this.status,
    required this.products,
    required this.totalPrice,
    this.shippingAddress,
    required this.userId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> productMap = json["products"];
    return OrderModel(
      orderid: json["orderid"],
      userId: json["userId"],
      payment: json["payment"],
      status: json["status"],
      totalPrice: json["totalPrice"],
      shippingAddress: json["shippingAddress"],
      products: productMap.map((e) => ProductModel.fromJson(e)).toList(),
    );
  }
}
