import 'package:flutter/material.dart';
import 'package:booketlist/screens/list_buku.dart';
// Import halaman lainnya di sini

class BottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNav({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  // void navigateToScreens(int index, BuildContext context) {
  //   switch (index) {
  //     case 0:
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => HomeReaderPage()));
  //       break;
  //     case 1:
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => BookPage()));
  //       break;
  //     case 2:
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => WishlistPage()));
  //       break;
  //     case 3:
  //       // Tambahkan navigasi ke halaman Review (sesuaikan jika ada)
  //       break;
  //     case 4:
  //       // Tambahkan navigasi ke halaman Profile (sesuaikan jika ada)
  //       //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: 'Collections',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Wishlist',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.campaign),
          label: 'Updates',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.rate_review),
          label: 'Review',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: const Color.fromARGB(255, 30, 69, 29),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        onItemTapped(index);
        //navigateToScreens(index, context);
      },
    );
  }
}
