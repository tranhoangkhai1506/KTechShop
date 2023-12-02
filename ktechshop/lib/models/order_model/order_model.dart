import 'package:ktechshop/models/products_model/product_models.dart';

class OrderModel {
  String orderid;
  String payment;
  String status;
  String? statusReview;
  List<ProductModel> products;
  double totalPrice;
  String userId;
  String? dateOrder;
  String? dateCompletedOrder;
  String? dateCancelOrder;
  String? shippingAddress;

  OrderModel({
    required this.orderid,
    required this.payment,
    required this.status,
    this.statusReview,
    required this.products,
    required this.totalPrice,
    this.dateOrder,
    this.dateCompletedOrder,
    this.shippingAddress,
    this.dateCancelOrder,
    required this.userId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> productMap = json["products"];
    return OrderModel(
      orderid: json["orderid"],
      userId: json["userId"],
      payment: json["payment"],
      status: json["status"],
      statusReview: json["statusReview"],
      totalPrice: json["totalPrice"],
      dateOrder: json["dateOrder"],
      dateCompletedOrder: json["dateOrder"],
      dateCancelOrder: json["dateCancelOrder"],
      shippingAddress: json["shippingAddress"],
      products: productMap.map((e) => ProductModel.fromJson(e)).toList(),
    );
  }
}
