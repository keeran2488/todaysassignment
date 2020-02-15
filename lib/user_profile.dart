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
  String _firstName, _lastName, _section, _group;
  final GlobalKey<FormState> _userProfileFormKey = GlobalKey<FormState>();

  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome User"),
      ),
      body: Container(
        child: Form(
        key: _userProfileFormKey,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: kDefaultPadding,
            ),
            CustomTextForm(
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
              title: 'Last Name',
              obscureText: false,
              validator: (input) {
                if (input.isEmpty) {
                  return "Please enter your last name.";
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
              title: 'Save'
            )
          ]
        )
      ),
      )
    );
  }

  void saveForm() async{
    final formState = _userProfileFormKey.currentState;
    if(formState.validate()){
      formState.save();
      print(_firstName);
      print(_lastName);
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      print(user.uid);
      await db.collection("User").document(user.uid).setData({'First Name': _firstName, 'Last Name': _lastName, 'Section': _section, 'Group': _group});
    }
  }
}
