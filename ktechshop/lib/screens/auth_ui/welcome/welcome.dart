import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ktechshop/constants/assets_images.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/constants/routes.dart';
import 'package:ktechshop/screens/auth_ui/login/login.dart';
import 'package:ktechshop/screens/auth_ui/sign_up/sign_up.dart';
import 'package:ktechshop/widgets/primary_button/primary_button.dart';
import 'package:ktechshop/widgets/top_titles/top_titles.dart';

import '../../../constants/constants.dart';
import '../../../firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import '../../custom_bottom_bar/custom_bottom_bar.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopTitles(
                title: 'Welcome', subTitle: 'Buy any item from using app'),
            Center(child: Image.asset(AssetsImages.instance.welcomeImage)),
            SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                  onPressed: () async {
                    bool isLogined =
                        await FirebaseAuthHelper.instance.signInWithFacebook();
                    if (isLogined) {
                      // ignore: use_build_context_synchronously
                      Routes.instance
                          .push(widget: CustomBottomBar(), context: context);
                    } else {
                      showMessage("Login failed");
                    }
                  },
                  padding: EdgeInsets.zero,
                  child: Icon(
                    Icons.facebook,
                    size: 38,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                CupertinoButton(
                  onPressed: () async {
                    bool isLogined =
                        await FirebaseAuthHelper.instance.signInWithGoogle();
                    if (isLogined) {
                      // ignore: use_build_context_synchronously
                      Routes.instance
                          .push(widget: CustomBottomBar(), context: context);
                    } else {
                      showMessage("Login failed");
                    }
                  },
                  // padding: EdgeInsets.zero,
                  child: Image.asset(
                    AssetsImages.instance.googleLogo,
                    scale: 7,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            PrimaryButton(
              onPressed: () {
                Routes.instance.push(widget: Login(), context: context);
              },
              title: 'Login',
            ),
            SizedBox(
              height: 12,
            ),
            PrimaryButton(
                onPressed: () {
                  Routes.instance.push(widget: SignUp(), context: context);
                },
                title: 'Sign Up'),
          ],
        ),
      ),
    );
  }
}
