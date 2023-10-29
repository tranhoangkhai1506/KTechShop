import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ktechshop/constants/routes.dart';
import 'package:ktechshop/screens/auth_ui/login/login.dart';
import 'package:ktechshop/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:ktechshop/screens/home/home.dart';

class AuthService {
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            print("ok");
            //Routes.instance.push(widget: CustomBottomBar(), context: context);
            return CustomBottomBar();
          } else {
            print("loi");
            return const Login();
          }
        });
  }

  Future<User?> signInWithGoogle() async {
    print("step 1");
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      print("step k dn");
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    if (credential != null) {
      print("have");
    } else {
      print("null");
    }

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("ok");
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
