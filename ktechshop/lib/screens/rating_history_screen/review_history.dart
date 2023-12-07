import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/constants/routes.dart';
import 'package:ktechshop/models/order_model/order_model.dart';
import 'package:ktechshop/provider/app_provider.dart';
import 'package:provider/provider.dart';

import '../../firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import '../rating_screen/rating_screen.dart';

class ReviewedHistoryScreen extends StatefulWidget {
  const ReviewedHistoryScreen({super.key});

  @override
  State<ReviewedHistoryScreen> createState() => _ReviewedHistoryScreenState();
}

class _ReviewedHistoryScreenState extends State<ReviewedHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Review History",
        ),
      ),
      body: FutureBuilder(
          future: FirebaseFirestoreHelper.instance.getUserOrderCompleted(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.isEmpty ||
                snapshot.data == null ||
                !snapshot.hasData) {
              return Center(
                child: Text("No Review Found"),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: kMediumPadding * 2),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                padding: EdgeInsets.all(kDefaultPadding),
                itemBuilder: (context, index) {
                  OrderModel orderModel = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: kDefaultPadding),
                    child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        collapsedShape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey, width: 2)),
                        title: orderModel.products.length > 1
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      padding:
                                          EdgeInsets.all(kDefaultPadding / 2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            kDefaultPadding),
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                      height: 100,
                                      width: 100,
                                      child: Image.network(
                                          orderModel.products[0].image),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.all(kDefaultPadding),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(orderModel.products[0].name,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 13,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: kDefaultPadding,
                                        ),
                                        Text(
                                            "Date Order: ${orderModel.dateOrder}",
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 13,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                        SizedBox(
                                          height: kDefaultPadding,
                                        ),
                                        Text(
                                            "Total price: \$${orderModel.totalPrice.toString()}",
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 13,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                        SizedBox(
                                          height: kDefaultPadding,
                                        ),
                                        Text(
                                            "Status Review: ${orderModel.statusReview}",
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 12,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                        SizedBox(
                                          height: kDefaultPadding,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      padding:
                                          EdgeInsets.all(kDefaultPadding / 2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            kDefaultPadding),
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                      height: 100,
                                      width: 100,
                                      child: Image.network(
                                          orderModel.products[0].image),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.all(kDefaultPadding),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(orderModel.products[0].name,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 13,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: kDefaultPadding,
                                        ),
                                        Text(
                                            "Date Order: ${orderModel.dateOrder}",
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 13,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                        SizedBox(
                                          height: kDefaultPadding,
                                        ),
                                        Text(
                                            "Total price: \$${orderModel.totalPrice.toString()}",
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 13,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                        SizedBox(
                                          height: kDefaultPadding,
                                        ),
                                        Text(
                                            "Status Review: ${orderModel.statusReview}",
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 12,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                        SizedBox(
                                          height: kDefaultPadding,
                                        ),
                                        ElevatedButton(
                                            onPressed: () async {
                                              Routes.instance.push(
                                                  widget: Rating(
                                                    userId: appProvider
                                                        .getUserInformation.id,
                                                    productId: orderModel
                                                        .products[0].id,
                                                    orderId: orderModel.orderid,
                                                  ),
                                                  context: context);
                                              setState(() {});
                                            },
                                            child: Text("Review"))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                        children: orderModel.products.length > 1
                            ? [
                                Text("Details",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Divider(color: Colors.black),
                                ...orderModel.products.map((singleProduct) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            padding: EdgeInsets.all(
                                                kDefaultPadding / 2),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      kDefaultPadding),
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                            ),
                                            height: 80,
                                            width: 80,
                                            child: Image.network(
                                                singleProduct.image),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(
                                              kDefaultPadding),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(singleProduct.name,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: kDefaultPadding,
                                              ),
                                              Text(
                                                  "Quantity: ${singleProduct.quantity.toString()}",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                              SizedBox(
                                                height: kDefaultPadding,
                                              ),
                                              Text(
                                                  "Price: \$${singleProduct.price.toString()}",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    Routes.instance.push(
                                                        widget: Rating(
                                                            userId: appProvider
                                                                .getUserInformation
                                                                .id,
                                                            productId:
                                                                singleProduct
                                                                    .id,
                                                            orderId: orderModel
                                                                .orderid),
                                                        context: context);
                                                    setState(() {});
                                                  },
                                                  child: Text("Review"))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList()
                              ]
                            : []),
                  );
                },
              ),
            );
          }),
    );
  }
}
