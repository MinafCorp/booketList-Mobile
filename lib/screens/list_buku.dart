import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:booketlist/models/book.dart';
import 'package:booketlist/widgets/nav.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  Future<List<Book>> fetchProduct() async {
    var url = Uri.parse('http://127.0.0.1:8000/api/books/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Book> list_product = [];
    for (var d in data) {
      if (d != null) {
        list_product.add(Book.fromJson(d));
      }
    }
    return list_product;
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
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
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
      body: FutureBuilder(
        future: fetchProduct(),
        builder: (context, AsyncSnapshot<List<Book>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Tidak ada data produk.",
                style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
              ),
            );
          }
          return CustomScrollView(
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
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.55,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      Book book = snapshot.data![index];
                      Fields fields = book.fields;

                      return Card(
                        color: Color.fromARGB(255, 186, 244, 212),
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
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.center,
                              buttonPadding: EdgeInsets.symmetric(
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
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text(response['message'])),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Gagal memasukkan ke wishlist")),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Terjadi kesalahan saat menambahkan ke wishlist")),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.comment,
                                      color: Colors.grey),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: snapshot.data!.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNav(
        selectedIndex: 1,
        onItemTapped: (index) {},
      ),
    );
  }
}
