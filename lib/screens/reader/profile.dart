// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   late Future<Map<String, dynamic>> userData;
//
//   @override
//   void initState() {
//     super.initState();
//     userData = fetchUserData();
//   }
//
//   Future<Map<String, dynamic>> fetchUserData() async {
//     var url = Uri.parse(
//         'https://booketlist-production.up.railway.app/user-api');
//     var response =
//     await http.get(url, headers: {"Content-Type": "application/json"});
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to load user data');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: const Text('Profile Page'),
//     );
//   }
// }
