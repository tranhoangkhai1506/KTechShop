import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ktechshop/screens/auth_ui/login/login.dart';
import 'package:ktechshop/screens/custom_bottom_bar/custom_bottom_bar.dart';

class AuthService {
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return CustomBottomBar();
          } else {
            print("loi");
            return const Login();
          }
        });
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print(userCredential.user!.email.toString());
      return userCredential.user;
    } catch (e) {
      // Xử lý lỗi
      print("Lỗi đăng nhập bằng Google: $e");
      return null;
    }
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
