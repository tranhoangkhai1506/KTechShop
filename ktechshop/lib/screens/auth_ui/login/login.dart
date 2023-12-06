import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ktechshop/constants/constants.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/constants/routes.dart';
import 'package:ktechshop/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:ktechshop/screens/auth_ui/forgot_pw/forgot_pw_screen.dart';
import 'package:ktechshop/screens/auth_ui/sign_up/sign_up.dart';
import 'package:ktechshop/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:ktechshop/widgets/primary_button/primary_button.dart';
import 'package:ktechshop/widgets/top_titles/top_titles.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isShowPassWord = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.all(kDefaultPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopTitles(title: 'Login', subTitle: 'Welcome Back To K-Tech Shop'),
            SizedBox(
              height: kDefaultPadding * 1.5,
            ),
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kDefaultPadding),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kDefaultPadding),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kDefaultPadding),
                  ),
                  hintText: 'E-mail',
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.grey,
                  )),
            ),
            SizedBox(
              height: kDefaultPadding,
            ),
            TextFormField(
              controller: password,
              obscureText: isShowPassWord,
              decoration: InputDecoration(
                  hintText: 'Password',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kDefaultPadding),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kDefaultPadding),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kDefaultPadding),
                  ),
                  prefixIcon: Icon(
                    Icons.password,
                    color: Colors.grey,
                  ),
                  suffixIcon: CupertinoButton(
                    onPressed: () {
                      setState(() {
                        isShowPassWord = !isShowPassWord;
                      });
                    },
                    padding: EdgeInsets.zero,
                    child: Icon(
                      Icons.visibility,
                      color: Colors.grey,
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                      onPressed: () {
                        Routes.instance.push(
                            widget: ForgotPasswordScreen(), context: context);
                      },
                      child: Text('Forgot password?',
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor))),
                ],
              ),
            ),
            PrimaryButton(
                onPressed: () async {
                  bool isVaildated = loginValidation(email.text, password.text);
                  if (isVaildated) {
                    bool isLogined = await FirebaseAuthHelper.instance
                        .login(email.text, password.text, context);
                    if (isLogined) {
                      // ignore: use_build_context_synchronously
                      Routes.instance
                          .push(widget: CustomBottomBar(), context: context);
                    } else {
                      // ignore: use_build_context_synchronously
                      showMessage("Login failed");
                    }
                  }
                },
                title: 'Login'),
            SizedBox(
              height: kDefaultPadding * 1.5,
            ),
            Center(child: Text('Don`t not have an account?')),
            Center(
                child: CupertinoButton(
                    onPressed: () {
                      Routes.instance.push(widget: SignUp(), context: context);
                    },
                    child: Text('Create an account',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor))))
          ],
        ),
      ),
    ));
  }
}
