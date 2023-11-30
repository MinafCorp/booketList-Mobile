import 'package:booketlist/screens/login.dart';
import 'package:booketlist/screens/role.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 227, 215),
    body: Padding(  
      padding: EdgeInsets.only(top: 10),
        child: 
          Column(
            mainAxisAlignment : MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Image(image: AssetImage('images/logooo.png')),
                ),
              Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 67, 64, 59)),
                        child: const Text(
                          "Get Started",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
            ],
          )
    ),
);
}}