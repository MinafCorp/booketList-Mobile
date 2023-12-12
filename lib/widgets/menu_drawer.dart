import 'package:booketlist/screens/reader/update.dart';
import 'package:flutter/material.dart';
import 'package:booketlist/screens/list_buku.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 230,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 236, 227, 215),
              ),
              child: Column(
                children: [
                  const Image(
                    image: AssetImage('images/tes_profile.png'),
                    alignment: Alignment.center,
                  ),
                  const Text(
                    'Username',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Color.fromARGB(255, 67, 64, 59),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(
                        maxWidth: 50,
                        maxHeight: 30,
                      ),
                      color: const Color.fromARGB(255, 67, 64, 59),
                      child: const Text(
                        'Role',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 236, 227, 215),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Wishlist'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => MyHomePage(),
              //     ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text('Collection'),
            // Bagian redirection ke BookPage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookPage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.campaign),
            title: const Text('Updates and News'),
            // Bagian redirection ke ShopFormPage
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UpdatePage(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
