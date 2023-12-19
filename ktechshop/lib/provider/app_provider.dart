import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ktechshop/constants/constants.dart';
import 'package:ktechshop/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:ktechshop/firebase_helper/firebase_storage_helper/firebase_storage_helper.dart';
import 'package:ktechshop/models/products_model/product_models.dart';
import 'package:ktechshop/models/user_model/user_model.dart';

class AppProvider with ChangeNotifier {
  // Cart Work
  final List<ProductModel> _cartProductList = [];
  final List<ProductModel> _buyProductList = [];

  UserModel? _userModel;

  UserModel get getUserInformation => _userModel!;
  void addCartProduct(ProductModel productModel) {
    _cartProductList.add(productModel);
    notifyListeners();
  }

  void removeCartProduct(ProductModel productModel) {
    _cartProductList.remove(productModel);
    notifyListeners();
  }

  List<ProductModel> get getCartProductList => _cartProductList;

// Favourite
  final List<ProductModel> _favouriteProductList = [];

  void addFavouriteProduct(ProductModel productModel) {
    _favouriteProductList.add(productModel);
    notifyListeners();
  }

  void removeFavouriteProduct(ProductModel productModel) {
    _favouriteProductList.remove(productModel);
    notifyListeners();
  }

  List<ProductModel> get getFavouriteProductList => _favouriteProductList;

  void getUserInfoFirebase() async {
    _userModel = await FirebaseFirestoreHelper.instance.getUserInformation();
    notifyListeners();
  }

  void updateAddressUserInforFirebase(
      BuildContext context, UserModel userModel) async {
    _userModel = userModel;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(_userModel!.id)
        .set(_userModel!.toJson());
    showMessage("Saved");
    notifyListeners();
  }

  void updateUserInforFirebase(
      BuildContext context, UserModel userModel, File? file) async {
    if (file == null) {
      showLoaderDialog(context);
      _userModel = userModel;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userModel!.id)
          .set(_userModel!.toJson());
      // ignore: use_build_context_synchronously
      Navigator.of(context, rootNavigator: true).pop();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } else {
      showLoaderDialog(context);

      String imageUrl =
          await FirebaseStorageHelper.instance.uploadUserImage(file);
      _userModel = userModel.copyWith(image: imageUrl);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userModel!.id)
          .set(_userModel!.toJson());

      // ignore: use_build_context_synchronously
      Navigator.of(context, rootNavigator: true).pop();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
    showMessage("Saved");
    notifyListeners();
  }

  // Total price

  double totalPrice() {
    double totalPrice = 0.0;
    for (var element in _cartProductList) {
      totalPrice += element.price * element.quantity!;
    }
    return totalPrice;
  }

  double totalPriceBuyProduct() {
    double totalPrice = 0.0;
    for (var element in _buyProductList) {
      totalPrice += element.price * element.quantity!;
    }
    return totalPrice;
  }

  void updateQuantity(ProductModel productModel, int qty) {
    int index = _cartProductList.indexOf(productModel);
    _cartProductList[index].quantity = qty;
    notifyListeners();
  }

  // Buy product

  void addBuyProduct(ProductModel productModel) {
    _buyProductList.add(productModel);
    notifyListeners();
  }

  void addBuyProductCart() {
    _buyProductList.addAll(_cartProductList);
    notifyListeners();
  }

  void clearCart() {
    _cartProductList.clear();
    notifyListeners();
  }

  void clearBuyProduct() {
    _buyProductList.clear();
    notifyListeners();
  }

  List<ProductModel> get getBuyProductList => _buyProductList;

  Future<Position> _getCurrentLocation() async {
    late bool servicePermission = false;
    late LocationPermission permission;
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print("service disable");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition();
  }

  Position? _currentLocation;
  String _currentAddress = "";

  Future<String> getAddressFromCoordinates() async {
    _currentLocation = await _getCurrentLocation();
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentLocation!.latitude, _currentLocation!.longitude);

      Placemark place = placemarks[0];

      _currentAddress =
          " ${place.street}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";
    } catch (e) {
      _currentAddress = "null";
    }
    notifyListeners();
    return _currentAddress;
  }

  Future<List<ProductModel>> getProductUUCFList() async {
    return await FirebaseFirestoreHelper.instance
        .suggestProductsForUser(FirebaseAuth.instance.currentUser!.uid);
  }
}
