// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/constants/routes.dart';
import 'package:ktechshop/provider/app_provider.dart';
import 'package:ktechshop/widgets/primary_button/primary_button.dart';
import 'package:provider/provider.dart';
import 'package:ktechshop/models/products_model/product_models.dart';
import '../../models/user_model/user_model.dart';
import '../check_out/check_out.dart';

class SingleCheckCurrentLocationScreen extends StatefulWidget {
  final ProductModel product;
  const SingleCheckCurrentLocationScreen({super.key, required this.product});

  @override
  State<SingleCheckCurrentLocationScreen> createState() =>
      _SingleCheckCurrentLocationScreen();
}

class _SingleCheckCurrentLocationScreen
    extends State<SingleCheckCurrentLocationScreen> {
  String _currentAddress = "Loading...";
  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInfoFirebase();
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

  int groupValue = 2;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    TextEditingController address = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Shipping Address",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kDefaultPadding),
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 2.0),
                ),
                child: Row(
                  children: [
                    Radio(
                        value: 1,
                        groupValue: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value!;
                          });
                        }),
                    Icon(Icons.location_on),
                    SizedBox(
                      width: kDefaultPadding,
                    ),
                    // ignore: avoid_unnecessary_containers
                    SizedBox(
                      height: 60,
                      width: 250,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Text(
                                // ignore: unnecessary_string_interpolations
                                "Vị trí hiện tại",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              Text(
                                // ignore: unnecessary_string_interpolations
                                "$_currentAddress",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kDefaultPadding),
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 2.0),
                ),
                child: Row(
                  children: [
                    Radio(
                        value: 2,
                        groupValue: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value!;
                          });
                        }),
                    Icon(Icons.paypal_rounded),
                    SizedBox(
                      height: 60,
                      width: 250,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Text(
                                // ignore: unnecessary_string_interpolations
                                "Vị trí đã lưu",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              Text(
                                // ignore: unnecessary_string_interpolations
                                "${appProvider.getUserInformation.address}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kDefaultPadding),
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 2.0),
                ),
                child: Row(
                  children: [
                    Radio(
                        value: 3,
                        groupValue: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value!;
                          });
                        }),
                    Icon(Icons.location_on),
                    SizedBox(
                      width: kDefaultPadding,
                    ),
                    // ignore: avoid_unnecessary_containers
                    SizedBox(
                      height: 100,
                      width: 250,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Text(
                                // ignore: unnecessary_string_interpolations
                                "Nhập vị trí",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              TextFormField(
                                controller: address,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          kDefaultPadding),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          kDefaultPadding),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          kDefaultPadding),
                                    ),
                                    hintText: appProvider.getUserInformation
                                                    .address ==
                                                "null" ||
                                            appProvider.getUserInformation
                                                    .address ==
                                                null
                                        ? _currentAddress
                                        : appProvider
                                            .getUserInformation.address),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: kMediumPadding,
              ),
              PrimaryButton(
                  onPressed: () async {
                    if (groupValue == 1) {
                      try {
                        UserModel userModel = appProvider.getUserInformation
                            .copyWith(
                                name: appProvider.getUserInformation.name,
                                address: _currentAddress,
                                phone: appProvider.getUserInformation.phone);
                        appProvider.updateAddressUserInforFirebase(
                            context, userModel);
                      } on Exception catch (e) {
                        print(e);
                        // TODO
                      }
                      ProductModel productModel = widget.product.copyWith();
                      Routes.instance.push(
                          widget: CheckOut(singleProduct: productModel),
                          context: context);
                    } else if (groupValue == 2) {
                      ProductModel productModel = widget.product.copyWith();
                      Routes.instance.push(
                          widget: CheckOut(singleProduct: productModel),
                          context: context);
                    } else {
                      try {
                        UserModel userModel = appProvider.getUserInformation
                            .copyWith(
                                name: appProvider.getUserInformation.name,
                                address: address.text.isNotEmpty
                                    ? address.text
                                    : _currentAddress,
                                phone: appProvider.getUserInformation.phone);
                        appProvider.updateAddressUserInforFirebase(
                            context, userModel);
                      } on Exception catch (e) {
                        print(e);
                        // TODO
                      }
                      ProductModel productModel = widget.product.copyWith();
                      Routes.instance.push(
                          widget: CheckOut(singleProduct: productModel),
                          context: context);
                    }
                  },
                  title: "Continues")
            ],
          ),
        ));
  }
}
