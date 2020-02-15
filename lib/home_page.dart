import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todaysassignment/custom_plugin/dashboard_menu_button.dart';
import 'package:todaysassignment/functions/constants.dart';
import 'package:todaysassignment/routine.dart';

import 'assignment.dart';
import 'custom_plugin/drawer_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({this.onSignedOut});
  final VoidCallback onSignedOut;

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('/');
    } catch (e) {
      print(e);
    }
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: Drawer(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      FutureBuilder(
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
                            return UserAccountsDrawerHeader(
                              accountName:
                                  Text(snapshot.data.displayName.toString()),
                              accountEmail:
                                  Text(snapshot.data.email.toString()),
                              currentAccountPicture: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://picsum.photos/id/237/200/300'),
                              ),
                            );
                          }
                        },
                        future: FirebaseAuth.instance.currentUser(),
                      ),
                      DrawerButton(
                        title: 'Dashboard',
                        icon: Icons.apps,
                        onclick: () {},
                      ),
                      DrawerButton(
                        title: 'Routine',
                        icon: Icons.calendar_today,
                        onclick: () {},
                      ),
                      DrawerButton(
                        title: 'Assignment',
                        icon: Icons.assignment,
                        onclick: () {},
                      ),
                      DrawerButton(
                        title: 'Notice',
                        icon: Icons.notifications,
                        onclick: () {},
                      ),
                      DrawerButton(
                        title: 'Settings',
                        icon: Icons.settings,
                        onclick: () {},
                      ),
                      DrawerButton(
                        title: 'Contact us',
                        icon: Icons.email,
                        onclick: () {},
                      ),
                      DrawerButton(
                        title: 'About us',
                        icon: Icons.help,
                        onclick: () {},
                      ),
                      SizedBox(
                        height: kDefaultPadding,
                      ),
                    ],
                  ),
                ),
                DrawerButton(
                  title: 'Sign Out',
                  icon: Icons.close,
                  onclick: () {
                    widget.signOut(context);
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
//            bottom: TabBar(
//              tabs: <Widget>[
//                Tab(text: 'Home'),
//                Tab(text: 'Routine'),
//              ],
//            ),
            title: Text("Todays Assignment"),
          ),
//          body: TabBarView(
//            children: <Widget>[
//              GetAssignments(),
//              Routine(),
//            ],
//          ),
          body: ListView(
            children: <Widget>[
              ListTile(
                title: Text('Farewell Party'),
                subtitle: Text('2020-02-20'),
                leading: Icon(Icons.notifications),
              ),
              ListTile(
                title: Text('Farewell Party'),
                subtitle: Text('2020-02-20'),
                leading: Icon(Icons.notifications),
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      DashboardButton(
                        icon: Icons.account_circle,
                        title: 'Profile',
                        onClick: (){

                        },
                      ),
                      DashboardButton(
                        icon: Icons.calendar_today,
                        title: 'Routine',
                        onClick: (){
                          Navigator.of(context).pushNamed('/routine');
                        },
                      ),
                      DashboardButton(
                        icon: Icons.assignment,
                        title: 'Assignment',
                        onClick: (){
                          Navigator.of(context).pushNamed('/assignment');
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      DashboardButton(
                        icon: Icons.book,
                        title: 'Exams',
                        onClick: (){

                        },
                      ),
                      DashboardButton(
                        icon: Icons.notifications,
                        title: 'Notice',
                        onClick: (){

                        },
                      ),
                      DashboardButton(
                        icon: Icons.ac_unit,
                        title: 'Holiday',
                        onClick: (){

                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
