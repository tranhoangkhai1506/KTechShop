import 'package:flutter/material.dart';
import 'package:ktechshop/constants/dismension_constants.dart';

class PrimaryButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  const PrimaryButton(
      {super.key, required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kMediumPadding),
            color: Color.fromARGB(255, 10, 197, 239)),
        alignment: Alignment.center,
        child: Text(title, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
