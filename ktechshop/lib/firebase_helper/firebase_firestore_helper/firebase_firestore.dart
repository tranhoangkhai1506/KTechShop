// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ktechshop/constants/constants.dart';
import 'package:ktechshop/models/categories_model/categories_model.dart';
import 'package:ktechshop/models/order_model/order_model.dart';
import 'package:ktechshop/models/products_model/product_models.dart';
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
        "shippingAddress": shippingAddress
      });

      documentReference.set({
        "products": list.map((e) => e.toJson()),
        "status": "Pending",
        "totalPrice": totalPrice,
        "payment": payment,
        "userId": uid,
        "shippingAddress": shippingAddress,
        "orderid": documentReference.id //
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
    await _firebaseFirestore
        .collection("usersOrders")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("orders")
        .doc(orderModel.orderid)
        .update({
      "status": status,
    });

    await _firebaseFirestore
        .collection("orders")
        .doc(orderModel.orderid)
        .update({
      "status": status,
    });
  }
}
