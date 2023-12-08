import 'package:flutter/material.dart';

class SearchUpdatePage extends StatefulWidget {
    const SearchUpdatePage({super.key});

    @override
    State<SearchUpdatePage> createState() => _SearchUpdatePageState();
}

class _SearchUpdatePageState extends State<SearchUpdatePage> {
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
                    hintText: 'Search Updates...',
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