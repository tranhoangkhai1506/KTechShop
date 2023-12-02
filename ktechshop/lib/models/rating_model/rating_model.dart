import 'dart:convert';

RatingModel ratingFromJson(String str) => RatingModel.fromJson(json.decode(str));

String ratingToJson(RatingModel data) => json.encode(data.toJson());

class RatingModel {
    String userId;
    String productId;
    String rating;
    String content;

    RatingModel({
        required this.userId,
        required this.productId,
        required this.rating,
        required this.content,
    });

    factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
        userId: json["userId"],
        productId: json["productId"],
        rating: json["rating"],
        content: json["content"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "productId": productId,
        "rating": rating,
        "content": content,
    };
}