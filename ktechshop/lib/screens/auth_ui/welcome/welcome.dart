import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ktechshop/constants/assets_images.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/constants/routes.dart';
import 'package:ktechshop/google_auth/auth_service.dart';
import 'package:ktechshop/screens/auth_ui/login/login.dart';
import 'package:ktechshop/screens/auth_ui/sign_up/sign_up.dart';
import 'package:ktechshop/widgets/primary_button/primary_button.dart';
import 'package:ktechshop/widgets/top_titles/top_titles.dart';

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
                  onPressed: () {},
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
                  onPressed:  () async {
                    await AuthService().signInWithGoogle();
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
