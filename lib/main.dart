import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());


class Routine extends StatelessWidget {
  final String day =  DateFormat('EEEE').format(DateTime.now().add(Duration(hours: 8)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('Routine').document(day).collection("Sem V").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: Text("Loading"),
            );
          return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data.documents[index].data["Subject"]),
                  subtitle: Text(snapshot.data.documents[index].data["Time"]),
                  onTap: (){

                  },
                );
              });
        },
      ),
    );
  }
}

class AddAssignment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Assignment"),
      ),
      body: MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final db = Firestore.instance;
  String subject, title;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter Subject';
                }
                return null;
              },
              onSaved: (String value) {
                subject = value;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: "Subject",
                border: InputBorder.none,
                filled: true,
//                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter title";
                }
                return null;
              },
              onSaved: (String value) {
                title = value;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: "Title",
                border: InputBorder.none,
                filled: true,
//                fillColor: Colors.grey[200],
              ),
            ),
          ),
          RaisedButton(
            color: Colors.greenAccent,
            child: Text("Save"),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                await db
                    .collection('Assignments').add({'Title': title, 'Subject': subject, 'created': FieldValue.serverTimestamp()});
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {

//  final QuerySnapshot querySnapshot;
  // This widget is the root of your application.

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
                  title: Text("Item 1"),
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

class GetAssignments extends StatefulWidget {
  @override
  _GetAssignmentsState createState() => _GetAssignmentsState();
}

class _GetAssignmentsState extends State<GetAssignments> {

  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState(){
    super.initState();

    _fcm.subscribeToTopic("assignmentNotifications");

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final snackBar = SnackBar(
          content: Text("New assignment added!"),
          backgroundColor: Colors.teal,
        );
        Scaffold.of(context).showSnackBar(snackBar);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('Assignments').orderBy("created", descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return new Center(
              child: Text("Loading....."),
            );
          return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data.documents[index].data["Title"]),
                  subtitle:
                      Text(snapshot.data.documents[index].data["Subject"]),
                );
              });
        },
      ),
    );
  }
}
