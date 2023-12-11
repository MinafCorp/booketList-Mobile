import 'package:booketlist/screens/updates/search_update.dart';
import 'package:booketlist/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';

class UpdatePage extends StatefulWidget {
    const UpdatePage({super.key});

    @override
    State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final TextEditingController _searchController = TextEditingController();

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
                      builder: (context) => SearchUpdatePage(),
                    ));
                },
                icon: const Icon(Icons.search)
              )
            ],
          ),
          drawer: const MenuDrawer(),
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 67, 64, 59),
                      minimumSize: Size(100, 40),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Post Update",
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