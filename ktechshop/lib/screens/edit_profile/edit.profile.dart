import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/models/user_model/user_model.dart';
import 'package:ktechshop/provider/app_provider.dart';
import 'package:ktechshop/widgets/primary_button/primary_button.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? image;

  void takePicture() async {
    XFile? value = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 40);
    if (value != null) {
      setState(() {
        image = File(value.path);
      });
    }
  }

  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Profile",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          children: [
            image == null
                ? CupertinoButton(
                    onPressed: () {
                      takePicture();
                    },
                    child:
                        CircleAvatar(radius: 50, child: Icon(Icons.camera_alt)),
                  )
                : CupertinoButton(
                    onPressed: () {
                      takePicture();
                    },
                    child: CircleAvatar(
                        radius: 50, backgroundImage: FileImage(image!)),
                  ),
            SizedBox(
              height: kDefaultPadding,
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
                  hintText: appProvider.getUserInformation.name),
            ),
            SizedBox(
              height: kMediumPadding,
            ),
            PrimaryButton(
                onPressed: () async {
                  UserModel userModel =
                      appProvider.getUserInformation.copyWith(name: name.text);
                  appProvider.updateUserInforFirebase(
                      context, userModel, image);
                },
                title: "Update")
          ],
        ));
  }
}
