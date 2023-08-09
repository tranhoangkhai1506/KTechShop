import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ktechshop/constants/constants.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/models/products_model/product_models.dart';
import 'package:ktechshop/provider/app_provider.dart';
import 'package:provider/provider.dart';

class SingleFavouriteItem extends StatefulWidget {
  const SingleFavouriteItem({super.key, required this.singleProduct});
  final ProductModel singleProduct;
  @override
  State<SingleFavouriteItem> createState() => _SingleFavouriteItem();
}

class _SingleFavouriteItem extends State<SingleFavouriteItem> {
  @override
  Widget build(BuildContext context) {
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kDefaultPadding),
                color: Colors.grey.withOpacity(0.5),
              ),
              height: 150,
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
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  AppProvider appProvider =
                                      Provider.of<AppProvider>(context,
                                          listen: false);
                                  appProvider.removeFavouriteProduct(
                                      widget.singleProduct);
                                  showMessage("Removed from Wishlist");
                                },
                                child: Text('Remove to Wishlist',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 16,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                            width: 150,
                            child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      width: 2.0, color: Colors.blue),
                                ),
                                onPressed: () {
                                  AppProvider appProvider =
                                      Provider.of<AppProvider>(context,
                                          listen: false);
                                  ProductModel productModel = widget
                                      .singleProduct
                                      .copyWith(quantity: 1);
                                  appProvider.addCartProduct(productModel);
                                  showMessage("Added to Cart");
                                },
                                icon: Icon(
                                  Icons.shopping_cart,
                                  weight: 14,
                                ),
                                label: Text(
                                  'Add to cart',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Text('\$${widget.singleProduct.price.toString()}',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
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
