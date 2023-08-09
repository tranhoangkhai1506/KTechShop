import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ktechshop/constants/constants.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/constants/routes.dart';
import 'package:ktechshop/models/products_model/product_models.dart';
import 'package:ktechshop/provider/app_provider.dart';
import 'package:ktechshop/screens/check_out/check_out.dart';
import 'package:ktechshop/screens/cart_screen/cart_screen.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel singleProduct;
  const ProductDetails({super.key, required this.singleProduct});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int qty = 1;
  double priceTotal = 0;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Routes.instance.push(widget: CartScreen(), context: context);
                },
                icon: Icon(Icons.shopping_cart))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(kDefaultPadding),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  widget.singleProduct.image,
                  height: 250,
                  width: 350,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.singleProduct.name,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.singleProduct.isFavourite =
                              !widget.singleProduct.isFavourite;
                        });
                        if (widget.singleProduct.isFavourite) {
                          appProvider.addFavouriteProduct(widget.singleProduct);
                          showMessage("Added to Favourites");
                        } else {
                          appProvider
                              .removeFavouriteProduct(widget.singleProduct);
                          showMessage("Removed from Favourites");
                        }
                      },
                      icon: Icon(appProvider.getFavouriteProductList
                              .contains(widget.singleProduct)
                          ? Icons.favorite
                          : Icons.favorite_border),
                    )
                  ],
                ),
                Text(
                  widget.singleProduct.description,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: kMediumPadding,
                ),
                Row(
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        if (qty > 0) {
                          setState(() {
                            qty--;
                            priceTotal = widget.singleProduct.price * qty;
                          });
                        }
                      },
                      padding: EdgeInsets.zero,
                      child: CircleAvatar(
                        child: Icon(Icons.remove),
                      ),
                    ),
                    SizedBox(
                      width: kDefaultPadding,
                    ),
                    Text(
                      qty.toString(),
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: kDefaultPadding,
                    ),
                    CupertinoButton(
                      onPressed: () {
                        setState(() {
                          qty++;
                          priceTotal = widget.singleProduct.price * qty;
                        });
                      },
                      padding: EdgeInsets.zero,
                      child: CircleAvatar(
                        child: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: kDefaultPadding,
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 180,
                      child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                width: 2.0,
                                color: Theme.of(context).primaryColor),
                          ),
                          onPressed: () {
                            ProductModel productModel =
                                widget.singleProduct.copyWith(quantity: qty);
                            appProvider.addCartProduct(productModel);
                            showMessage("Added to Cart");
                          },
                          icon: Icon(
                            Icons.shopping_cart,
                            weight: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                          label: Text(
                            'ADD TO CART',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColor,
                            ),
                          )),
                    ),
                    SizedBox(
                      width: kDefaultPadding,
                    ),
                    SizedBox(
                      height: 50,
                      width: 170,
                      child: ElevatedButton.icon(
                          onPressed: () {
                            ProductModel productModel =
                                widget.singleProduct.copyWith(quantity: qty);
                            Routes.instance.push(
                                widget: CheckOut(singleProduct: productModel),
                                context: context);
                          },
                          icon: Icon(
                            Icons.payment,
                            weight: 20,
                          ),
                          label: Text(
                            'BUY NOW',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
