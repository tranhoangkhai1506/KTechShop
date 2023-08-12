import 'package:flutter/material.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/constants/routes.dart';
import 'package:ktechshop/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:ktechshop/models/categories_model/categories_model.dart';
import 'package:ktechshop/models/products_model/product_models.dart';
import 'package:ktechshop/screens/product_details/product_detail.dart';

class CategoryView extends StatefulWidget {
  final CategoriesModel categoryModel;
  const CategoryView({super.key, required this.categoryModel});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  List<ProductModel> productModelList = [];
  bool isLoading = false;
  @override
  void initState() {
    getCategoryList();
    super.initState();
  }

  void getCategoryList() async {
    setState(() {
      isLoading = true;
    });
    productModelList = await FirebaseFirestoreHelper.instance
        .getCategoryViewProduct(widget.categoryModel.id);
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
              padding: EdgeInsets.only(bottom: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: kMediumPadding,
                  ),
                  Padding(
                    padding: EdgeInsets.all(kDefaultPadding),
                    child: Row(
                      children: [
                        BackButton(),
                        Text(
                          widget.categoryModel.name,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  productModelList.isEmpty
                      ? Center(
                          child: Text('Product is empty'),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                            left: kDefaultPadding,
                            right: kDefaultPadding,
                          ),
                          child: GridView.builder(
                            physics: ScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: productModelList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 20,
                                    childAspectRatio: 0.7),
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
                                      child: FittedBox(
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
