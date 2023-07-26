import 'package:flutter/material.dart';
import 'package:ktechshop/constants/assets_images.dart';
import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/models/products_model/product_models.dart';
import 'package:ktechshop/widgets/top_titles/top_titles.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                          borderRadius: BorderRadius.circular(kDefaultPadding),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(kDefaultPadding),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(kDefaultPadding),
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.only(left: kDefaultPadding),
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: categoriesList
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(kDefaultPadding / 2),
                            child: Card(
                              color: Colors.white,
                              elevation: 6.0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(kDefaultPadding),
                              ),
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: Image.asset(e),
                              ),
                            ),
                          ))
                      .toList()),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: kDefaultPadding, left: kDefaultPadding),
              child: Text(
                'Best Products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: kDefaultPadding,
            ),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: bestProducts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.7),
                itemBuilder: (ctx, index) {
                  ProductModel singleProduct = bestProducts[index];
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(kDefaultPadding)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: kDefaultPadding,
                        ),
                        Image.asset(
                          singleProduct.image,
                          scale: 2.5,
                        ),
                        SizedBox(
                          height: kDefaultPadding,
                        ),
                        Text(
                          singleProduct.name,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.grey.withOpacity(0.6),
                                  foregroundColor: Colors.grey,
                                  side: BorderSide(
                                      color: Colors.black, width: 1.5),
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

List<String> categoriesList = [
  AssetsImages.instance.cate1Image,
  AssetsImages.instance.cate2Image,
  AssetsImages.instance.cate3Image,
  AssetsImages.instance.cate4Image,
];

List<ProductModel> bestProducts = [
  ProductModel(
      image: AssetsImages.instance.appleImage,
      name: 'Apple',
      id: 'id01',
      isFavourite: true,
      price: '5',
      description: 'description',
      status: 'status'),
  ProductModel(
      image: AssetsImages.instance.bananaImage,
      name: 'Banana',
      id: 'id02',
      isFavourite: true,
      price: '1',
      description: 'description',
      status: 'status'),
  ProductModel(
      image: AssetsImages.instance.watermelonImage,
      name: 'WaterMelon',
      id: 'id03',
      isFavourite: true,
      price: '4',
      description: 'description',
      status: 'status'),
];
