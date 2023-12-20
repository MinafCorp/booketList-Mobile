// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, library_private_types_in_public_api, constant_identifier_names, unused_local_variable
import 'package:booketlist/screens/landing.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';


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
    final request = context.read<CookieRequest>();
    final response = await request.get('https://booketlist-production.up.railway.app/user-api/');
    return response;
  }

  Future<void> logout() async {
    var url = Uri.parse('https://booketlist-production.up.railway.app/auth/logout/');
    var response =
        await http.post(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const MyHomePage()));
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
      backgroundColor: const Color.fromARGB(255, 236, 227, 215),
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color.fromARGB(255, 67, 64, 59),
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
                        'assets/images/Profile.png'), 
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
                  const SizedBox(height: 20),
                  IconButton(icon: const Icon(Icons.logout),
                      onPressed: () {
                        logout();
                      },
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
