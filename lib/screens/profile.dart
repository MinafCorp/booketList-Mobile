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
    var url = Uri.parse(
        'https://booketlist-production.up.railway.app/user-api');
    var response =
    await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              if (user['role'] == 'Author') {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Image(image: AssetImage('images/Profile.png')), // Dummy image
                    const SizedBox(height: 20),
                    Text('Hello ${user['username']}!'),
                    Text('${user['first_name']} ${user['last_name']}'),
                    Text('${user['role']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    //Want to display amount of books published
                  ],
                );
              } else if (user['role'] == 'Reader') {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Image(image: AssetImage('images/Profile.png')), // Dummy image
                    const SizedBox(height: 20),
                    Text('Hello ${user['username']}!'),
                    Text('${user['first_name']} ${user['last_name']}'),
                    Text('${user['role']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    //Want to display amount of books wish listed
                    //Want to display amount of books read
                  ],
                );
              } else {
                return const Text('No Role Found');
              }
            } else {
              return const Text('No user data found');
            }
          },
        ),
      ),
    );
  }
}
