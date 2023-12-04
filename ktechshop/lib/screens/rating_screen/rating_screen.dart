// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:ktechshop/constants/dismension_constants.dart';
import 'package:ktechshop/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:ktechshop/models/rating_model/rating_model.dart';
import 'package:ktechshop/widgets/primary_button/primary_button.dart';

class Rating extends StatefulWidget {
  final String productId;
  final String userId;
  final String orderId;

  const Rating({
    Key? key,
    required this.productId,
    required this.userId,
    required this.orderId,
  }) : super(key: key);

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  TextEditingController content = TextEditingController();
  String ratingScore = "3.0";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Đánh giá sản phẩm",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: ListView(
          children: [
            Center(
              child: RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  ratingScore = rating.toString();
                },
              ),
            ),
            TextFormField(
              controller: content,
              decoration: InputDecoration(
                hintText: 'Nội dung đánh giá',
              ),
            ),
            SizedBox(
              height: kDefaultPadding,
            ),
            PrimaryButton(
                onPressed: () async {
                  RatingModel ratingModel = RatingModel(
                      productId: widget.productId,
                      userId: widget.userId,
                      content: content.text,
                      rating: ratingScore);
                  await FirebaseFirestoreHelper.instance.uploadRatingFirebase(
                      widget.orderId, ratingModel, context);

                  bool isReview = await FirebaseFirestoreHelper.instance
                      .isRatingOrder(widget.orderId);

                  if (isReview) {
                    await FirebaseFirestoreHelper.instance
                        .updateOrderReview(widget.orderId, "Reviewed");
                  }
                  setState(() {});
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                },
                title: "Send")
          ],
        ),
      ),
    );
  }
}
