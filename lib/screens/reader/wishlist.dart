// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, library_private_types_in_public_api, constant_identifier_names
import 'package:flutter/material.dart';
import 'package:booketlist/models/wishlistAPI.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  Future<List<Wishlist>> fetchWishlists() async {
    final request = context.watch<CookieRequest>();
    final response =
        await request.get('http://127.0.0.1:8000/wishlist/api_wishlist/');
    List<Wishlist> wishlists = [];
    for (var d in response) {
      if (d != null) {
        if (d['fields']['image_url_s'] == null) {
          d['fields']['image_url_s'] =
              'http://images.amazon.com/images/P/0684823802.01.LZZZZZZZ.jpg';
          d['fields']['image_url_l'] =
              'http://images.amazon.com/images/P/0684823802.01.LZZZZZZZ.jpg';
        }
        wishlists.add(Wishlist.fromJson(d));
      }
    }
    return wishlists;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
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
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your Book Wishlist',
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
                        'Make your Wishes Meet Reality',
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
                  ElevatedButton(
                    onPressed: () {
                      // Add your onPressed functionality here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                          0xFF6F4E37), // Brown color, adjust as necessary
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30.0), // Rounded edges
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20), // Padding
                    ),
                    child: const Row(
                      mainAxisSize:
                          MainAxisSize.min, // To wrap the content of the row
                      children: [
                        Text(
                          'Cari Wishlistmu!', // The text inside the button
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(width: 10), // Space between text and icon
                        Icon(
                          Icons.search, // The search icon
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder(
            future: fetchWishlists(),
            builder: (context, AsyncSnapshot<List<Wishlist>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(
                          color: Color(0xff59A5D8), fontSize: 20),
                    ),
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      "Tidak ada data produk.",
                      style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                    ),
                  ),
                );
              }

              return SliverPadding(
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
                      Wishlist wishlist = snapshot.data![index];
                      Fields fields = wishlist.fields;
                      var bookId = wishlist.pk;

                      return Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(25), // Rounded corners
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
                            // Box-shaped Delete button
                            Container(
                              alignment: Alignment.center,
                              color: Colors.red,
                              child: TextButton(
                                onPressed: () async {
                                  try {
                                    final response = await request.postJson(
                                      "http://127.0.0.1:8000/wishlist/delete-wishlist-book/$bookId/",
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

                                      setState(() {
                                        fetchWishlists();
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Gagal menghapus dari wishlist")),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Terjadi kesalahan saat menghapus dari wishlist")),
                                    );
                                  }
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 36),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
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
                      );
                    },
                    childCount: snapshot.data!.length,
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
