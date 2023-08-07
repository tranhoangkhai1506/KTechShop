import 'package:flutter/material.dart';
import 'package:ktechshop/constants/dismension_constants.dart';

class TopTitles extends StatelessWidget {
  final String title, subTitle;
  const TopTitles({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: kMediumPadding,
        ),
        if (title == 'Login' || title == 'Create Account')
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios),
          ),
        SizedBox(
          height: kDefaultPadding,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 6,
        ),
        Text(subTitle, style: TextStyle(fontSize: 18))
      ],
    );
  }
}
