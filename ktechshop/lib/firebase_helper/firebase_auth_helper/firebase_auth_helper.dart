import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ktechshop/constants/constants.dart';
import 'package:ktechshop/models/user_model/user_model.dart';
import 'package:ktechshop/screens/auth_ui/welcome/welcome.dart';

class FirebaseAuthHelper {
  static FirebaseAuthHelper instance = FirebaseAuthHelper();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final String? _auth1 = FirebaseAuth.instance.currentUser!.displayName;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Stream<User?> get getAuthChange => _auth.authStateChanges();

  // gg login
  FutureOr<bool> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      UserModel userModel = UserModel(
          id: _auth.currentUser!.uid,
          name: _auth.currentUser!.displayName,
          email: _auth.currentUser!.email,
          // phone: _auth.currentUser!.phoneNumber != "null"
          //     ? "null"
          //     : _auth.currentUser!.phoneNumber,
          // address: null,
          image: _auth.currentUser!.photoURL);
      _firebaseFirestore
          .collection("users")
          .doc(userModel.id)
          .set(userModel.toJson());
      //print(_auth1);
      return true;
    } catch (e) {
      // Xử lý lỗi
      print("Lỗi đăng nhập bằng Google: $e");
      return false;
    }
  }

  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      showLoaderDialog(context);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // ignore: use_build_context_synchronously
      Navigator.of(context, rootNavigator: true).pop();

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      return true;
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      Navigator.of(context, rootNavigator: true).pop();
      showMessage(e.code.toString());
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password, String phone,
      BuildContext context) async {
    try {
      showLoaderDialog(context);
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      UserModel userModel = UserModel(
          id: userCredential.user!.uid,
          name: name,
          email: email,
          phone: phone,
          address: null,
          image: null);
      _firebaseFirestore
          .collection("users")
          .doc(userModel.id)
          .set(userModel.toJson());
      // ignore: use_build_context_synchronously
      Navigator.of(context, rootNavigator: true).pop();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();

      return true;
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      Navigator.of(context, rootNavigator: true).pop();
      showMessage(e.code.toString());
      return false;
    }
  }

  void signOut(BuildContext context) async {
    // Thực hiện đăng xuất ở đây (ví dụ: _auth.signOut() và _googleSignIn.signOut())
    await _auth.signOut();
    // ignore: use_build_context_synchronously
    //Routes.instance.push(widget: Welcome(), context: context);
    // Điều hướng người dùng đến trang đăng nhập hoặc màn hình khởi đầu
    // ignore: use_build_context_synchronously
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) =>
    //           Welcome()), // Thay YourLoginPage bằng màn hình đăng nhập của bạn
    //   (route) => false, // Loại bỏ tất cả màn hình khỏi ngăn xếp
    // );
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              Welcome()), // Thay OtherScreen bằng màn hình khác bạn muốn hiển thị
    );
  }

  Future<bool> changePassword(String password, BuildContext context) async {
    try {
      showLoaderDialog(context);
      _auth.currentUser!.updatePassword(password);
      // UserCredential userCredential = await _auth
      //     .createUserWithEmailAndPassword(email: email, password: password);
      // UserModel userModel = UserModel(
      //     id: userCredential.user!.uid, name: name, email: email, image: null);
      // _firebaseFirestore
      //     .collection("users")
      //     .doc(userModel.id)
      //     .set(userModel.toJson());
      // ignore: use_build_context_synchronously
      Navigator.of(context, rootNavigator: true).pop();
      showMessage("Password changed");
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();

      return true;
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      Navigator.of(context, rootNavigator: true).pop();
      showMessage(e.code.toString());
      return false;
    }
  }
}

bool loginVaildation(String email, String password) {
  if (email.isEmpty && password.isEmpty) {
    showMessage('Both Fields are empty');
    return false;
  } else if (email.isEmpty) {
    showMessage('email is empty');
    return false;
  } else if (password.isEmpty) {
    showMessage('password is empty');
    return false;
  } else {
    return true;
  }
}

bool signUpVaildation(
    String email, String password, String name, String phone) {
  if (email.isEmpty && password.isEmpty && name.isEmpty && phone.isEmpty) {
    showMessage('Both Fields are empty');
    return false;
  } else if (email.isEmpty) {
    showMessage('email is empty');
    return false;
  } else if (password.isEmpty) {
    showMessage('password is empty');
    return false;
  } else if (name.isEmpty) {
    showMessage('name is empty');
    return false;
  } else if (phone.isEmpty) {
    showMessage('password is empty');
    return false;
  } else {
    return true;
  }
}
