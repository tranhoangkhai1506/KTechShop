import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ktechshop/constants/constants.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/models/products_model/product_models.dart';
import 'package:ktechshop/provider/app_provider.dart';
import 'package:provider/provider.dart';

class SingleCartItem extends StatefulWidget {
  const SingleCartItem({super.key, required this.singleProduct});
  final ProductModel singleProduct;
  @override
  State<SingleCartItem> createState() => _SingleCartItemState();
}

class _SingleCartItemState extends State<SingleCartItem> {
  int qty = 1;
  late double priceTotal;
  @override
  void initState() {
    qty = widget.singleProduct.quantity ?? 1;
    priceTotal = widget.singleProduct.price;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Container(
      margin: EdgeInsets.only(bottom: kDefaultPadding),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kDefaultPadding),
          border: Border.all(color: Colors.black54, width: 1.5)),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blueGrey.withOpacity(0.5),
              height: 140,
              child: Image.network(widget.singleProduct.image),
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 140,
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Stack(alignment: Alignment.bottomRight, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.singleProduct.name,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                              )),
                          Row(
                            children: [
                              CupertinoButton(
                                onPressed: () {
                                  if (qty > 0) {
                                    setState(() {
                                      qty--;
                                      priceTotal =
                                          widget.singleProduct.price * qty;
                                    });
                                  }
                                },
                                padding: EdgeInsets.zero,
                                child: CircleAvatar(
                                  maxRadius: 15,
                                  child: Icon(Icons.remove),
                                ),
                              ),
                              Text(
                                qty.toString(),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              CupertinoButton(
                                onPressed: () {
                                  setState(() {
                                    qty++;
                                    priceTotal =
                                        widget.singleProduct.price * qty;
                                  });
                                },
                                padding: EdgeInsets.zero,
                                child: CircleAvatar(
                                  maxRadius: 15,
                                  child: Icon(Icons.add),
                                ),
                              ),
                            ],
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              if (!appProvider.getFavouriteProductList
                                  .contains(widget.singleProduct)) {
                                appProvider
                                    .addFavouriteProduct(widget.singleProduct);
                                showMessage("Added to Favourites");
                              } else {
                                appProvider.removeFavouriteProduct(
                                    widget.singleProduct);
                                showMessage("Removed from Favourites");
                              }
                            },
                            child: Text(
                                appProvider.getFavouriteProductList
                                        .contains(widget.singleProduct)
                                    ? "Remove to wishlist"
                                    : "Add to wishlist",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),
                      Text(qty > 0 ? '\$${priceTotal.toString()}' : '\$${0.0}',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      appProvider.removeCartProduct(widget.singleProduct);
                      showMessage("Removed from Cart");
                    },
                    child: CircleAvatar(
                      maxRadius: 15,
                      child: Icon(Icons.delete),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
