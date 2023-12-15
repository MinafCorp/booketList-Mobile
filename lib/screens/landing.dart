import 'package:booketlist/screens/login.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'images/landing.png', // Ensure this is the correct path to your image asset
            fit: BoxFit.cover,
          ),
          // Overlay content
          Column(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Spread out the column's children over the main axis
            children: [
              const Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Booket',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'serif', // Default serif font
                          color: Colors.white,
                          fontSize: 65,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        'List',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'serif', // Default serif font
                          color: Colors.white,
                          fontSize: 65,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height *
                      0.04, // Adjust the padding to position the button
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const LoginPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFAE8E0), // Beige color for the button
                    onPrimary: Colors.black, // Text color
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape:
                        const StadiumBorder(), // Rounded edges for the button
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold, // Bold text for the button
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
