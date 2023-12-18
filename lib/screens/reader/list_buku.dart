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

class _BookPageState extends State<BookPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _books = [];
  List<Book> _filteredBooks = [];

  @override
  void initState() {
    super.initState();
    _initBooks();
  }

  Future<void> _initBooks() async {
    _books = await fetchProduct();
    _filteredBooks = _books;
    setState(() {}); // Refresh the UI after the books are loaded
  }

  Future<List<Book>> fetchProduct() async {
    var url = Uri.parse('http://127.0.0.1:8000/api/books/');
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'BooketList',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(255, 47, 31, 4),
              fontSize: 45,
              fontWeight: FontWeight.bold,
              fontFamily: 'serif',
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Our Collections',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Lobster',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
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
                            IconButton(
                              icon: const Icon(Icons.favorite,
                                  color: Colors.grey),
                              onPressed: () async {
                                var bookId = book.pk;

                                try {
                                  final response = await request.postJson(
                                    "http://127.0.0.1:8000/wishlist/add_to_wishlist_flutter/",
                                    jsonEncode(<String, String>{
                                      'book_id': bookId.toString()
                                    }),
                                  );

                                  if (response['success']) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(response['message'])),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Gagal memasukkan ke wishlist")),
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Terjadi kesalahan saat menambahkan ke wishlist")),
                                  );
                                }
                              },
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.comment, color: Colors.grey),
                              onPressed: () {},
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
