import 'package:booketlist/screens/author/home.dart';
import 'package:booketlist/screens/author/update.dart';
import 'package:booketlist/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:booketlist/screens/reader/list_buku.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// Import halaman lainnya di sini

class MainAuthor extends StatefulWidget {

  final int id; // Tambahkan variabel id

  MainAuthor({Key? key, required this.id}) : super(key: key);
  @override
  _MainAuthorState createState() => _MainAuthorState();
}

class _MainAuthorState extends State<MainAuthor> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  late final List<Widget> screens;
  int index = 0;
  void initState() {
    super.initState();
    // Initialize 'screens' inside initState
    screens = [
      HomeAuthorPage(id: widget.id),
      const UpdatePage(),
      const ProfilePage(), // Assuming ProfilePage doesn't require 'id'
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(Icons.home_filled, color: Colors.white),
      const Icon(Icons.campaign, color: Colors.white),
      const Icon(Icons.person, color: Colors.white),
    ];
    return Scaffold(
      body : screens[index],
      bottomNavigationBar: CurvedNavigationBar(
          key: navigationKey,
          items: items,
          index: index,
          height: 60,
          backgroundColor: const Color.fromARGB(255, 236, 227, 215),
          buttonBackgroundColor: const Color.fromARGB(255, 67, 64, 59),
          color: const Color.fromARGB(255, 67, 64, 59),
          onTap: (tappedIndex) {
            setState(() {
              index = tappedIndex;
            });
          },
        ),
    );
  }
}
