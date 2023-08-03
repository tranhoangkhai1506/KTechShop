import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/constants/routes.dart';
import 'package:ktechshop/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:ktechshop/models/categories_model/categories_model.dart';
import 'package:ktechshop/models/products_model/product_models.dart';
import 'package:ktechshop/provider/app_provider.dart';
import 'package:ktechshop/screens/category_view/category_view.dart';
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
  bool isLoading = false;
  @override
  void initState() {
    getCategoryList();
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInfoFirebase();
    super.initState();
  }

  void getCategoryList() async {
    setState(() {
      isLoading = true;
    });
    categoriesList = await FirebaseFirestoreHelper.instance.getCategory();
    productModelList = await FirebaseFirestoreHelper.instance.getBestProducts();

    productModelList.shuffle();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        TopTitles(
                          title: 'K_Tech',
                          subTitle: '',
                        ),
                        SizedBox(
                          height: kDefaultPadding / 2,
                        ),
                        TextFormField(
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
                              hintText: 'Search...',
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
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
                      'Best Products',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  productModelList.isEmpty
                      ? Center(
                          child: Text('Best Product is empty'),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          child: GridView.builder(
                            padding: EdgeInsets.only(bottom: 60),
                            shrinkWrap: true,
                            itemCount: productModelList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 20,
                                    childAspectRatio: 0.6),
                            itemBuilder: (ctx, index) {
                              ProductModel singleProduct =
                                  productModelList[index];
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
                                      height: kDefaultPadding,
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
                                      height: kDefaultPadding,
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
                          ),
                        )
                ],
              ),
            ),
    );
  }
}
