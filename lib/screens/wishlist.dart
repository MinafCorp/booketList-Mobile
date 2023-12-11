import 'package:flutter/material.dart';
import 'package:booketlist/models/wishlistAPI.dart';
import 'package:booketlist/widgets/nav.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

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
        wishlists.add(Wishlist.fromJson(d));
      }
    }
    return wishlists;
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
          FutureBuilder(
            future: fetchWishlists(),
            builder: (context, AsyncSnapshot<List<Wishlist>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverFillRemaining(
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                    ),
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SliverFillRemaining(
                  child: const Center(
                    child: Text(
                      "Tidak ada data produk.",
                      style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                    ),
                  ),
                );
              }

              // Use SliverGrid directly instead of returning another CustomScrollView
              return SliverPadding(
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
                      Wishlist wishlist = snapshot.data![index];
                      Fields fields = wishlist.fields;
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
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
      bottomNavigationBar: BottomNav(
        selectedIndex: 2, // Assuming 0 is the home index
        onItemTapped: (int index) {
          // Replace with your navigation logic
        },
      ),
    );
  }
}
