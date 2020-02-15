import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todaysassignment/root_page.dart';
import 'package:todaysassignment/user_profile.dart';
import 'home_page.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
// This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => RootPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}