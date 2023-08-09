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
  @override
  void initState() {
    qty = widget.singleProduct.quantity ?? 1;
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
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kDefaultPadding),
                  color: Colors.grey.withOpacity(0.5),
                ),
                height: 150,
                child: Image.network(widget.singleProduct.image),
              ),
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
                          FittedBox(
                            child: Text(widget.singleProduct.name,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Row(
                            children: [
                              CupertinoButton(
                                onPressed: () {
                                  if (qty > 0) {
                                    setState(() {
                                      qty--;
                                    });
                                    appProvider.updateQuantity(
                                        widget.singleProduct, qty);
                                  }
                                },
                                padding: EdgeInsets.zero,
                                child: CircleAvatar(
                                  maxRadius: 18,
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
                                  });

                                  appProvider.updateQuantity(
                                      widget.singleProduct, qty);
                                },
                                padding: EdgeInsets.zero,
                                child: CircleAvatar(
                                  maxRadius: 18,
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),
                      Text(
                          qty > 0
                              ? '\$${(qty * widget.singleProduct.price).toString()}'
                              : '\$${0.0}',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18,
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
                      maxRadius: 18,
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
