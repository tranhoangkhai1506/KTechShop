import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String id;
  String? image;
  String? name;
  String? email;
  String? phone;
  String? address;

  UserModel(
      {required this.id,
      this.image,
      required this.name,
      required this.email,
      this.phone,
      this.address});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
      };

  UserModel copyWith({String? name, image, phone, address}) => UserModel(
      image: image ?? this.image,
      name: name ?? this.name,
      id: id,
      email: email,
      phone: phone,
      address: address);
}
