  import 'package:booketlist/screens/landing.dart';
  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'package:pbp_django_auth/pbp_django_auth.dart';

  void main() {
    runApp(const MyApp());
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
     return Provider(create: (_){
        CookieRequest request = CookieRequest();
        return request;
     },
       child: MaterialApp(
         title: 'BooketList',
         theme: ThemeData(
           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
           useMaterial3: true,
         ),
         home: MyHomePage(),
       ),
     );
    }
  }