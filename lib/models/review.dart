// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    String model;
    int pk;
    Fields fields;

    Product({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
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

    Fields({
        required this.user,
        required this.product,
        required this.reviewText,
        required this.createdAt,
        required this.reviewRating,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        product: json["product"],
        reviewText: json["review_text"],
        createdAt: DateTime.parse(json["created_at"]),
        reviewRating: json["review_rating"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "product": product,
        "review_text": reviewText,
        "created_at": createdAt.toIso8601String(),
        "review_rating": reviewRating,
    };
}
