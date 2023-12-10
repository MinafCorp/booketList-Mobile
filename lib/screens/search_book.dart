import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
    const SearchPage({super.key});

    @override
    State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Container(
              width: double.infinity,
              height: 40,
              child: Center(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: (){}, 
                    ),
                    hintText: 'Search Book...',
                  ),
                )
              ),
            ),
            backgroundColor: Color.fromARGB(255, 151, 138, 116),
          ),
          // drawer: const MenuDrawer(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10.0), // Set padding dari halaman
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    // Widget Text untuk menampilkan tulisan dengan alignment center dan style yang sesuai
                    child: Image(image: AssetImage('images/title.png')),
                  ),
                  const SizedBox(height: 30),
                ]
              )
          ),
        ),
        );
    }
}