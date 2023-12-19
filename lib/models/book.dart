// ignore_for_file: constant_identifier_names

import 'dart:convert';

List<Book> bookFromJson(String str) =>
    List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String bookToJson(List<Book> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
  int pk;
  Model model;
  Fields fields;

  Book({
    required this.pk,
    required this.model,
    required this.fields,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        pk: json["pk"],
        model: modelValues.map[json["model"]]!,
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "pk": pk,
        "model": modelValues.reverse[model],
        "fields": fields.toJson(),
      };
}

class Fields {
  int isbn;
  String title;
  String author;
  int yearOfPublication;
  String publisher;
  String imageUrlS;
  String imageUrlM;
  String imageUrlL;

  Fields({
    required this.isbn,
    required this.title,
    required this.author,
    required this.yearOfPublication,
    required this.publisher,
    required this.imageUrlS,
    required this.imageUrlM,
    required this.imageUrlL,
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
      };
}

enum Model { Booketlist }

final modelValues = EnumValues({"book.book": Model.Booketlist});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
