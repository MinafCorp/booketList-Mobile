// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Model model;
  int pk;
  Fields fields;

  Product({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  int user;
  int product;
  String reviewText;
  DateTime createdAt;
  int reviewRating;
  String? createdBy;
  String? judulBuku;

  Fields({
    required this.user,
    required this.product,
    required this.reviewText,
    required this.createdAt,
    required this.reviewRating,
    required this.createdBy,
    required this.judulBuku,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        product: json["product"],
        reviewText: json["review_text"],
        createdAt: DateTime.parse(json["created_at"]),
        reviewRating: json["review_rating"],
        createdBy: json["created_by"],
        judulBuku: json["judul_buku"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "product": product,
        "review_text": reviewText,
        "created_at": createdAt.toIso8601String(),
        "review_rating": reviewRating,
        "created_by": createdBy,
        "judul_buku": judulBuku,
      };
}

enum Model { book_review }

final modelValues = EnumValues({"book.productreview": Model.book_review});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
