import 'package:booketlist/screens/search_book.dart';
import 'package:booketlist/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';

class HomeAuthorPage extends StatefulWidget {
  const HomeAuthorPage({super.key});

  @override
  State<HomeAuthorPage> createState() => _HomeAuthorPageState();
}

class _HomeAuthorPageState extends State<HomeAuthorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 151, 138, 116),
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(),
                    ));
              },
              icon: const Icon(Icons.search))
        ],
      ),
      drawer: const MenuDrawer(),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(10.0), // Set padding dari halaman
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Align(
                    alignment: Alignment.center,
                    // Widget Text untuk menampilkan tulisan dengan alignment center dan style yang sesuai
                    child: Image(image: AssetImage('images/title.png')),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 67, 64, 59),
                        minimumSize: const Size(100, 40),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Publish Book",
                        style: TextStyle(
                          color: Color.fromARGB(255, 236, 227, 215),
                        ),
                      )),
                ])),
      ),
    );
  }
}
