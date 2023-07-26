import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:ktechshop/constants/constants.dart';

class FirebaseAuthHelper {
  static FirebaseAuthHelper instance = FirebaseAuthHelper();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> get getAuthChange => _auth.authStateChanges();

  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      showLoaderDialog(context);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      return true;
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      showMessage(e.code.toString());
      return false;
    }
  }

  Future<bool> signUp(
      String email, String password, BuildContext context) async {
    try {
      showLoaderDialog(context);
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      return true;
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
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
