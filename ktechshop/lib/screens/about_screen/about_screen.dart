import 'package:flutter/material.dart';
import 'package:ktechshop/constants/assets_images.dart';
import 'package:ktechshop/constants/dismension_constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('About Me',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
      body: Center(
          child: Column(
        children: [
          SizedBox(
              height: 200,
              width: 300,
              child: Image.asset(AssetsImages.instance.ktechLogo)),
          Text("K-Tech",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(
            height: kDefaultPadding,
          ),
          Text("Owner: Kaaka",
              style: TextStyle(fontSize: 20, color: Colors.black)),
        ],
      )),
    );
  }
}
