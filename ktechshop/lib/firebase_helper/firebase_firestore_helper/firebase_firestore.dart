// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ktechshop/constants/constants.dart';
import 'package:ktechshop/models/categories_model/categories_model.dart';
import 'package:ktechshop/models/order_model/order_model.dart';
import 'package:ktechshop/models/products_model/product_models.dart';
import 'package:ktechshop/models/rating_model/rating_model.dart';
import 'package:ktechshop/models/user_model/user_model.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<CategoriesModel>> getCategory() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection("catagories").get();
      List<CategoriesModel> categoriesList = querySnapshot.docs
          .map((e) => CategoriesModel.fromJson(e.data()))
          .toList();
      return categoriesList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getBestProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collectionGroup("products").get();
      List<ProductModel> bestProductList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();
      return bestProductList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getCategoryViewProduct(String id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("catagories")
              .doc(id)
              .collection("products")
              .get();
      List<ProductModel> bestProductList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();
      return bestProductList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<UserModel> getUserInformation() async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
    return UserModel.fromJson(querySnapshot.data()!);
  }

  Future<bool> uploadOrderProductFirebase(List<ProductModel> list,
      BuildContext context, String payment, String shippingAddress) async {
    try {
      showLoaderDialog(context);
      String dateOrder = formatDate(DateTime.now()).toString();
      double totalPrice = 0.0;
      for (var element in list) {
        totalPrice += element.price * element.quantity!;
      }
      DocumentReference documentReference = _firebaseFirestore
          .collection("usersOrders")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("orders")
          .doc();

      DocumentReference admin =
          _firebaseFirestore.collection("orders").doc(documentReference.id);
      String uid = FirebaseAuth.instance.currentUser!.uid;
      admin.set({
        "products": list.map((e) => e.toJson()),
        "status": "Pending",
        "totalPrice": totalPrice,
        "payment": payment,
        "userId": uid,
        "orderid": admin.id,
        "shippingAddress": shippingAddress,
        "statusReview": "Review",
        "dateOrder": dateOrder
      });

      documentReference.set({
        "products": list.map((e) => e.toJson()),
        "status": "Pending",
        "totalPrice": totalPrice,
        "payment": payment,
        "userId": uid,
        "shippingAddress": shippingAddress,
        "statusReview": "Review",
        "orderid": documentReference.id,
        "dateOrder": dateOrder
      });
      Navigator.of(context, rootNavigator: true).pop();
      showMessage("Ordered Successfully");

      return true;
    } catch (e) {
      showMessage(e.toString());
      Navigator.of(context, rootNavigator: true).pop();
      return false;
    }
  }

  // Get orders User

  Future<List<OrderModel>> getUserOrder() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("usersOrders")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("orders")
              .get();

      List<OrderModel> orderList = querySnapshot.docs
          .map((element) => OrderModel.fromJson(element.data()))
          .toList();

      return orderList;
    } catch (e) {
      return [];
    }
  }

  void updateTokenFromFirebase() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await _firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "notificationToken": token,
      });
    }
  }

  Future<void> updateOrder(OrderModel orderModel, String status) async {
    String dateCompletedOrCancelOrder = formatDate(DateTime.now()).toString();
    // Nguời dùng hủy đơn hàng
    if (status.contains("Cancel")) {
      await _firebaseFirestore
          .collection("usersOrders")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("orders")
          .doc(orderModel.orderid)
          .update({
        "status": status,
        "dateCancelOrder": dateCompletedOrCancelOrder
      });

      await _firebaseFirestore
          .collection("orders")
          .doc(orderModel.orderid)
          .update({
        "status": status,
        "dateCancelOrder": dateCompletedOrCancelOrder
      });
    }
    //Người dùng đã nhận hàng
    if (status.contains("Completed")) {
      await _firebaseFirestore
          .collection("usersOrders")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("orders")
          .doc(orderModel.orderid)
          .update({
        "status": status,
        "dateCompletedOrder": dateCompletedOrCancelOrder
      });

      await _firebaseFirestore
          .collection("orders")
          .doc(orderModel.orderid)
          .update({
        "status": status,
        "dateCompletedOrder": dateCompletedOrCancelOrder
      });
    }
  }

  Future<void> updateOrderReview(String orderId, String statusReview) async {
    // Nguời dùng hủy đơn hàng
    if (statusReview.contains("Review")) {
      await _firebaseFirestore
          .collection("usersOrders")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("orders")
          .doc(orderId)
          .update({
        "statusReview": statusReview,
      });

      await _firebaseFirestore.collection("orders").doc(orderId).update({
        "statusReview": statusReview,
      });
    }
  }

  Future<List<ProductModel>> getProductSuggestionByRatedScore() async {
    QuerySnapshot<Map<String, dynamic>> querysnapshot_ratingList =
        await _firebaseFirestore.collectionGroup("ratings").get();
    List<RatingModel> ratingList = querysnapshot_ratingList.docs
        .map((element) => RatingModel.fromJson(element.data()))
        .toList();

    QuerySnapshot<Map<String, dynamic>> querySnapshot_productList =
        await _firebaseFirestore.collectionGroup("products").get();

    List<ProductModel> productList = querySnapshot_productList.docs
        .map((element) => ProductModel.fromJson(element.data()))
        .toList();

    Map<String, Map<String, double>> productRatingsMap = {};

    for (var rating in ratingList) {
      if (rating.rating != "0.0" && rating.rating.isNotEmpty) {
        double numericRating = double.tryParse(rating.rating) ?? 0.0;

        if (productRatingsMap.containsKey(rating.productId)) {
          // Update sum and count for existing product
          productRatingsMap[rating.productId]!['sum'] =
              (productRatingsMap[rating.productId]!['sum'] ?? 0.0) +
                  numericRating;
          productRatingsMap[rating.productId]!['count'] =
              (productRatingsMap[rating.productId]!['count'] ?? 0.0) + 1.0;
        } else {
          // Initialize sum and count for new product
          productRatingsMap[rating.productId] = {
            'sum': numericRating,
            'count': 1.0
          };
        }
      }
    }

    List<ProductModel> productsWithAverageRating = productList
        .where((product) => productRatingsMap[product.id]?['sum'] != 0.0)
        .map((product) {
      double sumRating = productRatingsMap[product.id]?['sum'] ?? 0.0;
      double countRating = productRatingsMap[product.id]?['count'] ?? 1.0;

      return ProductModel(
        image: product.image,
        name: product.name,
        id: product.id,
        isFavourite: product.isFavourite,
        price: product.price,
        description: product.description,
        status: product.status,
        quantity: product.quantity,
        averageRating: countRating > 0 ? sumRating / countRating : 0.0,
      );
    }).toList();

    return productsWithAverageRating
        .where((element) => element.averageRating != 0.0)
        .toList();
  }

  Future<bool> isRatingOrder(String orderId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot_userRatingList =
        await _firebaseFirestore
            .collection("usersRatings")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("ordersRatigs")
            .doc(orderId)
            .collection("ratings")
            .get();
    List<RatingModel> ratingList = querySnapshot_userRatingList.docs
        .map((element) => RatingModel.fromJson(element.data()))
        .toList();

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firebaseFirestore
        .collection("usersOrders")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("orders")
        .get();

    List<OrderModel> orderList = querySnapshot.docs
        .map((element) => OrderModel.fromJson(element.data()))
        .toList();
    late OrderModel orderModel;
    if (orderList.isNotEmpty) {
      orderModel =
          orderList.firstWhere((element) => element.orderid == orderId);
      if (orderModel.products.length == ratingList.length) {
        return true;
      }
    }
    return false;
  }

  Future<bool> uploadRatingFirebase(
      String orderID, RatingModel rating, BuildContext context) async {
    try {
      showLoaderDialog(context);
      DocumentReference documentReference = _firebaseFirestore
          .collection("usersRatings")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("ordersRatigs")
          .doc(orderID)
          .collection("ratings")
          .doc(rating.productId);

      documentReference.set({
        "productId": rating.productId,
        "userId": rating.userId,
        "rating": rating.rating,
        "content": rating.content
      });
      Navigator.of(context, rootNavigator: true).pop();
      showMessage("Rating Successfully");

      return true;
    } catch (e) {
      showMessage(e.toString());
      Navigator.of(context, rootNavigator: true).pop();
      return false;
    }
  }

  String formatDate(DateTime date) {
    // Format the date as 'yyyy-MM-dd'
    String year = date.year.toString();
    String month = _twoDigits(date.month);
    String day = _twoDigits(date.day);

    return '$year-$month-$day';
  }

  String _twoDigits(int n) {
    // Add leading zero if the number is less than 10
    return n < 10 ? '0$n' : '$n';
  }
}
