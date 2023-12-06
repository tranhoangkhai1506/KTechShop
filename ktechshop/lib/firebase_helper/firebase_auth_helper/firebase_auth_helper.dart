// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ktechshop/constants/constants.dart';
import 'package:ktechshop/models/user_model/user_model.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FirebaseAuthHelper {
  static FirebaseAuthHelper instance = FirebaseAuthHelper();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final String? _auth1 = FirebaseAuth.instance.currentUser!.displayName;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Stream<User?> get getAuthChange => _auth.authStateChanges();

  // gg login
  FutureOr<bool> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      try {
        // ignore: unused_local_variable
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final userId = _auth.currentUser!.uid;
        final userDoc =
            await _firebaseFirestore.collection("users").doc(userId).get();
        if (userDoc.exists) {
          // Người dùng đã tồn tại
          // ignore: avoid_print
          print("Người dùng đã tồn tại.");
        } else {
          // Người dùng chưa tồn tại
          UserModel userModel = UserModel(
              id: _auth.currentUser!.uid,
              name: _auth.currentUser!.displayName,
              email: _auth.currentUser!.email,
              phone: _auth.currentUser!.phoneNumber != "null"
                  ? "null"
                  : _auth.currentUser!.phoneNumber,
              address: null,
              image: _auth.currentUser!.photoURL);
          _firebaseFirestore
              .collection("users")
              .doc(userModel.id)
              .set(userModel.toJson());
        }
        return true;
      } catch (e) {
        // Xử lý lỗi
        // ignore: avoid_print
        print("Lỗi đăng nhập bằng Google: $e");
        return false;
      }
    } else {
      return false;
    }
  }

  // FutureOr<UserCredential> signInWithFacebook() async {
  //   final LoginResult? loginResult = await FacebookAuth.instance.login();
  //   final OAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }

  FutureOr<bool> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);
        await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        // ignore: unused_local_variable
        final UserCredential userCredential =
            await _auth.signInWithCredential(facebookAuthCredential);
        final userId = _auth.currentUser!.uid;
        final userDoc =
            await _firebaseFirestore.collection("users").doc(userId).get();

        if (userDoc.exists) {
          // Người dùng đã tồn tại
          // ignore: avoid_print
          print("Người dùng đã tồn tại.");
        } else {
          // Người dùng chưa tồn tại
          UserModel userModel = UserModel(
            id: _auth.currentUser!.uid,
            name: _auth.currentUser!.displayName,
            email: _auth.currentUser!.email,
            phone: _auth.currentUser!.phoneNumber != "null"
                ? "null"
                : _auth.currentUser!.phoneNumber,
            address: null,
            image: _auth.currentUser!.photoURL,
          );
          _firebaseFirestore
              .collection("users")
              .doc(userModel.id)
              .set(userModel.toJson());
        }

        return true;
      } else {
        // Login with Facebook failed
        // Handle the failure and return false
        // ignore: avoid_print
        print("Đăng nhập bằng Facebook thất bại.");
        return false;
      }
    } catch (e) {
      // Xử lý lỗi
      // ignore: avoid_print
      print("Lỗi đăng nhập bằng Facebook: $e");
      return false;
    }
  }

  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      showLoaderDialog(context);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context, rootNavigator: true).pop();

      Navigator.of(context).pop();
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
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();

      return true;
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      Navigator.of(context, rootNavigator: true).pop();
      showMessage(e.code.toString());
      return false;
    }
  }

  // ignore: unused_field
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  void signOut(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    await _auth.signOut();
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
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
      Navigator.of(context, rootNavigator: true).pop();
      showMessage("Password changed");
      Navigator.of(context).pop();

      return true;
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      Navigator.of(context, rootNavigator: true).pop();
      showMessage(e.code.toString());
      return false;
    }
  }

  Future<void> sendLinkPasswordReset(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showMessage("Password reset link sent! Check your email!");
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      // Navigator.of(context).pop();
      // Navigator.of(context, rootNavigator: true).pop();
      showMessage(e.code.toString());
    }
  }
}

bool loginValidation(String email, String password) {
  // Define a regular expression for a valid email format
  final emailRegex =
      RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");

  if (email.isEmpty && password.isEmpty) {
    showMessage('Both Fields are empty');
    return false;
  } else if (email.isEmpty) {
    showMessage('Email is empty');
    return false;
  } else if (!emailRegex.hasMatch(email)) {
    showMessage('Invalid email format');
    return false;
  } else if (password.isEmpty) {
    showMessage('Password is empty');
    return false;
  } else {
    return true;
  }
}

bool signUpValidation(
    String email, String password, String name, String phone) {
  final emailRegex =
      RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");

  final phoneRegex = RegExp(r"^(0|84)[1-9][0-9]{8}$");

  final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()-_+=])[A-Za-z\d@$!%*#?&_-]+$');

  if (email.isEmpty && password.isEmpty && name.isEmpty && phone.isEmpty) {
    showMessage('All Fields are empty');
    return false;
  } else if (name.isEmpty) {
    showMessage('Name is empty');
    return false;
  } else if (email.isEmpty) {
    showMessage('Email is empty');
    return false;
  } else if (!emailRegex.hasMatch(email)) {
    showMessage('Invalid email format');
    return false;
  } else if (phone.isEmpty) {
    showMessage('Phone is empty');
    return false;
  } else if (!phoneRegex.hasMatch(phone)) {
    showMessage('Invalid phone format (Vietnam)');
    return false;
  } else if (password.isEmpty) {
    showMessage('Password is empty');
    return false;
  } else if (!passwordRegex.hasMatch(password)) {
    showMessage(
        'Password must contain at least one uppercase letter, one lowercase letter, one special character, and one digit.');
    return false;
  } else {
    return true;
  }
}
