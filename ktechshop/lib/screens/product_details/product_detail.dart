import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/models/products_model/product_models.dart';

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
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.singleProduct.image,
                height: 200,
                width: 300,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.singleProduct.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.singleProduct.isFavourite =
                            !widget.singleProduct.isFavourite;
                      });
                    },
                    icon: Icon(widget.singleProduct.isFavourite
                        ? Icons.favorite
                        : Icons.favorite_border),
                  )
                ],
              ),
              Text(
                widget.singleProduct.description,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: kDefaultPadding,
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: kDefaultPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                            qty == 1
                                ? "\$${widget.singleProduct.price}"
                                : "\$${priceTotal.toString()}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.shopping_cart),
                      label: Text('ADD TO CART')),
                  SizedBox(
                    width: kDefaultPadding,
                  ),
                  SizedBox(
                    height: 36,
                    width: 170,
                    child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.payment),
                        label: Text('BUY')),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
