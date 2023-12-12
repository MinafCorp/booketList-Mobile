import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:booketlist/models/book.dart';

class HomeReaderPage extends StatefulWidget {
  const HomeReaderPage({Key? key}) : super(key: key);

  @override
  _HomeReaderPageState createState() => _HomeReaderPageState();
}

class _HomeReaderPageState extends State<HomeReaderPage> {
  Future<List<Book>> fetchBooks() async {
    var url = Uri.parse('http://127.0.0.1:8000/api/books/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Book> books = [];
    for (var d in data) {
      if (d != null) {
        books.add(Book.fromJson(d));
      }
    }
    return books.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                // Full-width image at the top of the page
                Image.asset(
                  'images/boket.png',
                  height: 300,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),

                Container(
                  height: 300,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Embark on a journey of imagination',
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
                        'Brought to you by MinafCorp',
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
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    "Editor's Choice",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 47, 31, 4),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // FutureBuilder to build the grid of latest books
          FutureBuilder<List<Book>>(
            future: fetchBooks(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      "No books found.",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                );
              } else {
                return SliverPadding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          30.0), // Menambahkan padding horizontal yang lebih besar
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Dua buku per baris
                      childAspectRatio:
                          0.6, // Mengatur aspek rasio untuk kartu buku yang lebih ramping
                      crossAxisSpacing:
                          20, // Jarak antar kartu secara horizontal
                      mainAxisSpacing: 20, // Jarak antar kartu secara vertikal
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        Book book = snapshot.data![index];
                        Fields fields = book.fields;
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: Offset(2, 2), // Posisi bayangan
                              ),
                            ],
                          ),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  25), // Sudut yang lebih bulat
                            ),
                            elevation: 4.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    fields.imageUrlL,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  alignment:
                                      Alignment.center, // Teks judul di tengah
                                  padding: const EdgeInsets.all(
                                      12.0), // Padding untuk judul
                                  child: Text(
                                    fields.title,
                                    textAlign:
                                        TextAlign.center, // Teks ditengahkan
                                    style: TextStyle(
                                      fontSize:
                                          14.0, // Ukuran font disesuaikan dengan keinginan
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: snapshot.data!.length,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
