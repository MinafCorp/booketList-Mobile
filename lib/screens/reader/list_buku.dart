// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, constant_identifier_names

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:booketlist/models/book.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';


class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  _BookPageState createState() => _BookPageState();
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _BookPageState extends State<BookPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _books = [];
  List<Book> _filteredBooks = [];

  @override
  void initState() {
    super.initState();
    _initBooks();
  }

  Future<void> refreshBooks() async {
    _books = await fetchProduct();
    _filterBooks(_searchController.text);
  }

  Future<void> _initBooks() async {
    _books = await fetchProduct();
    _filteredBooks = _books;
    setState(() {});
  }

  Future<List<Book>> fetchProduct() async {
    var url = Uri.parse('https://booketlist-production.up.railway.app/api/books/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Book> books = [];

    for (var d in data) {
      if (d != null) {
        if (d['fields']['image_url_s'] == null) {
          d['fields']['image_url_s'] =
              'http://images.amazon.com/images/P/0684823802.01.LZZZZZZZ.jpg';
          d['fields']['image_url_l'] =
              'http://images.amazon.com/images/P/0684823802.01.LZZZZZZZ.jpg';
        }
        books.add(Book.fromJson(d));
      }
    }
    return books;
  }

  Future<bool> isBookInWishlist(int bookId) async {
    final request = context.read<CookieRequest>();
    final response =
        await request.get('https://booketlist-production.up.railway.app/wishlist/api_wishlist/');

    for (var item in response) {
      if (item['pk'] == bookId) {
        return true;
      }
    }
    return false;
  }

  void _filterBooks(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        _filteredBooks = _books;
      } else {
        _filteredBooks = _books.where((book) {
          return book.fields.title
              .toLowerCase()
              .contains(searchTerm.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/boket.png',
                    height: 250,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Container(
                    height: 300,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Our Collections',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'serif',
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'brought to you by MinafCorp',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'serif',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 70.0,
              maxHeight: 70.0,
              child: Container(
                margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterBooks,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Search Books',
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterBooks('');
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.55,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  Book book = _filteredBooks[index];
                  Fields fields = book.fields;

                  return Card(
                    color: const Color.fromARGB(255, 186, 244, 212),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.network(fields.imageUrlL,
                                fit: BoxFit.cover),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            fields.title,
                            style: const TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          buttonPadding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 15.0),
                          children: [
                            FutureBuilder<bool>(
                              future: isBookInWishlist(book.pk),
                              builder: (BuildContext context,
                                  AsyncSnapshot<bool> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Icon(Icons.favorite,
                                      color: Colors.grey);
                                } else if (snapshot.hasError) {
                                  return const Icon(Icons.favorite,
                                      color: Colors.grey);
                                } else {
                                  return IconButton(
                                    icon: Icon(
                                      Icons.favorite,
                                      color: snapshot.data == true
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    onPressed: () async {
                                      var bookId = book.pk;

                                      try {
                                        final response = await request.postJson(
                                          "https://booketlist-production.up.railway.app/wishlist/add_to_wishlist_flutter/",
                                          jsonEncode(<String, String>{
                                            'book_id': bookId.toString()
                                          }),
                                        );

                                        if (response['success']) {
                                          await refreshBooks();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text(response['message'])),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Gagal memasukkan ke wishlist")),
                                          );
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Terjadi kesalahan saat menambahkan ke wishlist")),
                                        );
                                      }
                                    },
                                  );
                                }
                              },
                            ),                            
                          ],
                        ),
                      ],
                    ),
                  );
                },
                childCount: _filteredBooks.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
