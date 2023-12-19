import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/constants/routes.dart';
import 'package:ktechshop/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:ktechshop/models/categories_model/categories_model.dart';
import 'package:ktechshop/models/products_model/product_models.dart';
import 'package:ktechshop/provider/app_provider.dart';
import 'package:ktechshop/screens/category_view/category_view.dart';
import 'package:ktechshop/screens/chatbot_screen/chat_screen.dart';
import 'package:ktechshop/screens/product_details/product_detail.dart';
import 'package:ktechshop/widgets/top_titles/top_titles.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoriesModel> categoriesList = [];
  List<ProductModel> productModelList = [];
  List<ProductModel> productSuggestionByRatedScoreList = [];
  List<ProductModel> productSuggestionByCollaborativeFiltering = [];
  List<String> suggestions = [];
  bool isLoading = false;
  String _currentAddress = "Loading...";
  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInfoFirebase();
    _getCurrentLocation();
    getCategoryList();
    super.initState();
  }

  void getCategoryList() async {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestoreHelper.instance.updateTokenFromFirebase();
    categoriesList = await FirebaseFirestoreHelper.instance.getCategory();
    productModelList = await FirebaseFirestoreHelper.instance.getBestProducts();
    //
    productSuggestionByRatedScoreList = await FirebaseFirestoreHelper.instance
        .getProductSuggestionByRatedScore();
    //productSuggestionByCollaborativeFiltering = await FirebaseFirestoreHelper
    //.instance
    //.suggestProductsForUser(FirebaseAuth.instance.currentUser!.uid);
    productModelList.shuffle();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _getCurrentLocation() async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    String address = await appProvider.getAddressFromCoordinates();
    setState(() {
      _currentAddress = address;
    });
  }

  TextEditingController search = TextEditingController();
  List<ProductModel> seacrhList = [];
  void searchProducts(String value) {
    seacrhList = productModelList
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {});
  }

  void updateSearchSuggestions(String value) {
    setState(() {
      suggestions = productModelList
          .where((element) =>
              element.name.toLowerCase().contains(value.toLowerCase()))
          .map((element) => element.name)
          .toList();
    });
  }

  ThemeData lightTheme = ThemeData.light().copyWith(
    textTheme: TextTheme(
      // ignore: deprecated_member_use
      bodyText1: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
  );

  ThemeData darkTheme = ThemeData.dark().copyWith(
    textTheme: TextTheme(
      // ignore: deprecated_member_use
      bodyText1: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
    scaffoldBackgroundColor: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    return Scaffold(
      body: isLoading
          ? Center(
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(kDefaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: const [
                                TopTitles(
                                  title: 'KQH Shop',
                                  subTitle: '',
                                ),
                              ],
                            ),
                            Center(
                              child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color:
                                      const Color.fromARGB(255, 141, 192, 234),
                                ),
                                child: IconButton(
                                  color: Colors.black,
                                  icon: Icon(Icons.support_agent_outlined),
                                  onPressed: () {
                                    setState(() {});
                                    Navigator.of(context, rootNavigator: true)
                                        .pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return ChatScreen();
                                        },
                                      ),
                                      (_) => false,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.location_on,
                                  size: 40,
                                  color: Colors.blue,
                                )),
                            Expanded(
                              flex: 5,
                              child: SizedBox(
                                child: Theme(
                                  data: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? darkTheme
                                      : lightTheme,
                                  child: Consumer<AppProvider>(
                                    builder: (context, appProvider, child) {
                                      return Text(
                                        "${_currentAddress}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: kDefaultPadding,
                        ),
                        TextFormField(
                          controller: search,
                          onChanged: (String value) {
                            searchProducts(value);
                            if (value.isNotEmpty) {
                              updateSearchSuggestions(value);
                            } else {
                              setState(() {
                                suggestions.clear();
                              });
                            }
                          },
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(kDefaultPadding),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(kDefaultPadding),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(kDefaultPadding),
                              ),
                              hintText: 'Typing to search...',
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                              )),
                        ),
                        suggestions.isNotEmpty
                            ? SizedBox(
                                height: 200,
                                child: Card(
                                  elevation: 4.0,
                                  child: ListView.builder(
                                    itemCount: suggestions.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(suggestions[index]),
                                        onTap: () {
                                          search.text = suggestions[index];
                                          searchProducts(suggestions[index]);
                                          setState(() {
                                            suggestions.clear();
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: kDefaultPadding,
                        left: kDefaultPadding,
                        right: kDefaultPadding),
                    child: Text(
                      'Categories',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  categoriesList.isEmpty
                      ? Center(
                          child: Text('Categories is empty'),
                        )
                      : SingleChildScrollView(
                          padding: EdgeInsets.only(left: kDefaultPadding),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: categoriesList
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.all(
                                            kDefaultPadding / 2),
                                        child: CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            Routes.instance.push(
                                                widget: CategoryView(
                                                  categoryModel: e,
                                                ),
                                                context: context);
                                          },
                                          child: Card(
                                            color: Colors.white,
                                            elevation: 6.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      kDefaultPadding),
                                            ),
                                            child: SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: Image.network(e.image),
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList()),
                        ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: kDefaultPadding, left: kDefaultPadding),
                    child: Text(
                      'Recommend',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: kMediumPadding,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: kDefaultPadding,
                        left: kDefaultPadding,
                        right: kDefaultPadding),
                    child: FutureBuilder<List<ProductModel>>(
                      future: appProvider.getProductUUCFList(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ProductModel>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child:
                                  CircularProgressIndicator()); // Show loading indicator
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          // Data is loaded, build the UI with the data
                          List<ProductModel> products = snapshot.data ?? [];

                          return GridView.builder(
                            physics: ScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 60),
                            shrinkWrap: true,
                            itemCount:
                                products.length, ///////////////////////////////
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 20,
                                    childAspectRatio: 0.5),
                            itemBuilder: (ctx, index) {
                              ProductModel singleProduct = products[index];

                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius:
                                        BorderRadius.circular(kDefaultPadding)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: kDefaultPadding * 2,
                                    ),
                                    SizedBox(
                                      height: 100,
                                      width: 120,
                                      child: Image.network(
                                        singleProduct.image,
                                      ),
                                    ),
                                    SizedBox(
                                      height: kMediumPadding,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: kDefaultPadding,
                                          right: kDefaultPadding),
                                      child: Text(
                                        singleProduct.name,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 18,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: kDefaultPadding / 2,
                                    ),
                                    Text(
                                      'Price: \$${singleProduct.price}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: kDefaultPadding / 3,
                                    ),
                                    Center(
                                      child: RatingBar.builder(
                                        initialRating:
                                            singleProduct.averageRating!,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 20,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {},
                                        ignoreGestures: true,
                                      ),
                                    ),
                                    SizedBox(
                                      height: kMediumPadding,
                                    ),
                                    SizedBox(
                                        height: 40,
                                        width: 100,
                                        child: OutlinedButton(
                                            onPressed: () {
                                              Routes.instance.push(
                                                  widget: ProductDetails(
                                                      singleProduct:
                                                          singleProduct),
                                                  context: context);
                                            },
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.6),
                                              foregroundColor: Colors.grey,
                                              side: BorderSide(
                                                  color: Colors.black,
                                                  width: 1.5),
                                            ),
                                            child: Text(
                                              'Buy',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            )))
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                    // child: GridView.builder(
                    //   physics: ScrollPhysics(),
                    //   padding: EdgeInsets.only(bottom: 60),
                    //   shrinkWrap: true,
                    //   itemCount: productSuggestionByCollaborativeFiltering
                    //       .length, ///////////////////////////////
                    //   gridDelegate:
                    //       SliverGridDelegateWithFixedCrossAxisCount(
                    //           crossAxisCount: 2,
                    //           mainAxisSpacing: 20,
                    //           crossAxisSpacing: 20,
                    //           childAspectRatio: 0.5),
                    //   itemBuilder: (ctx, index) {
                    //     ProductModel singleProduct =
                    //         productSuggestionByCollaborativeFiltering[
                    //             index];

                    //     return Container(
                    //       decoration: BoxDecoration(
                    //           color: Colors.grey.withOpacity(0.2),
                    //           borderRadius:
                    //               BorderRadius.circular(kDefaultPadding)),
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           SizedBox(
                    //             height: kDefaultPadding * 2,
                    //           ),
                    //           SizedBox(
                    //             height: 100,
                    //             width: 120,
                    //             child: Image.network(
                    //               singleProduct.image,
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             height: kMediumPadding,
                    //           ),
                    //           Padding(
                    //             padding: const EdgeInsets.only(
                    //                 left: kDefaultPadding,
                    //                 right: kDefaultPadding),
                    //             child: Text(
                    //               singleProduct.name,
                    //               maxLines: 1,
                    //               style: TextStyle(
                    //                 fontSize: 18,
                    //                 overflow: TextOverflow.ellipsis,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             height: kDefaultPadding / 2,
                    //           ),
                    //           Text(
                    //             'Price: \$${singleProduct.price}',
                    //             style: TextStyle(fontSize: 16),
                    //           ),
                    //           SizedBox(
                    //             height: kDefaultPadding / 3,
                    //           ),
                    //           Center(
                    //             child: RatingBar.builder(
                    //               initialRating:
                    //                   singleProduct.averageRating!,
                    //               direction: Axis.horizontal,
                    //               allowHalfRating: true,
                    //               itemCount: 5,
                    //               itemSize: 20,
                    //               itemPadding: EdgeInsets.symmetric(
                    //                   horizontal: 4.0),
                    //               itemBuilder: (context, _) => Icon(
                    //                 Icons.star,
                    //                 color: Colors.amber,
                    //               ),
                    //               onRatingUpdate: (rating) {},
                    //               ignoreGestures: true,
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             height: kMediumPadding,
                    //           ),
                    //           SizedBox(
                    //               height: 40,
                    //               width: 100,
                    //               child: OutlinedButton(
                    //                   onPressed: () {
                    //                     Routes.instance.push(
                    //                         widget: ProductDetails(
                    //                             singleProduct:
                    //                                 singleProduct),
                    //                         context: context);
                    //                   },
                    //                   style: OutlinedButton.styleFrom(
                    //                     backgroundColor:
                    //                         Colors.grey.withOpacity(0.6),
                    //                     foregroundColor: Colors.grey,
                    //                     side: BorderSide(
                    //                         color: Colors.black,
                    //                         width: 1.5),
                    //                   ),
                    //                   child: Text(
                    //                     'Buy',
                    //                     style: TextStyle(
                    //                         color: Colors.black,
                    //                         fontSize: 16,
                    //                         fontWeight: FontWeight.bold),
                    //                   )))
                    //         ],
                    //       ),
                    //     );
                    //   },
                    // ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: kDefaultPadding, left: kDefaultPadding),
                    child: Text(
                      'Best-selling Products',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  search.text.isNotEmpty && seacrhList.isEmpty
                      ? Center(
                          child: Text(
                          "No Products Found",
                        ))
                      : seacrhList.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(kDefaultPadding),
                              child: GridView.builder(
                                physics: ScrollPhysics(),
                                padding: EdgeInsets.only(bottom: 20),
                                shrinkWrap: true,
                                itemCount: seacrhList.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 20,
                                        crossAxisSpacing: 20,
                                        childAspectRatio: 0.5),
                                itemBuilder: (ctx, index) {
                                  ProductModel singleProduct =
                                      seacrhList[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(
                                            kDefaultPadding)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: kDefaultPadding * 2,
                                        ),
                                        SizedBox(
                                          height: 100,
                                          width: 120,
                                          child: Image.network(
                                            singleProduct.image,
                                          ),
                                        ),
                                        SizedBox(
                                          height: kMediumPadding,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: kDefaultPadding,
                                              right: kDefaultPadding),
                                          child: Text(
                                            singleProduct.name,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: kDefaultPadding / 2,
                                        ),
                                        Text(
                                          'Price: \$${singleProduct.price}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(
                                          height: kMediumPadding,
                                        ),
                                        SizedBox(
                                            height: 40,
                                            width: 100,
                                            child: OutlinedButton(
                                                onPressed: () {
                                                  Routes.instance.push(
                                                      widget: ProductDetails(
                                                          singleProduct:
                                                              singleProduct),
                                                      context: context);
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  backgroundColor: Colors.grey
                                                      .withOpacity(0.6),
                                                  foregroundColor: Colors.grey,
                                                  side: BorderSide(
                                                      color: Colors.black,
                                                      width: 1.5),
                                                ),
                                                child: Text(
                                                  'Buy',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )))
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(kDefaultPadding),
                              child: GridView.builder(
                                physics: ScrollPhysics(),
                                padding: EdgeInsets.only(bottom: 60),
                                shrinkWrap: true,
                                itemCount: productSuggestionByRatedScoreList
                                    .length, ///////////////////////////////
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 20,
                                        crossAxisSpacing: 20,
                                        childAspectRatio: 0.5),
                                itemBuilder: (ctx, index) {
                                  ProductModel singleProduct =
                                      productSuggestionByRatedScoreList[index];

                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(
                                            kDefaultPadding)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: kDefaultPadding * 2,
                                        ),
                                        SizedBox(
                                          height: 100,
                                          width: 120,
                                          child: Image.network(
                                            singleProduct.image,
                                          ),
                                        ),
                                        SizedBox(
                                          height: kMediumPadding,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: kDefaultPadding,
                                              right: kDefaultPadding),
                                          child: Text(
                                            singleProduct.name,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 18,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: kDefaultPadding / 2,
                                        ),
                                        Text(
                                          'Price: \$${singleProduct.price}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(
                                          height: kDefaultPadding / 3,
                                        ),
                                        Center(
                                          child: RatingBar.builder(
                                            initialRating:
                                                singleProduct.averageRating!,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 20,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {},
                                            ignoreGestures: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: kMediumPadding,
                                        ),
                                        SizedBox(
                                            height: 40,
                                            width: 100,
                                            child: OutlinedButton(
                                                onPressed: () {
                                                  Routes.instance.push(
                                                      widget: ProductDetails(
                                                          singleProduct:
                                                              singleProduct),
                                                      context: context);
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  backgroundColor: Colors.grey
                                                      .withOpacity(0.6),
                                                  foregroundColor: Colors.grey,
                                                  side: BorderSide(
                                                      color: Colors.black,
                                                      width: 1.5),
                                                ),
                                                child: Text(
                                                  'Buy',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )))
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                ],
              ),
            ),
    );
  }

  bool isSearched() {
    if (search.text.isNotEmpty && seacrhList.isEmpty) {
      return true;
    } else if (search.text.isEmpty && seacrhList.isNotEmpty) {
      return false;
    } else if (seacrhList.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
