import 'package:flutter/material.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:ktechshop/models/order_model/order_model.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Orders",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
          future: FirebaseFirestoreHelper.instance.getUserOrder(),
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
                child: Text("No Order Found"),
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
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: EdgeInsets.all(kDefaultPadding / 2),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(kDefaultPadding),
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                height: 100,
                                width: 100,
                                child:
                                    Image.network(orderModel.products[0].image),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(kDefaultPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(orderModel.products[0].name,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 13,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold)),
                                  orderModel.products.length > 1
                                      ? SizedBox.fromSize()
                                      : Column(
                                          children: [
                                            SizedBox(
                                              height: kDefaultPadding,
                                            ),
                                            Text(
                                                "Quantity: ${orderModel.products[0].quantity.toString()}",
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                          ],
                                        ),
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
                                  Text("Order status: ${orderModel.status}",
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 13,
                                        overflow: TextOverflow.ellipsis,
                                      )),
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
