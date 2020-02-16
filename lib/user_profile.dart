import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'custom_plugin/button.dart';
import 'custom_plugin/inputfield.dart';
import 'functions/constants.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String _firstName = "Hello", _lastName, _section, _group, _uid;
  final GlobalKey<FormState> _userProfileFormKey = GlobalKey<FormState>();

  final db = Firestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;

  Future getUserDetails() async {
    FirebaseUser userS = await _firebaseAuth.currentUser();
    _uid = userS.uid;
    DocumentSnapshot ds = await db.collection("User").document(_uid).get();
    return ds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome User"),
          elevation: 0.0,
        ),
        body: FutureBuilder(
            future: getUserDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Container(
                  child: Form(
                    key: _userProfileFormKey,
                    child: ListView(
                      children: <Widget>[
                      SizedBox(
                      height: kDefaultPadding,
                    ),
                    CustomTextForm(
                      initialValue: snapshot.data["First Name"],
                      title: 'First Name',
                      obscureText: false,
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Please enter your first name.";
                        } else if (!input.contains(RegExp(r'[a-zA-Z]'))) {
                          return "Enter a valid name.";
                        }
                        return null;
                      },
                      onSaved: (input) => _firstName = input,
                    ),
                        SizedBox(
                          height: kDefaultPadding,
                        ),
                        CustomTextForm(
                          initialValue: snapshot.data["Last Name"],
                          title: 'Last Name',
                          obscureText: false,
                          validator: (input) {
                            if (input.isEmpty) {
                              return "Please enter your Last name.";
                            } else if (!input.contains(RegExp(r'[a-zA-Z]'))) {
                              return "Enter a valid name.";
                            }
                            return null;
                          },
                          onSaved: (input) => _lastName = input,
                        ),
                        SizedBox(
                          height: kDefaultPadding,
                        ),
                        CustomTextForm(
                          initialValue: snapshot.data["Section"],
                          title: 'Section',
                          obscureText: false,
                          validator: (input) {
                            if (input.isEmpty) {
                              return "Please enter your section.";
                            } else if (!input.contains(RegExp(r'[a-zA-Z]'))) {
                              return "Enter a valid section.";
                            }
                            return null;
                          },
                          onSaved: (input) => _section = input.toString().toUpperCase(),
                        ),
                        SizedBox(
                          height: kDefaultPadding,
                        ),
                        CustomTextForm(
                          initialValue: snapshot.data["Group"],
                          title: 'Group',
                          obscureText: false,
                          validator: (input) {
                            if (input.isEmpty) {
                              return "Please enter your group.";
                            } else if (!input.contains(RegExp(r'[a-zA-Z]'))) {
                              return "Enter a valid group.";
                            }
                            return null;
                          },
                          onSaved: (input) => _group = input.toString().toUpperCase(),
                        ),
                        SizedBox(
                          height: kDefaultPadding,
                        ),
                        CustomButton(
                            onPressed: saveForm,
                            title: 'Update'
                        )
                  ])
                  ),
                );
              }
            }));
  }

  void saveForm() async {
    final formState = _userProfileFormKey.currentState;
    if (formState.validate()) {
      formState.save();

      try{
        showDialog(context: context, child: AlertDialog(
          title: Text('Please wait...'),
          content: Container(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ));
        final FirebaseUser user = await _firebaseAuth.currentUser();
        await db.collection("User").document(user.uid).updateData({
          'First Name': _firstName,
          'Last Name': _lastName,
          'Section': _section,
          'Group': _group
        });
        Navigator.of(context).pushReplacementNamed("/user");
      }catch(e){
        //exception handling
      }
    }
  }
}
