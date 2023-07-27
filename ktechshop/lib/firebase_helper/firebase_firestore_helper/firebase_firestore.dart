import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ktechshop/constants/constants.dart';
import 'package:ktechshop/models/categories_model/categories_model.dart';
import 'package:ktechshop/models/products_model/product_models.dart';

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
}
