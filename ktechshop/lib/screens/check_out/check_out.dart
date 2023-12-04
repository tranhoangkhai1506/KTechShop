import 'package:flutter/material.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/constants/routes.dart';
import 'package:ktechshop/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:ktechshop/models/products_model/product_models.dart';
import 'package:ktechshop/provider/app_provider.dart';
import 'package:ktechshop/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:ktechshop/send_email/send_email.dart';
import 'package:ktechshop/stripe_helper/striper_helper.dart';
import 'package:ktechshop/widgets/primary_button/primary_button.dart';
import 'package:provider/provider.dart';

class CheckOut extends StatefulWidget {
  final ProductModel singleProduct;
  const CheckOut({super.key, required this.singleProduct});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

String orderDetail(List<ProductModel> orderProducts) {
  String orderDetails = "";
  double totalPrice = 0;

  for (ProductModel product in orderProducts) {
    orderDetails += "Tên Sản Phẩm: ${product.name}.\n\n"
        "Số lượng: ${product.quantity}.\n\n"
        "Đơn giá: ${product.price}.\n";
    totalPrice += (product.price * product.quantity!).round();
  }

  return "Thông tin đơn hàng:\n\n$orderDetails\n"
      "Tổng Tiền:  $totalPrice dollar.\n\n ";
}

class _CheckOutState extends State<CheckOut> {
  int groupValue = 2;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    List<ProductModel> productModel = appProvider.getBuyProductList;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "Check Out",
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

                    if (groupValue == 1) {
                      bool value = await FirebaseFirestoreHelper.instance
                          .uploadOrderProductFirebase(
                              appProvider.getBuyProductList,
                              context,
                              "Cash on delivery",
                              appProvider.getUserInformation.address!);
                      if (value) {
                        await EmailSender.sendEmail(
                          name: appProvider.getUserInformation.name,
                          email: appProvider.getUserInformation.email,
                          subject: "KQH SHOP",
                          message: "${orderDetail(productModel)}"
                              "Địa chỉ giao hàng: ${appProvider.getUserInformation.address}.\n\n"
                              "Cảm ơn bạn đã mua hàng.",
                        );
                        Future.delayed(Duration(seconds: 1), () {
                          Routes.instance.push(
                              widget: CustomBottomBar(), context: context);
                        });
                        appProvider.clearBuyProduct();
                      }
                    } else {
                      await EmailSender.sendEmail(
                          name: appProvider.getUserInformation.name,
                          email: appProvider.getUserInformation.email,
                          subject: "KQH SHOP",
                          message: "${orderDetail(productModel)}"
                              "Địa chỉ giao hàng: ${appProvider.getUserInformation.address}.\n\n"
                              "Cảm ơn bạn đã mua hàng.",
                        );
                      int value = double.parse(
                              appProvider.totalPriceBuyProduct().toString())
                          .round()
                          .toInt();
                      String totalPrice = (value * 100).toString();
                      // ignore: use_build_context_synchronously
                      await StripHelper.instence
                          .makePayment(totalPrice, context);
                    }
                  },
                  title: "Continue")
            ],
          ),
        ));
  }
}
