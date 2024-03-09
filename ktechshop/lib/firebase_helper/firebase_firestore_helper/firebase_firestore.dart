// ignore_for_file: use_build_context_synchronously
import 'dart:math';

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

  Future<List<OrderModel>> getUserOrderCompleted() async {
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
      List<OrderModel> completedOrderList = orderList
          .where((element) => element.status.contains("Completed"))
          .toList();
      return completedOrderList;
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
      double averageRating = countRating > 0 ? sumRating / countRating : 0.0;

      // Round the averageRating to the nearest half
      double roundedRating = (averageRating * 2).round() / 2;
      // print(product.id + " " + roundedRating.toString());

      return ProductModel(
        image: product.image,
        name: product.name,
        id: product.id,
        isFavourite: product.isFavourite,
        price: product.price,
        description: product.description,
        status: product.status,
        quantity: product.quantity,
        averageRating: roundedRating,
      );
    }).toList();

    // Điều kiện muốn lấy sản phẩm có ? sao trung bình
    return productsWithAverageRating
        .where((element) => element.averageRating! > 3)
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

  ///////////////////
  /*Neighborhood-Based Collaborative Filtering*/
  Future<List<ProductModel>> getUserRatings(String userID) async {
    QuerySnapshot<Map<String, dynamic>> querysnapshot_ratingList =
        await _firebaseFirestore.collectionGroup("ratings").get();
    List<RatingModel> ratingListTemp = querysnapshot_ratingList.docs
        .map((element) => RatingModel.fromJson(element.data()))
        .toList();
    List<RatingModel> ratingList = ratingListTemp
        .where((element) => element.userId.contains(userID))
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
      double averageRating = countRating > 0 ? sumRating / countRating : -1.0;

      return ProductModel(
        image: product.image,
        name: product.name,
        id: product.id,
        isFavourite: product.isFavourite,
        price: product.price,
        description: product.description,
        status: product.status,
        quantity: product.quantity,
        averageRating:
            averageRating != -1.0 ? (averageRating * 2).round() / 2 : -1.0,
      );
    }).toList();
    return productsWithAverageRating;
  }

  Future<List<List<double>>> utilityMatrixY() async {
    List<ProductModel> productList = await getBestProducts();
    List<UserModel> userList = await getAllUsers();
    int soCot = userList.length;
    int soDong = productList.length;

    // Tạo map lưu trữ đánh giá của từng người dùng cho từng sản phẩm
    Map<String, Map<String, double>> userRatingsMap = {};
    for (var user in userList) {
      List<ProductModel> listRating = await getUserRatings(user.id);
      Map<String, double> productRatings = {
        for (var rating in listRating) rating.id: rating.averageRating!
      };
      userRatingsMap[user.id] = productRatings;
    }

    // Tạo ma trận tiện ích
    List<List<double>> matrix = List.generate(
        soDong,
        (i) => List.generate(soCot,
            (j) => userRatingsMap[userList[j].id]?[productList[i].id] ?? 0.0));

    return matrix;
  }

  double avgUserRating(int columnIndex, List<List<double>> utilityMatrix) {
    double sumScore = 0.0;
    int count = 0;
    for (var i = 0; i < utilityMatrix.length; i++) {
      double rating = utilityMatrix[i][columnIndex];
      // Include a condition to check if rating is a valid number if necessary
      if (rating != 0.0) {
        sumScore += rating;
        count++;
      }
    }
    return count > 0 ? sumScore / count : 0.0;
  }

  Future<List<List<double>>> normalizedUtilityMatrixY(
      List<List<double>> utilityMatrix) async {
    int soCot = utilityMatrix[0].length;
    int soDong = utilityMatrix.length;

    List<List<double>> normalizedMatrix =
        List.generate(soDong, (index) => List.generate(soCot, (index) => 0.0));

    //Khởi tạo utilityMatrix với userCot itemDong tương ứng với giá tri rate từng sản phẩm
    for (var i = 0; i < soCot; i++) {
      double avgScore = avgUserRating(i, utilityMatrix);
      for (var j = 0; j < soDong; j++) {
        if (avgScore != 0.0 && utilityMatrix[j][i] != 0.0) {
          normalizedMatrix[j][i] = utilityMatrix[j][i] - avgScore;
          print(
              "User Index:${i} Item: $j DiemTB: ${avgScore} DiemChuanHoa: ${normalizedMatrix[j][i]}");
        } else {
          normalizedMatrix[j][i] = 0.0;
        }
      }
    }

    return normalizedMatrix;
  }

// Function to calculate cosine similarity between two users
  double cosineSimilarity(List<double> user1, List<double> user2) {
    double dotProduct = 0.0;
    double normUser1 = 0.0;
    double normUser2 = 0.0;

    for (int i = 0; i < user1.length; i++) {
      dotProduct += user1[i] * user2[i];
      normUser1 += user1[i] * user1[i];
      normUser2 += user2[i] * user2[i];
    }

    if (normUser1 == 0.0 || normUser2 == 0.0) {
      return 0.0;
    }

    return dotProduct / (sqrt(normUser1) * sqrt(normUser2));
  }

// Function to create a matrix of cosine similarities
  Future<List<List<double>>> cosineSimilarityMatrix(
      List<List<double>> normalizedMatrix) async {
    int numUsers = normalizedMatrix[0].length;
    List<List<double>> similarityMatrix = List.generate(
      numUsers,
      (i) => List.generate(numUsers, (j) => 0.0),
    );

    for (int i = 0; i < numUsers; i++) {
      for (int j = 0; j < numUsers; j++) {
        if (i != j) {
          similarityMatrix[i][j] = cosineSimilarity(
            normalizedMatrix.map((e) => e[i]).toList(),
            normalizedMatrix.map((e) => e[j]).toList(),
          );
        } else {
          similarityMatrix[i][j] = 1.0;
        }
      }
    }

    return similarityMatrix;
  }

// Function to predict ratings for a user with nearest neighbors approach
  Future<double> predictRating(
      int productIndex,
      int userIndex,
      List<List<double>> normalizedMatrix,
      List<List<double>> similarityMatrix,
      int k) async {
    // Add 'k' as a parameter for the number of nearest neighbors

    // Step 1: Find users who have rated the product and their similarities
    List<Map<String, dynamic>> usersAndSimilarities = [];
    for (int i = 0; i < normalizedMatrix[0].length; i++) {
      if (i != userIndex && normalizedMatrix[productIndex][i] != 0.0) {
        usersAndSimilarities
            .add({'index': i, 'similarity': similarityMatrix[userIndex][i]});
      }
    }

// Print for debugging before sorting
    print("Before Sorting and Selecting Top k:");
    for (var entry in usersAndSimilarities) {
      print(
          'User index: ${entry['index']}, Similarity: ${entry['similarity']}');
    }

// Step 2: Sort by similarity in descending order and take top k nearest neighbors
    usersAndSimilarities
        .sort((a, b) => b['similarity'].compareTo(a['similarity']));
    List<Map<String, dynamic>> nearestNeighbors =
        usersAndSimilarities.take(k).toList();

// Print for debugging after selecting top k
    print("After Selecting Top k:");
    for (var userAndSimilarity in nearestNeighbors) {
      print(
          'User index: ${userAndSimilarity['index']}, Similarity: ${userAndSimilarity['similarity']}');
    }

    // Ensure that only positive similarities are considered
    nearestNeighbors = nearestNeighbors
        .where((neighbor) => neighbor['similarity'] > 0)
        .toList();

    // Step 3: Compute the predicted rating
    double numerator = 0.0;
    double denominator = 0.0;
    for (var neighbor in nearestNeighbors) {
      int neighborIndex = neighbor['index'];
      double similarity = neighbor['similarity'];
      double neighborRating = normalizedMatrix[productIndex][neighborIndex];

      numerator += similarity * neighborRating;
      denominator += similarity.abs();
    }

    // Step 4: Return the predicted rating
    return denominator != 0.0 ? numerator / denominator : 0.0;
  }

  // Assuming you have a function getUserIndex(String userID) that returns the index of the user in the matrix
  Future<int> getUserIndex(String userID) async {
    // Implementation to find the user's index in the matrix
    List<UserModel> userList = await getAllUsers();
    return userList
        .indexWhere((element) => element.id.contains(userID))
        .toInt();
  }

  // Function to suggest products for a user
  Future<List<ProductModel>> suggestProductsForUser(String userID) async {
    List<ProductModel> allProducts =
        await getBestProducts(); // Fetch all products
    List<List<double>> utilityMatrix =
        await utilityMatrixY(); // Get the utility matrix
    List<List<double>> normalizedMatrix =
        await normalizedUtilityMatrixY(utilityMatrix); // Normalize the matrix
    List<List<double>> similarityMatrix = await cosineSimilarityMatrix(
        normalizedMatrix); // Get cosine similarity matrix

    int userIndex =
        await getUserIndex(userID); // Get the index of the current user

    List<double> predictedRatings = [];
    for (int i = 0; i < allProducts.length; i++) {
      // Predict the rating only if the user hasn't rated the product yet
      if (utilityMatrix[i][userIndex] == 0.0) {
        double predictedRating = await predictRating(
            i, userIndex, normalizedMatrix, similarityMatrix, 2);
        predictedRatings.add(predictedRating);
      } else {
        predictedRatings.add(-1.0); // Mark already rated products
      }
    }

    List<ProductModel> suggestedProducts = [];
    for (int i = 0; i < predictedRatings.length; i++) {
      // Include only products with positive predicted ratings
      if (predictedRatings[i] >= 0) {
        ProductModel product = allProducts[i];
        //product.averageRating = predictedRatings[i]; // Set the predicted rating
        suggestedProducts.add(product);
        print("${product.name} ID: ${i} Diem: ${predictedRatings[i]}");
      }
    }

    // Sort the products based on the predicted ratings in descending order
    suggestedProducts
        .sort((a, b) => b.averageRating!.compareTo(a.averageRating!));

    return suggestedProducts;
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection("users").get();
      List<UserModel> usersList =
          querySnapshot.docs.map((e) => UserModel.fromJson(e.data())).toList();
      return usersList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getBestProducts() async {
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
      double averageRating = countRating > 0 ? sumRating / countRating : 0.0;

      // Round the averageRating to the nearest half
      double roundedRating = (averageRating * 2).round() / 2;
      // print(product.id + " " + roundedRating.toString());

      return ProductModel(
        image: product.image,
        name: product.name,
        id: product.id,
        isFavourite: product.isFavourite,
        price: product.price,
        description: product.description,
        status: product.status,
        quantity: product.quantity,
        averageRating: roundedRating,
      );
    }).toList();

    // Điều kiện muốn lấy sản phẩm có ? sao trung bình
    return productsWithAverageRating;
  }
  /////////////////////////////////////////////////////////////////////////////

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

  void printMatrix() async {
    List<List<double>> matrix = await utilityMatrixY();
    List<List<double>> normalizedMatrix =
        await normalizedUtilityMatrixY(matrix);

    for (var i = 0; i < normalizedMatrix.length; i++) {
      for (var j = 0; j < normalizedMatrix[i].length; j++) {
        print(normalizedMatrix[i][j].toString() + " dong " + i.toString());
      }
    }
  }
}
