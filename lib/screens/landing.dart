import 'package:booketlist/screens/login.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 227, 215),
      body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Align(
                alignment: Alignment.center,
                child: Image(image: AssetImage('images/tesss.gif')),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = 0.0;
                            const end = 1.0;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end).chain(
                              CurveTween(curve: curve),
                            );

                            var fadeAnimation = animation.drive(tween);

                            var zoomAnimation = Tween(begin: 0.5, end: 1.0).animate(animation);

                            return FadeTransition(
                              opacity: fadeAnimation,
                              child: ScaleTransition(
                                scale: zoomAnimation,
                                child: child,
                              ),
                            );
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 67, 64, 59)),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
