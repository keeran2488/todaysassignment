import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todaysassignment/root_page.dart';
import 'home_page.dart';
import 'routine.dart';
import 'assignment.dart';
import 'auth.dart';

void main(){
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
// This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => RootPage(),
        '/home': (context) => HomePage(),
        '/assignment': (context) => GetAssignments(),
        '/routine': (context) => Routine(),
      },
    );
  }
}