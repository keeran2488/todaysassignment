import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todaysassignment/root_page.dart';
import 'routine.dart';
import 'assignment.dart';
import 'auth.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
// This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RootPage(),
    );
  }
}