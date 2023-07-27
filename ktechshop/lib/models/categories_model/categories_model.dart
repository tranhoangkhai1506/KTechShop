import 'dart:convert';

CategoriesModel categoriesModelFromJson(String str) =>
    CategoriesModel.fromJson(json.decode(str));

String categoriesModelToJson(CategoriesModel data) =>
    json.encode(data.toJson());

class CategoriesModel {
  String id;
  String image;

  CategoriesModel({
    required this.id,
    required this.image,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(
        id: json["id"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
      };
}
