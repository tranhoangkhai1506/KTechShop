import 'package:flutter/material.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/provider/app_provider.dart';
import 'package:ktechshop/screens/cart_screen/widgets/single_cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int qty = 1;
  double priceTotal = 0;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('Your Cart',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
      body: appProvider.getCartProductList.isEmpty
          ? Center(child: Text('Empty'))
          : Padding(
              padding: EdgeInsets.only(bottom: 60),
              child: ListView.builder(
                  padding: EdgeInsets.all(kDefaultPadding),
                  itemCount: appProvider.getCartProductList.length,
                  itemBuilder: (ctx, index) {
                    return SingleCartItem(
                      singleProduct: appProvider.getCartProductList[index],
                    );
                  }),
            ),
    );
  }
}
