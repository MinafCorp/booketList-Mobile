// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, library_private_types_in_public_api, constant_identifier_names, unused_local_variable
import 'package:flutter/material.dart';
import 'package:booketlist/screens/login.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 3),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/mintwal.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FadeTransition(
                opacity: _controller,
                child: const Align(
                  alignment: Alignment.center,
                  child: Image(image: AssetImage('images/tesss.gif')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 70),
                child: ScaleTransition(
                  scale: _controller,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const LoginPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = 0.0;
                            const end = 1.0;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end).chain(
                              CurveTween(curve: curve),
                            );

                            var fadeAnimation = animation.drive(tween);

                            var zoomAnimation =
                                Tween(begin: 0.5, end: 1.0).animate(animation);
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 38, 117, 114),
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontFamily: 'Georgia',
                        letterSpacing: 1.1,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 13),
                    ),
                    child: const Text(
                      "Begin your Journey",
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
