import 'package:flutter/material.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/widgets/top_titles/top_titles.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.all(kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopTitles(title: 'Login', subTitle: 'Welcome Back To K-Tech Shop'),
          SizedBox(
            height: kDefaultPadding,
          ),
          TextFormField(
            decoration: InputDecoration(
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
            obscureText: true,
            decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(
                  Icons.password,
                  color: Colors.grey,
                ),
                suffixIcon: Icon(
                  Icons.visibility,
                  color: Colors.grey,
                )),
          )
        ],
      ),
    ));
  }
}
