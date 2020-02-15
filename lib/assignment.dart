import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




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
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Assignments'),
        elevation: 0.0,
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('Assignments').orderBy("created", descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return new Center(
              child: CircularProgressIndicator(),
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