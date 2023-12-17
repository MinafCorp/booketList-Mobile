// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, library_private_types_in_public_api, constant_identifier_names
import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String username;
  String email;
  String firstName;
  String lastName;
  String role;

  User({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["username"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "role": role,
      };
}
