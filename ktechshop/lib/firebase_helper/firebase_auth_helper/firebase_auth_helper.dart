import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:ktechshop/constants/constants.dart';
import 'package:ktechshop/models/user_model/user_model.dart';

class FirebaseAuthHelper {
  static FirebaseAuthHelper instance = FirebaseAuthHelper();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Stream<User?> get getAuthChange => _auth.authStateChanges();

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

  void signOut() async {
    await _auth.signOut();
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
