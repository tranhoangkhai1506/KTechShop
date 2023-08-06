import 'package:flutter/material.dart';
import 'package:ktechshop/constants/constants.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/constants/routes.dart';
import 'package:ktechshop/provider/app_provider.dart';
import 'package:ktechshop/screens/cart_item_checkout/cart_item_checkout.dart';
import 'package:ktechshop/screens/cart_screen/widgets/single_cart_item.dart';
import 'package:ktechshop/widgets/primary_button/primary_button.dart';
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
      bottomNavigationBar: SizedBox(
        height: 180,
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$${appProvider.totalPrice().toString()}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: kMediumPadding,
              ),
              PrimaryButton(
                  onPressed: () {
                    appProvider.clearBuyProduct();
                    appProvider.addBuyProductCart();
                    appProvider.clearCart();
                    if (appProvider.getBuyProductList.isEmpty) {
                      showMessage("Cart is empty");
                    } else {
                      Routes.instance
                          .push(widget: CartItemCheckOut(), context: context);
                    }
                  },
                  title: "Checkout"),
            ],
          ),
        ),
      ),
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
          : ListView.builder(
              padding: EdgeInsets.all(kDefaultPadding),
              itemCount: appProvider.getCartProductList.length,
              itemBuilder: (ctx, index) {
                return SingleCartItem(
                  singleProduct: appProvider.getCartProductList[index],
                );
              }),
    );
  }
}
