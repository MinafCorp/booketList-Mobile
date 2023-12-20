// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, library_private_types_in_public_api, constant_identifier_names
import 'package:flutter/material.dart';
import 'package:booketlist/models/wishlistendpoint.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _WishlistPageState extends State<WishlistPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Wishlist> _wishlists = [];
  List<Wishlist> _filteredWishlists = [];

  @override
  void initState() {
    super.initState();
    _initWishlists();
  }

  Future<void> _initWishlists() async {
    _wishlists = await fetchWishlists();
    _filteredWishlists = _wishlists;
    setState(() {}); // Refresh the UI after the wishlists are loaded
  }

  Future<List<Wishlist>> fetchWishlists() async {
    final request = context.read<CookieRequest>();
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

  void _filterWishlists(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        _filteredWishlists = _wishlists;
      } else {
        _filteredWishlists = _wishlists.where((wishlist) {
          return wishlist.fields.title
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: false,
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/wishlists.jpg',
                    height: 250,
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
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 70.0,
              maxHeight: 70.0,
              child: Container(
                margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterWishlists,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Cari Wishlistmu',
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterWishlists('');
                        },
                      ),
                    ),
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
                  Wishlist wishlist = _filteredWishlists[index];
                  Fields fields = wishlist.fields;
                  var bookId = wishlist.pk;
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
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
                        Container(
                          alignment: Alignment.center,
                          color: Colors.red,
                          child: TextButton(
                            onPressed: () async {
                              final response =
                                  await context.read<CookieRequest>().postJson(
                                        "http://127.0.0.1:8000/wishlist/delete-wishlist-book/$bookId/",
                                        jsonEncode(<String, String>{
                                          'book_id': bookId.toString()
                                        }),
                                      );
                              if (response['success']) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(response['message'])),
                                );
                                _initWishlists(); // Refresh the wishlists after deletion
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Failed to remove from wishlist")),
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
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                childCount: _filteredWishlists.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
