import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:booketlist/models/updates.dart';
import 'package:booketlist/screens/author/update_form.dart';
import 'package:flutter/material.dart';
import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:intl/intl.dart';

class UpdateAuthorPage extends StatefulWidget {
  const UpdateAuthorPage({super.key});

  @override
  State<UpdateAuthorPage> createState() => _UpdateAuthorPageState();
}


class _UpdateAuthorPageState extends State<UpdateAuthorPage> {
  final TextEditingController _searchController = TextEditingController();

  Future<List<Updates>> fetchUpdates() async {
      var url = Uri.parse(
          'http://127.0.0.1:8000/updates/get-updates-all');
      var response = await http.get(
          url,
          headers: {"Content-Type": "application/json"},
      );
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      List<Updates> list_updates = [];
      for (var d in data) {
          if (d != null) {
              list_updates.add(Updates.fromJson(d));
          }
      }
      return list_updates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 227, 215),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 151, 138, 116),
        title: AnimatedSearchBar(
            label: 'Search Updates',
            controller: _searchController,
            labelStyle: const TextStyle(fontSize: 16),
            searchStyle: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            textInputAction: TextInputAction.done,
            searchDecoration: const InputDecoration(
              hintText: 'Search',
              alignLabelWithHint: true,
              fillColor: Colors.white,
              focusColor: Colors.white,
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
            onChanged: (value) {
              debugPrint('value on Change');
              setState(() {
                //belum
              });
            },
            onFieldSubmitted: (value) {
              debugPrint('value on Field Submitted');
              setState(() {
                //belum
              });
            }),
      ),
      // body: const SingleChildScrollView(
      //   child: Padding(
      //       padding: EdgeInsets.all(10.0), // Set padding dari halaman
      //       child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: <Widget>[
      //             Align(
      //               alignment: Alignment.center,
      //               // Widget Text untuk menampilkan tulisan dengan alignment center dan style yang sesuai
      //               child: Image(image: AssetImage('images/title.png')),
      //             ),
      //             SizedBox(height: 30),
      //           ])),
      // ),
      body: FutureBuilder(
            future: fetchUpdates(),
            builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                } else {
                    if (!snapshot.hasData) {
                    return const Column(
                        children: [
                        Text(
                            "Tidak ada data produk.",
                            style:
                                TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        ],
                    );
                } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) => Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 236, 227, 215),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2), // Shadow color
                                      spreadRadius: 2, // Spread radius
                                      blurRadius: 6, // Blur radius
                                      offset: Offset(0, 1), // Offset from the top-left corner
                                    ),
                                  ],
                                ),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    Text(
                                    "${snapshot.data![index].fields.title}",
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                        "${snapshot.data![index].fields.content}",
                                        textAlign: TextAlign.left,
                                        ),
                                    const SizedBox(height: 7),
                                    Text(
                                        "@${snapshot.data![index].fields.authorUsername} • posted on ${DateFormat('yyyy-MM-dd').format(snapshot.data![index].fields.dataAdded)}",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10.0,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        )
                                ],
                                ),
                            ));
                    }
                }
            }),
            floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdateFormPage(),
                ));
            },

            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 67, 64, 59),
            child: const Icon(Icons.create),
        ),
    );
  }
}
