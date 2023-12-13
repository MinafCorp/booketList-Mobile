import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert' as convert;
import 'package:booketlist/screens/login.dart';

class RegisterPage extends StatefulWidget {
    const RegisterPage({super.key});

    @override
    State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
    var role = ['Author', 'Reader'];
    String val = 'Author';

    final _formKey = GlobalKey<FormState>();

    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _firstNameController = TextEditingController();
    final TextEditingController _lastNameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _password1Controller = TextEditingController();
    final TextEditingController _password2Controller = TextEditingController();


    void _initRegister(request) async {
      var data = convert.jsonEncode(
        <String, String?>{
          'username': _usernameController.text,
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'email': _emailController.text,
          'password1': _password1Controller.text,
          'password2': _password2Controller.text,
          'role': val,
        },
      );

      final response = await request.postJson(
          "https://booketlist-production.up.railway.app/auth/register/",
          data,
      );

      if(response['status'] == false ){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
          ),
        );
      }else if(response['status'] == true){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
          ),
        );
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()
            )
        );
      }
    }


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
                child: Form(
                  key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 236, 227, 215).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20)),
                        child : Column(children: [
                          const Text(
                                      "REGISTER",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 67, 64, 59),
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        ),
                                    ),
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(labelText: 'Username'),
                            validator: (val){
                              if(val!.isEmpty ){
                                return 'Please enter your username';
                              }
                              return null;
                            }
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _firstNameController,
                            decoration: const InputDecoration(labelText: 'First Name'),
                            validator: (val){
                              if(val!.isEmpty ){
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(labelText: 'Last Name'),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(labelText: 'Email'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val){
                              if(val!.isEmpty ){
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _password1Controller,
                            decoration: const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (val){
                              if(val!.isEmpty){
                                return 'Please enter your password';
                              }else if(val.length < 8){
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _password2Controller,
                            decoration: const InputDecoration(labelText: 'Confirm Password'),
                            obscureText: true,
                            validator: (val){
                              if(val!.isEmpty ){
                                return 'Please enter your password';
                              }else if(val != _password1Controller.text){
                                return 'Password does not match';
                              }
                              return null;
                            },
                          ),
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
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(255, 67, 64, 59),
                                          minimumSize: const Size(150, 40),
                                        ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _initRegister(request);
                              }
                              // Perform registration with the obtained data
                            },
                            child: const Text(
                                          'Register',
                                          style: TextStyle(color: Colors.white),

                                        ),
                          ),
                          ],)
                     ),
                  ],
                ),
              ),
            )
        );
    }
}