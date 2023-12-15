import 'dart:convert';

List<Wishlist> wishlistFromJson(String str) =>
    List<Wishlist>.from(json.decode(str).map((x) => Wishlist.fromJson(x)));

String wishlistToJson(List<Wishlist> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Wishlist {
  Model model;
  int pk;
  Fields fields;

  Wishlist({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
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
  int isbn;
  String title;
  String author;
  int yearOfPublication;
  String publisher;
  String imageUrlS;
  String imageUrlM;
  String imageUrlL;
  dynamic authorUser;
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
