import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:booketlist/models/book.dart';

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  Future<List<Book>> fetchProduct() async {
    var url =
        Uri.parse('https://booketlist-production.up.railway.app/api/books/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
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
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'List Book',
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: fetchProduct(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return const Text(
              "Tidak ada data produk.",
              style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
            );
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 10, // Jarak antar card horizontal
                mainAxisSpacing: 10, // Jarak antar card vertikal
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                Book book = snapshot.data![index];
                Fields fields = book.fields;

                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.all(10), // Margin di sekeliling card
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            4.0), // Radius gambar sesuai desain
                        child:
                            Image.network(fields.imageUrlL, fit: BoxFit.cover),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          fields.title,
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceAround,
                        buttonPadding:
                            EdgeInsets.zero, // Menghilangkan padding default
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite,
                                color: Colors.red), // Warna icon sesuai desain
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.comment,
                                color: Colors.grey), // Warna icon sesuai desain
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
