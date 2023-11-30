import 'package:booketlist/screens/register_author.dart';
import 'package:booketlist/screens/register_reader.dart';
import 'package:flutter/material.dart';

class Role extends StatelessWidget {
  const Role({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wp.jpg'),
          fit: BoxFit.cover,
      )),
      child: SizedBox(
          height: 1000,
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Add your button click logic here
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterReaderPage(),
                ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 236, 227, 215),
              minimumSize: const Size(150, 150),
            ),
            child: Container(
              // width: 150, // Adjust width as needed
              // height: 150, // Adjust height as needed
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.local_library),
                  SizedBox(height: 10),
                  Text(
                    'Reader',
                    style: TextStyle(
                      color: Color.fromARGB(255, 67, 64, 59),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              // Add your button click logic here
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterAuthorPage(),
                ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 236, 227, 215),
              minimumSize: Size(150, 150),
            ),
            child: Container(
              // width: 150, // Adjust width as needed
              // height: 150, // Adjust height as needed
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.history_edu),
                  SizedBox(height: 10),
                  Text(
                    'Author',
                    style: TextStyle(
                      color: Color.fromARGB(255, 67, 64, 59),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]
      ),
      ),
      ),
    );
  }
}
