import 'package:booketlist/screens/list_buku.dart';
import 'package:booketlist/screens/role.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var role = ['Author', 'Reader'];
  String val = 'Author';
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
            // color: Colors.red.withOpacity(0.1),
            image: DecorationImage(
          image: AssetImage('images/wp.jpg'),
          fit: BoxFit.cover,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 236, 227, 215).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(children: [
                  const Text(
                    "LOGIN",
                    style: TextStyle(
                      color: Color.fromARGB(255, 67, 64, 59),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24.0),
                  DropdownButton(
                    // Initial Value
                    value: val,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: role.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        val = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 15.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 67, 64, 59),
                      minimumSize: Size(100, 40),
                    ),
                    onPressed: () async {
                      String username = _usernameController.text;
                      String password = _passwordController.text;
                      String role = val;
                      // Perform login with the obtained data
                      // authentication with json
                      final response = await request.login(
                          "http://booketlist-production.up.railway.app/auth/login/",
                          {
                            'username': username,
                            'password': password,
                            'role': role,
                          });
                      if (request.loggedIn) {
                        String message = response['message'];
                        String uname = response['username'];
                        String role = response['role'];
                        if (role == 'Author') {
                          //Navigator somewhere
                        } else if (role == 'Reader') {
                          //Navigator somewhere
                        }
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Role(),
                          ));
                    },
                    child: Text("Don't have account yet? Register here"),
                    style: TextButton.styleFrom(
                      foregroundColor:
                          Color.fromARGB(255, 67, 64, 59), // Background color
                      padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8), // Padding
                    ),
                  )
                ])),
          ],
        ),
      ),
    );
  }
}
