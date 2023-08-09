import 'package:flutter/material.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/provider/app_provider.dart';
import 'package:ktechshop/screens/favourite_screen/widgets/single_favourite.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('Favourites',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
      body: appProvider.getFavouriteProductList.isEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Center(
                  child: Column(
                children: [
                  Image.network(
                      "https://happybox.co.za/cdn/shop/products/Empty_Heart-removebg-preview.png?v=1661018359&width=416",
                      height: 200,
                      width: 300),
                  Text('Your Favourite List is empty',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))
                ],
              )),
            )
          : Padding(
              padding: EdgeInsets.only(bottom: 60),
              child: ListView.builder(
                  padding: EdgeInsets.all(kDefaultPadding),
                  itemCount: appProvider.getFavouriteProductList.length,
                  itemBuilder: (ctx, index) {
                    return SingleFavouriteItem(
                      singleProduct: appProvider.getFavouriteProductList[index],
                    );
                  }),
            ),
    );
  }
}
