import 'package:booketlist/models/review.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:booketlist/models/book.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  Future<List<Product>> fetchReviewAll() async {
    var url = Uri.parse('http://127.0.0.1:8000/wishlist/json/all');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Product> list_product = [];
    for (var d in data) {
      if (d != null) {
        list_product.add(Product.fromJson(d));
      }
    }
    return list_product;
  }

  Future<List<Product>> fetchReviewUser() async {
    var url = Uri.parse('http://127.0.0.1:8000/wishlist/json/user');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Product> list_product = [];
    for (var d in data) {
      if (d != null) {
        list_product.add(Product.fromJson(d));
      }
    }
    return list_product;
  }
  

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return DefaultTabController(
      length: 2, // Number of tabs
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
          children: [
            // Content for the "All Review" tab
            Center(
              child: Text(
                "Here is all the review by all users",
                style: TextStyle(fontSize: 20),
              ),
            ),

            // Content for the "Your Review" tab
            Center(
              child: Text(
                "Here is the review you've made",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
