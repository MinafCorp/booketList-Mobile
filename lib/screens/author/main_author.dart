// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, constant_identifier_names
import 'package:booketlist/screens/author/home.dart';
import 'package:booketlist/screens/author/update.dart';
import 'package:booketlist/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// Import halaman lainnya di sini

class MainAuthor extends StatefulWidget {
  const MainAuthor({super.key});
  @override
  _MainAuthorState createState() => _MainAuthorState();
}

class _MainAuthorState extends State<MainAuthor> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  late final List<Widget> screens;
  int index = 0;
  @override
  void initState() {
    super.initState();
    screens = [
      const HomeAuthorPage(),
      const UpdateAuthorPage(),
      const ProfilePage(),
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
