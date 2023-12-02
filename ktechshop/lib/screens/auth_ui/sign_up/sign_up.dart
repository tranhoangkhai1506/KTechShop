import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/constants/routes.dart';
import 'package:ktechshop/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:ktechshop/screens/auth_ui/login/login.dart';
import 'package:ktechshop/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:ktechshop/widgets/primary_button/primary_button.dart';
import 'package:ktechshop/widgets/top_titles/top_titles.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isShowPassWord = true;
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.all(kDefaultPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopTitles(
                title: 'Create Account', subTitle: 'Welcome To K-Tech Shop'),
            SizedBox(
              height: kDefaultPadding * 1.5,
            ),
            TextFormField(
              controller: name,
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
                  hintText: 'Name',
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.grey,
                  )),
            ),
            SizedBox(
              height: kDefaultPadding,
            ),
            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
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
              controller: phone,
              keyboardType: TextInputType.phone,
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
                  hintText: 'Phone',
                  prefixIcon: Icon(
                    Icons.phone,
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
            SizedBox(
              height: kDefaultPadding * 1.5,
            ),
            PrimaryButton(
                onPressed: () async {
                  bool isVaildated = signUpValidation(
                      email.text, password.text, name.text, phone.text);
                  if (isVaildated) {
                    bool isLogined = await FirebaseAuthHelper.instance.signUp(
                        name.text,
                        email.text,
                        password.text,
                        phone.text,
                        context);
                    if (isLogined) {
                      // ignore: use_build_context_synchronously
                      Routes.instance
                          .push(widget: CustomBottomBar(), context: context);
                    }
                  }
                },
                title: 'Create an account'),
            SizedBox(
              height: kDefaultPadding * 1.5,
            ),
            Center(child: Text('I have already an account!')),
            Center(
                child: CupertinoButton(
                    onPressed: () {
                      Routes.instance.push(widget: Login(), context: context);
                    },
                    child: Text('Login',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor))))
          ],
        ),
      ),
    ));
  }
}
