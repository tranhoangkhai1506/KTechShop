// ignore_for_file: prefer_if_null_operators

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
  String _currentAddress = "Loading...";

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  Future<void> _getCurrentLocation() async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    String address = await appProvider.getAddressFromCoordinates();
    setState(() {
      _currentAddress = address;
    });
  }

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
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "Profile",
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
            TextFormField(
              controller: address,
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
                  hintText: appProvider.getUserInformation.address == "null" ||
                          appProvider.getUserInformation.address == null
                      ? _currentAddress
                      : appProvider.getUserInformation.address),
            ),
            SizedBox(
              height: kMediumPadding,
            ),
            TextFormField(
              controller: phone,
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
                  hintText: appProvider.getUserInformation.phone),
            ),
            SizedBox(
              height: kMediumPadding,
            ),
            PrimaryButton(
                onPressed: () async {
                  UserModel userModel = appProvider.getUserInformation.copyWith(
                      name: name.text.isEmpty
                          ? appProvider.getUserInformation.name
                          : name.text,
                      address: address.text.isNotEmpty
                          ? address.text
                          : _currentAddress,
                      phone: phone.text.isEmpty
                          ? appProvider.getUserInformation.phone
                          : phone.text);
                  appProvider.updateUserInforFirebase(
                      context, userModel, image);
                },
                title: "Update")
          ],
        ));
  }
}
