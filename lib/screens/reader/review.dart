// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, constant_identifier_names, unused_local_variable, non_constant_identifier_names, use_key_in_widget_constructors
import 'package:flutter/material.dart' hide Action;
import 'package:booketlist/models/book.dart';
import 'package:booketlist/models/review.dart' as review;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  bool isReviewTabDataFetched = false;

  Future<List<review.Product>> fetchProductAll() async {
    var url = Uri.parse(
        'https://booketlist-production.up.railway.app/wishlist/json/all/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<review.Product> list_Book = [];
    for (var d in data) {
      if (d != null) {
        list_Book.add(review.Product.fromJson(d));
      }
    }
    return list_Book;
  }

  Future<List<review.Product>> fetchProductUser() async {
    final request = context.watch<CookieRequest>();
    final response = await request.get(
        'https://booketlist-production.up.railway.app/wishlist/json/user/');
    List<review.Product> wishlists = [];
    for (var d in response) {
      if (d != null) {
        wishlists.add(review.Product.fromJson(d));
      }
    }
    return wishlists;
  }

  Future<List<Book>> fetchBook() async {
    var url =
        Uri.parse('https://booketlist-production.up.railway.app/api/books/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Book> list_Book = [];
    for (var d in data) {
      if (d != null) {
        list_Book.add(Book.fromJson(d));
      }
    }
    return list_Book;
  }

  void _openReviewForm() async {
    List<Book> Books = await fetchBook();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return YourReviewFormWidget(Books);
      },
    );
  }

  void _openEditReviewForm(review.Product product) async {
    // Wrap the single product in a list
    List<review.Product> products = [product];
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return YourEditReviewFormWidget(
            products); // Pass a list with a single product
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Community Review'),
              Tab(text: 'Your Review'),
            ],
          ),
        ),
        body: TabBarView(
          physics:
              const NeverScrollableScrollPhysics(), // Disable swiping between tabs
          children: [
            FutureBuilder(
              future: fetchProductAll(),
              builder: (context, AsyncSnapshot<List<review.Product>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Display a loading indicator while data is being fetched
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No data available");
                } else {
                  var data = snapshot.data;
                  return ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      var product = data[index];
                      var created_by = (product.fields.createdBy);
                      var title = (product.fields.judulBuku);

                      if (created_by != null) {
                        return ListTile(
                          title: Text(product.fields.reviewText),
                          subtitle: Text(
                              "~ review by $created_by to a book named ${product.fields.judulBuku}"),
                          // Add more widgets to display other information as needed
                        );
                      } else {
                        return ListTile(
                          title: Text(product.fields.reviewText),
                          subtitle: const Text(
                              "~ review by Anonymous on an unknown book"),
                          // Add more widgets to display other information as needed
                        );
                      }
                    },
                  );
                }
              },
            ),
            FutureBuilder(
              future: fetchProductUser(),
              builder: (context, AsyncSnapshot<List<review.Product>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Display a loading indicator while data is being fetched
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No data available");
                } else {
                  var data = snapshot.data;
                  return ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      var product = data[index];
                      var created_by = (product.fields.createdBy);
                      if (created_by != null) {
                        return ListTile(
                          title: Text(product.fields.reviewText),
                          subtitle: Text(
                              "Your review to a book named ${product.fields.judulBuku}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _openEditReviewForm(product);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  var bookId = product.pk;
                                  try {
                                    final response = await request.postJson(
                                      "https://booketlist-production.up.railway.app/wishlist/delete_review_flutter/$bookId/",
                                      jsonEncode(<String, String>{
                                        'book_id': bookId.toString()
                                      }),
                                    );

                                    if (response['success']) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            // ignore: prefer_interpolation_to_compose_strings
                                            content: Text(
                                                "${"Selamat!" + response['message']}, silahkan refresh dengan pergi ke page lain!!")),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text("Gagal mendelete review")),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Terjadi kesalahan saat menghapus")),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          // Add more widgets to display other information as needed
                        );
                      } else {
                        return ListTile(
                          title: Text(product.fields.reviewText),
                          subtitle: const Text(
                              "~ review by you to on an unknown book"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Implement edit functionality here
                                  // You can open a dialog or navigate to another screen for editing
                                  // You may need to pass the current review details to the edit screen
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  var bookId = product.pk;
                                  try {
                                    final response = await request.postJson(
                                      "https://booketlist-production.up.railway.app/wishlist/delete_review_flutter/$bookId/",
                                      jsonEncode(<String, String>{
                                        'book_id': bookId.toString()
                                      }),
                                    );
                                    if (response['success']) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(response['message'])),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text("Gagal mendelete review")),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Terjadi kesalahan saat menghapus")),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          // Add more widgets to display other information as needed
                        );
                      }
                    },
                  );
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openReviewForm,
          tooltip: 'Add Review',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class YourReviewFormWidget extends StatefulWidget {
  final List<Book> books;

  const YourReviewFormWidget(this.books);

  @override
  _YourReviewFormWidgetState createState() => _YourReviewFormWidgetState();
}

class YourEditReviewFormWidget extends StatefulWidget {
  final List<review.Product> product;

  const YourEditReviewFormWidget(this.product);

  @override
  _YourEditReviewFormWidgetState createState() =>
      _YourEditReviewFormWidgetState();
}

class _YourEditReviewFormWidgetState extends State<YourEditReviewFormWidget> {
  String _reviewController = "";
  int? _selectedRating;

  bool _isFormValid() {
    return _reviewController.isNotEmpty && _selectedRating != null;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final String createdBy =
        widget.product.first.fields.reviewRating.toString();
    final String bookReview = widget.product.first.fields.reviewText;
    final int bookId = widget.product.first.pk;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: _reviewController,
            decoration: InputDecoration(labelText: bookReview),
            onChanged: (String value) {
              setState(() {
                _reviewController = value;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            value: _selectedRating,
            hint: Text(
                "current rating : $createdBy"), // Display the user's name dynamically
            onChanged: (value) {
              setState(() {
                _selectedRating = value;
              });
            },
            items: [1, 2, 3].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isFormValid()
                ? () async {
                    String review = _reviewController;
                    if (review.isNotEmpty && _selectedRating != null) {
                      final response = await request.postJson(
                        "https://booketlist-production.up.railway.app/wishlist/edit_review_flutter/",
                        jsonEncode({
                          'review': review,
                          'rating': _selectedRating,
                          'book': bookId,
                        }),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "Selamat! kamu telah berhasil mengedit! silahkan refresh dengan pergi ke page lain")),
                      );
                    }

                    Navigator.pop(context);
                  }
                : null,
            child: const Text('Submit Review'),
          ),
        ],
      ),
    );
  }
}

class _YourReviewFormWidgetState extends State<YourReviewFormWidget> {
  String _reviewController = "";
  int? _selectedRating;
  String? _selectedBook = "";

  bool _isFormValid() {
    return _reviewController.isNotEmpty &&
        _selectedRating != null &&
        _selectedBook != "";
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [ 
          TextFormField(
            initialValue: _reviewController,
            decoration:
                const InputDecoration(labelText: 'Write to community review'),
            onChanged: (String value) {
              setState(() {
                _reviewController = value;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            value: _selectedRating,
            hint: const Text('Select Rating'),
            onChanged: (value) {
              setState(() {
                _selectedRating = value;
              });
            },
            items: [1, 2, 3].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedBook,
            hint: const Text('Select'),
            onChanged: (value) {
              setState(() {
                _selectedBook = value;
              });
            },
            items: [
              const DropdownMenuItem(
                value: '',
                child: Text('Choose the book...',overflow: TextOverflow.ellipsis,),
              ),
              ...widget.books.map<DropdownMenuItem<String>>((Book book) {
                return DropdownMenuItem<String>(
                  value: book.pk.toString(),
                  child: Text(book.fields.title, overflow: TextOverflow.ellipsis,),
                );
              })
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _isFormValid()
                ? () async {
                    String review = _reviewController;
                    if (review.isNotEmpty &&
                        _selectedRating != null &&
                        _selectedBook != null) {
                      final response = await request.postJson(
                        "https://booketlist-production.up.railway.app/wishlist/add_to_review_flutter/",
                        jsonEncode({
                          'review': review,
                          'rating': _selectedRating,
                          'book': int.parse(_selectedBook!),
                        }),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "Selamat! kamu telah berhasil menambah Review! silahkan refresh dengan pergi ke page lain")),
                      );
                    }

                    Navigator.pop(context);
                  }
                : null,
            child: const Text('Submit Review'),
          ),
        ],
      ),
    );
  }
}
