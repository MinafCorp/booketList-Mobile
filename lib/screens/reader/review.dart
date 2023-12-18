import 'package:flutter/material.dart' hide Action;
import 'package:booketlist/models/book.dart';
import 'package:booketlist/models/review.dart' as review;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  bool isReviewTabDataFetched = false;

  Future<List<review.Product>> fetchProductAll() async {
    var url = Uri.parse('http://127.0.0.1:8000/wishlist/json/all/');
    var response = await http.get(url, headers: {"Content-Type": "application/json"});

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
    var url = Uri.parse('http://127.0.0.1:8000/wishlist/json/user/');
    var response = await http.get(url, headers: {"Content-Type": "application/json"});
  

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<review.Product> list_Book = [];
    for (var d in data) {
      if (d != null) {
        list_Book.add(review.Product.fromJson(d));
      }
    }
    print(list_Book);
    return list_Book;
  }

  Future<List<Book>> fetchBook() async {
    var url = Uri.parse('http://127.0.0.1:8000/api/books/');
    var response = await http.get(url, headers: {"Content-Type": "application/json"});

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
          bottom: TabBar(
            tabs: [
              Tab(text: 'Review'),
              Tab(text: 'Your Review'),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(), // Disable swiping between tabs
          children: [FutureBuilder(
      future: fetchProductAll(),
      builder: (context, AsyncSnapshot<List<review.Product>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Display a loading indicator while data is being fetched
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text("No data available");
        } else {
          var data = snapshot.data;
          return ListView.builder(
            itemCount: data!.length,
            itemBuilder: (context, index) {
              var product = data[index];
              return ListTile(
                title: Text(product.fields.reviewText),
                subtitle: Text(""),
                // Add more widgets to display other information as needed
              );
            },
          );
        }
      },
    ),
            Center(
              child: Text(
                "Here is the review you've made",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openReviewForm,
          tooltip: 'Add Review',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class YourReviewFormWidget extends StatefulWidget {
  final List<Book> books;

  YourReviewFormWidget(this.books);

  @override
  _YourReviewFormWidgetState createState() => _YourReviewFormWidgetState();
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
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: _reviewController,
            decoration: InputDecoration(labelText: 'Review'),
            onChanged: (String value) {
              setState(() {
                _reviewController = value;
              });
            },
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<int>(
            value: _selectedRating,
            hint: Text('Select Rating'),
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
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedBook,
            hint: Text('Select Book'),
            onChanged: (value) {
              setState(() {
                _selectedBook = value;
              });
            },
            items: [
              const DropdownMenuItem(
                value: '',
                child: Text('Title'),
              ),
              ...widget.books.map<DropdownMenuItem<String>>((Book book) {
                return DropdownMenuItem<String>(
                  value: book.pk.toString(),
                  child: Text(book.fields.title),
                );
              }).toList()
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isFormValid()
                ? () async {
                    String review = _reviewController;
                    if (review.isNotEmpty &&
                        _selectedRating != null &&
                        _selectedBook != null) {
                      print('Review: $review, Rating: $_selectedRating, Book: $_selectedBook');
                      final response = await request.postJson(
                        "http://127.0.0.1:8000/wishlist/add_to_review_flutter/",
                        jsonEncode({
                          'review': review,
                          'rating': _selectedRating,
                          'book': int.parse(_selectedBook!),
                        }),
                      );
                    }

                    Navigator.pop(context);
                  }
                : null,
            child: Text('Submit Review'),
          ),
        ],
      ),
    );
  }
}
