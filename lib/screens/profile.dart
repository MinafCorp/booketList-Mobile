// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, library_private_types_in_public_api, constant_identifier_names, unused_local_variable
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> userData;

  @override
  void initState() {
    super.initState();
    userData = fetchUserData();
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    var url =
        Uri.parse('https://booketlist-production.up.railway.app/user-api');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> logout() async {
    var url =
        Uri.parse('https://booketlist-production.up.railway.app/auth/logout/');
    var response =
        await http.post(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to logout'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color.fromARGB(255, 67, 64, 59),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logout();
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: userData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              var user = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CircleAvatar(
                    radius: 80.0,
                    backgroundImage: AssetImage(
                        'images/Profile.png'), // Replace with your image
                  ),
                  const SizedBox(height: 20),
                  Text('Hello ${user['username']}!'),
                  Text('${user['first_name']} ${user['last_name']}'),
                  Text(
                    '${user['role']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Match your reference style
                    ),
                  ),
                ],
              );
            } else {
              return const Text('No user data found');
            }
          },
        ),
      ),
    );
  }
}
