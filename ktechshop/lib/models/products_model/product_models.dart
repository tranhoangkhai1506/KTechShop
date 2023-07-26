import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String image;
  String name;
  String id;
  bool isFavourite;
  String price;
  String description;
  String status;

  ProductModel({
    required this.image,
    required this.name,
    required this.id,
    required this.isFavourite,
    required this.price,
    required this.description,
    required this.status,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        image: json["image"],
        name: json["name"],
        id: json["id"],
        isFavourite: false,
        price: json["price"],
        description: json["description"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "name": name,
        "id": id,
        "isFavourite": isFavourite,
        "price": price,
        "description": description,
        "status": status,
      };
}
