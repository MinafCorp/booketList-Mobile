import 'package:booketlist/screens/author/booklist_form.dart';
import 'package:flutter/material.dart';
import 'package:booketlist/models/book.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class HomeAuthorPage extends StatefulWidget {
  const HomeAuthorPage({super.key});

  @override
  _HomeAuthorPageState createState() => _HomeAuthorPageState();
}

class _HomeAuthorPageState extends State<HomeAuthorPage> {
  Future<List<Book>> fetchBooks() async {
    final request = context.watch<CookieRequest>();
    final response = await request
        .get('http://127.0.0.1:8000/manajemen-buku/get_books_json/');
    List<Book> books = [];
    for (var d in response) {
      if (d != null) {
        if (d['fields']['image_url_s'] == null) {
          d['fields']['image_url_s'] = 'images/wp.jpg';
        }
        books.add(Book.fromJson(d));
      }
    }
    return books;
  }

  // Future<void> deleteBook(int isbn) async {
  //   var url = Uri.parse(
  //       'http://127.0.0.1:8000/api/manajemen-buku/delete_book/isbn/$isbn');

  //   // var response = await http.delete(url);
  // }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 227, 215),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset(
                  'images/boket.png',
                  height: 300,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Container(
                  height: 300,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
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
                  const Text(
                    "Your Creation",
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
          FutureBuilder<List<Book>?>(
            future: fetchBooks(),
            builder: (context, AsyncSnapshot<List<Book>?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      "Error: TAI${snapshot.error}",
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                );
              }
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      "You have not added any books",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      Book book = snapshot.data![index];
                      Fields fields = book.fields;
                      var isbn = book.pk;
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Card(
                              color: Colors.white,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 4.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: fields.imageUrlL.isNotEmpty
                                        ? Image.network(
                                            fields.imageUrlL,
                                            fit: BoxFit.cover,
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return Image.asset(
                                                  'images/wp.jpg',
                                                  fit: BoxFit.cover);
                                            },
                                          )
                                        : Image.asset('images/wp.jpg',
                                            fit: BoxFit.cover),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      fields.title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    color: Colors.red,
                                    child: TextButton(
                                      onPressed: () async {
                                        try {
                                          final response =
                                              await request.postJson(
                                            "http://127.0.0.1:8000/manajemen-buku/delete_author_book/$isbn/",
                                            jsonEncode(
                                                <String, int>{'book_id': isbn}),
                                          );

                                          if (response['success']) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      response['message'])),
                                            );

                                            setState(() {
                                              fetchBooks();
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      "Gagal menghapus dari your books")),
                                            );
                                          }
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Terjadi kesalahan saat menghapus dari yout books")),
                                          );
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        minimumSize:
                                            const Size(double.infinity, 36),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: snapshot.data!.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const BookFormPage()), // Ganti dengan halaman tujuan Anda
          );
        },
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 67, 64, 59),
        child: const Icon(Icons.add),
      ),
    );
  }
}
