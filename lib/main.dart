import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'routine.dart';
import 'assignment.dart';
import 'auth.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
// This widget is the root of your application.

  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      theme: ThemeData(
//        primarySwatch: Colors.teal,
//      ),
//      darkTheme: ThemeData.dark().copyWith(
//        primaryColor: Colors.black,
//      ),
//      home: DefaultTabController(
//        length: 2,
//        child: Scaffold(
//          drawer: Drawer(
//            child: ListView(
//              padding: EdgeInsets.zero,
//              children: <Widget>[
//                DrawerHeader(
//                  child: Text("Choose you preferences"),
//                  decoration: BoxDecoration(
//                    color: Colors.teal,
//                  ),
//                ),
//                ListTile(
//                  title: Text("Item 1"),
//                ),
//              ],
//            ),
//          ),
//          appBar: AppBar(
//            bottom: TabBar(
//              tabs: <Widget>[
//                Tab(text: 'Home'),
//                Tab(text: 'Routine'),
//              ],
//            ),
//            title: Text("Todays Assignment"),
//          ),
//          body: TabBarView(
//            children: <Widget>[
//              GetAssignments(),
//              Routine(),
//            ],
//          ),
//        ),
//      ),
//    );
//  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
//      darkTheme: ThemeData.dark().copyWith(
//        primaryColor: Colors.black,
//      ),
      home: LogInForm(),
    );
  }
}