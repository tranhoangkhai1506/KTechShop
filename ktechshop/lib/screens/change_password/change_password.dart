import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ktechshop/constants/constants.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:ktechshop/widgets/primary_button/primary_button.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    bool isShowPassWord = true;
    //bool isShowConfirmPassWord = true;
    TextEditingController password = TextEditingController();
    TextEditingController confirmPassword = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Change Password",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: ListView(
          children: [
            TextFormField(
              controller: password,
              obscureText: isShowPassWord,
              decoration: InputDecoration(
                  hintText: 'New Password',
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
              height: kDefaultPadding,
            ),
            TextFormField(
              controller: confirmPassword,
              //obscureText: isShowConfirmPassWord,
              decoration: InputDecoration(
                  hintText: 'Confirm Password',
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
                      // setState(() {
                      //   isShowConfirmPassWord = !isShowConfirmPassWord;
                      // });
                    },
                    padding: EdgeInsets.zero,
                    child: Icon(
                      Icons.visibility,
                      color: Colors.grey,
                    ),
                  )),
            ),
            SizedBox(
              height: kMediumPadding,
            ),
            PrimaryButton(
                onPressed: () async {
                  if (password.text.isEmpty) {
                    showMessage("Password not null");
                  } else if (confirmPassword.text.isEmpty) {
                    showMessage("Confirm password not null");
                  } else if (confirmPassword.text == password.text) {
                    FirebaseAuthHelper.instance
                        .changePassword(password.text, context);
                  } else {
                    showMessage("Confirm password not match");
                  }
                },
                title: "Update")
          ],
        ),
      ),
    );
  }
}
