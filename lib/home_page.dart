import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todaysassignment/routine.dart';

import 'assignment.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

Future<void> signOut() async {
  return FirebaseAuth.instance.signOut();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text("Choose you preferences"),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                  ),
                ),
                ListTile(
                  title: Text("Sign Out"),
                  onTap: signOut,
                ),
              ],
            ),
          ),
          appBar: AppBar(
            bottom: TabBar(
              tabs: <Widget>[
                Tab(text: 'Home'),
                Tab(text: 'Routine'),
              ],
            ),
            title: Text("Todays Assignment"),
          ),
          body: TabBarView(
            children: <Widget>[
              GetAssignments(),
              Routine(),
            ],
          ),
        ),
      ),
    );
  }
}
