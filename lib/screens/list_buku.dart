import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:booketlist/models/book.dart'; // Sesuaikan dengan struktur model Book Anda
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  Future<List<Book>> fetchProduct() async {
    var url =
        Uri.parse('https://booketlist-production.up.railway.app/api/books/');
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
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'BooketList',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontFamily: 'DancingScript',
              ),
            ),
            Text(
              'Our Curated Collections',
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
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
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.55,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (_, index) {
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
                        child:
                            Image.network(fields.imageUrlL, fit: BoxFit.cover),
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
                      buttonPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.grey),
                          onPressed: () async {
                            var bookId = book.pk;
                            var url = Uri.parse(
                                'https://booketlist-production.up.railway.app/wishlist/add_to_wishlist/$bookId/');

                            try {
                              final response = await request.postJson(
                                url.toString(),
                                '', // Mengirim request POST kosong
                              );

                              if (response.statusCode == 200) {
                                var data = json.decode(response.body);
                                String message = data['success']
                                    ? data['message']
                                    : 'Gagal mengubah wishlist';
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)));
                              } else {
                                print(
                                    'Error: ${response.statusCode} - ${response.body}');
                              }
                            } catch (e) {
                              print('Exception: $e');
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.comment, color: Colors.grey),
                          onPressed: () {
                            // Placeholder for comment button functionality
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
