import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String image;
  String name;
  String id;
  bool isFavourite;
  double price;
  String description;
  String status;

  int? quantity;
  double? averageRating;

  ProductModel({
    required this.image,
    required this.name,
    required this.id,
    required this.isFavourite,
    required this.price,
    required this.description,
    required this.status,
    this.quantity,
    this.averageRating = 0.0,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        image: json["image"],
        name: json["name"],
        id: json["id"],
        isFavourite: false,
        price: double.parse(json["price"].toString()),
        description: json["description"],
        status: json["status"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "name": name,
        "id": id,
        "isFavourite": isFavourite,
        "price": price,
        "description": description,
        "status": status,
        "quantity": quantity,
      };

  ProductModel copyWith({
    int? quantity,
  }) =>
      ProductModel(
          image: image,
          name: name,
          id: id,
          isFavourite: isFavourite,
          price: price,
          description: description,
          status: status,
          quantity: quantity ?? this.quantity);
}
