import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class RegisterPage extends StatefulWidget {
    const RegisterPage({super.key});

    @override
    State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
    var role = ['Author', 'Reader'];
    String val = 'Author';

    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _firstNameController = TextEditingController();
    final TextEditingController _lastNameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    @override
    Widget build(BuildContext context) {
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                  color: Color.fromARGB(255, 236, 227, 215).withOpacity(0.9),
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
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(labelText: 'First Name'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
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
                                    backgroundColor: Color.fromARGB(255, 67, 64, 59),
                                    minimumSize: Size(150, 40),
                                  ),
                      onPressed: () {
                        // Add your registration logic here
                        String username = _usernameController.text;
                        String firstName = _firstNameController.text;
                        String lastName = _lastNameController.text;
                        String email = _emailController.text;
                        String password = _passwordController.text;

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
      );
    }
}