// To parse this JSON data, do
//
//     final bookAuthor = bookAuthorFromJson(jsonString);

import 'dart:convert';

List<BookAuthor> bookAuthorFromJson(String str) =>
    List<BookAuthor>.from(json.decode(str).map((x) => BookAuthor.fromJson(x)));

String bookAuthorToJson(List<BookAuthor> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookAuthor {
  String model;
  int pk;
  Fields fields;

  BookAuthor({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory BookAuthor.fromJson(Map<String, dynamic> json) => BookAuthor(
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
  int isbn;
  String title;
  String author;
  int yearOfPublication;
  String publisher;
  dynamic imageUrlS;
  String imageUrlM;
  String imageUrlL;
  int authorUser;
  String image;

  Fields({
    required this.isbn,
    required this.title,
    required this.author,
    required this.yearOfPublication,
    required this.publisher,
    required this.imageUrlS,
    required this.imageUrlM,
    required this.imageUrlL,
    required this.authorUser,
    required this.image,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        isbn: json["ISBN"],
        title: json["title"],
        author: json["author"],
        yearOfPublication: json["year_of_publication"],
        publisher: json["publisher"],
        imageUrlS: json["image_url_s"],
        imageUrlM: json["image_url_m"],
        imageUrlL: json["image_url_l"],
        authorUser: json["authorUser"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "ISBN": isbn,
        "title": title,
        "author": author,
        "year_of_publication": yearOfPublication,
        "publisher": publisher,
        "image_url_s": imageUrlS,
        "image_url_m": imageUrlM,
        "image_url_l": imageUrlL,
        "authorUser": authorUser,
        "image": image,
      };
}
