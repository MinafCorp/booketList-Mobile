import 'package:booketlist/screens/reader/update.dart';
import 'package:booketlist/screens/profile.dart';
import 'package:booketlist/screens/reader/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:booketlist/screens/reader/list_buku.dart';
import 'package:booketlist/screens/reader/home_reader.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:booketlist/screens/reader/review.dart';


class MainReader extends StatefulWidget {
  const MainReader({super.key});

  @override
  State<MainReader> createState() => _MainReaderState();
}

class _MainReaderState extends State<MainReader> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;
  final screens = [
    const HomeReaderPage(),
    const BookPage(),
    const UpdatePage(),
    const WishlistPage(),
    const ReviewPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(Icons.home_filled, color: Colors.white),
      const Icon(Icons.book, color: Colors.white),
      const Icon(Icons.campaign, color: Colors.white),
      const Icon(Icons.favorite, color: Colors.white),
      const Icon(Icons.rate_review, color: Colors.white),
      const Icon(Icons.person, color: Colors.white),
    ];
    return Scaffold(
      body: screens[index],
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
