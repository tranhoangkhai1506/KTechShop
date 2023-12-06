import 'package:flutter/material.dart';
import 'package:ktechshop/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:ktechshop/widgets/primary_button/primary_button.dart';

import '../../../constants/dismension_constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController email = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            Text(
              "Enter your Email and we will send you a password reset link: ",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: kDefaultPadding,
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
            PrimaryButton(
                onPressed: () async {
                  await FirebaseAuthHelper.instance
                      .sendLinkPasswordReset(email.text, context);
                },
                title: 'Reset Password'),
          ],
        ),
      ),
    );
  }
}
