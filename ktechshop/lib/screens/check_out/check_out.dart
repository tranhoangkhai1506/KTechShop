import 'package:flutter/material.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/constants/routes.dart';
import 'package:ktechshop/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:ktechshop/models/products_model/product_models.dart';
import 'package:ktechshop/provider/app_provider.dart';
import 'package:ktechshop/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:ktechshop/widgets/primary_button/primary_button.dart';
import 'package:provider/provider.dart';

class CheckOut extends StatefulWidget {
  final ProductModel singleProduct;
  const CheckOut({super.key, required this.singleProduct});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  int groupValue = 2;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Check Out",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            children: [
              SizedBox(
                height: kDefaultPadding,
              ),
              Container(
                height: 80,
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
                    Icon(Icons.money),
                    SizedBox(
                      width: kDefaultPadding,
                    ),
                    Text(
                      "Cash on Delivery",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              Container(
                height: 80,
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
                      width: kDefaultPadding,
                    ),
                    Text(
                      "Pay Online",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: kMediumPadding,
              ),
              PrimaryButton(
                  onPressed: () async {
                    appProvider.clearBuyProduct();
                    appProvider.addBuyProduct(widget.singleProduct);

                    bool value = await FirebaseFirestoreHelper.instance
                        .uploadOrderProductFirebase(
                            appProvider.getBuyProductList,
                            context,
                            groupValue == 1 ? "Cash on delivery" : "Paid");
                    if (value) {
                      Future.delayed(Duration(seconds: 2), () {
                        Routes.instance
                            .push(widget: CustomBottomBar(), context: context);
                      });
                    }
                  },
                  title: "Continues")
            ],
          ),
        ));
  }
}
