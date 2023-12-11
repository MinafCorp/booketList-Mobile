import 'package:booketlist/screens/author/home.dart';
import 'package:booketlist/screens/author/update.dart';
import 'package:booketlist/screens/reader/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:booketlist/screens/reader/list_buku.dart';
import 'package:booketlist/screens/reader/homeReader.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// Import halaman lainnya di sini

class MainReader extends StatefulWidget {
  @override
  _MainReaderState createState() => _MainReaderState();
}

class _MainReaderState extends State<MainReader> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;
  final screens = [
    HomeReaderPage(username: ""),
    BookPage(), // profile page blm ada, jd sementara pake ini
    UpdatePage(),
    WishlistPage(),
    WishlistPage(),
    WishlistPage(),
  ];
  

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.home_filled, color: Colors.white),
      Icon(Icons.book, color: Colors.white),
      Icon(Icons.campaign, color: Colors.white),
      Icon(Icons.favorite, color: Colors.white),
      Icon(Icons.rate_review, color: Colors.white),
      Icon(Icons.person, color: Colors.white),
    ];
    return Scaffold(
      body : screens[index],
      bottomNavigationBar: CurvedNavigationBar(
          key: navigationKey,
          items: items,
          index: index,
          height: 60,
          backgroundColor: Color.fromARGB(255, 236, 227, 215),
          buttonBackgroundColor: Color.fromARGB(255, 67, 64, 59),
          color: Color.fromARGB(255, 67, 64, 59),
          onTap: (tappedIndex) {
            setState(() {
              index = tappedIndex;
            });
          },
        ),
    );
  }
}
