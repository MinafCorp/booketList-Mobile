import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:booketlist/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';

class HomeAuthorPage extends StatefulWidget {
    const HomeAuthorPage({super.key});

    @override
    State<HomeAuthorPage> createState() => _HomeAuthorPageState();
}

class _HomeAuthorPageState extends State<HomeAuthorPage> {
  final TextEditingController _searchController = TextEditingController();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, 65),
            child: SafeArea(
              child: Container(
              decoration: const BoxDecoration(color: Color.fromARGB(255, 192, 184, 174), boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(0, 5))
              ]),
            child : AnimationSearchBar(
              
              backIconColor: Colors.black,
              backIcon: Icons.menu,
              onChanged: (text) => debugPrint(text),
              searchTextEditingController: _searchController,
              horizontalPadding: 5),
          ),
          ),
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
                    child:  Image(image: AssetImage('images/title.png')),
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
                    )
                  ),
                ]
              )
          ),
        ),
        );
    }
}