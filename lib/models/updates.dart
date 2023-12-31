// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, library_private_types_in_public_api, constant_identifier_names

import 'dart:convert';

List<Updates> bookFromJson(String str) => List<Updates>.from(json.decode(str).map((x) => Updates.fromJson(x)));

String bookToJson(List<Updates> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Updates {
    String model;
    int pk;
    Fields fields;

    Updates({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Updates.fromJson(Map<String, dynamic> json) => Updates(
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
  int author;
  String authorUsername;
  String title;
  String content;
  DateTime dataAdded;

  Fields({
    required this.author,
    required this.authorUsername,
    required this.title,
    required this.content,
    required this.dataAdded,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        author: json["author"],
        authorUsername: json["author_username"],
        title: json["title"],
        content: json["content"],
        dataAdded: DateTime.parse(json["data_added"]),
      );

  Map<String, dynamic> toJson() => {
        "author": author,
        "author_username": authorUsername,
        "title": title,
        "content": content,
        "data_added":
            "${dataAdded.year.toString().padLeft(4, '0')}-${dataAdded.month.toString().padLeft(2, '0')}-${dataAdded.day.toString().padLeft(2, '0')}",
      };
}
