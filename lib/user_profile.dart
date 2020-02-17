import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'custom_plugin/button.dart';
import 'custom_plugin/inputfield.dart';
import 'functions/constants.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String _firstName, _lastName, _section, _group, _uid;
  File _image;
  final GlobalKey<FormState> _userProfileFormKey = GlobalKey<FormState>();

  final db = Firestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;

  Future getUserDetails() async {
    FirebaseUser userS = await _firebaseAuth.currentUser();
    _uid = userS.uid;
    DocumentSnapshot ds = await db.collection("User").document(_uid).get();
    return ds;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print("Image path $_image");
    });
  }

  Future uploadPic(BuildContext context) async{
    FirebaseUser userS = await _firebaseAuth.currentUser();
    _uid = userS.uid;
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("User/$_uid/$fileName");
    final StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
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
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 100.0,
                          child: ClipOval(
                            child: new SizedBox(
                              width: 180.0,
                              height: 180.0,
                              child: (_image!=null)?Image.file(_image,fit: BoxFit.fill,):
                                  Image.network(
                                    "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                    fit: BoxFit.fill,
                                  )
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 200.0),
                        child: IconButton(
                            icon: Icon(Icons.photo_camera, size: 30.0),
                          onPressed: (){
                              getImage();
                          },
                      )),
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
                            onPressed: (){
                              updateForm(context);
                            },
                            title: 'Update'
                        )
                  ])
                  ),
                );
              }
            }));
  }

  void updateForm(BuildContext context) async {
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

class UserProfileNew extends StatefulWidget {
  @override
  _UserProfileNewState createState() => _UserProfileNewState();
}

class _UserProfileNewState extends State<UserProfileNew> {
  String _firstName, _lastName, _section, _group, _uid;
  File _image;

  final db = Firestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;

  Future getUserDetails() async {
    FirebaseUser userS = await _firebaseAuth.currentUser();
    _uid = userS.uid;
    DocumentSnapshot ds = await db.collection("User").document(_uid).get();
    return ds;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print("Image path $_image");
    });
  }

  Future uploadPic(BuildContext context) async{
    FirebaseUser userS = await _firebaseAuth.currentUser();
    _uid = userS.uid;
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("User/$_uid/$fileName");
    final StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;

  }

  final GlobalKey<FormState> _newUserProfileFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create user profile"),
      ),
        body: Container(
          child: Form(
            key: _newUserProfileFormKey,
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: kDefaultPadding,
                ),
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 100.0,
                    child: ClipOval(
                      child: new SizedBox(
                          width: 180.0,
                          height: 180.0,
                          child: (_image!=null)?Image.file(_image,fit: BoxFit.fill,):
                          Image.network(
                            "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                            fit: BoxFit.fill,
                          )
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 200.0),
                    child: IconButton(
                      icon: Icon(Icons.photo_camera, size: 30.0),
                      onPressed: (){
                        getImage();
                      },
                    )),
                SizedBox(
                  height: kDefaultPadding,
                ),
                CustomTextForm(
//                  focus: _emailFocus,
                  title: 'First Name',
//                  inputAction: TextInputAction.next,
                  obscureText: false,
                  validator: (input) {
                    if (input.isEmpty) {
                      return "Please type your first name.";
                    } else if (input.contains("@")) {
                      return "Enter a valid name.";
                    }
                    return null;
                  },
                  onSaved: (input) => _firstName = input,
//                  onNext: (x){
//                    FocusScope.of(context).unfocus();
//                    FocusScope.of(context).requestFocus(_passwordFocus);
//                  },
                ),
                SizedBox(
                  height: kDefaultPadding,
                ),
                CustomTextForm(
//                  focus: _passwordFocus,
                  title: 'Last Name',
//                  inputAction: TextInputAction.go,
                  obscureText: false,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please type your last name';
                    } else if (input.contains("@")) {
                      return "Enter a valid name.";
                    }
                    return null;
                  },
                  onSaved: (input) => _lastName = input,
//                  onNext: (x){
//                    FocusScope.of(context).unfocus();
//                    signIn();
//                  },
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
                  title: 'Save',
                  onPressed: (){
                    saveForm(context);
                  },
                ),
              ],
            ),
          ),
        ));
  }

  void saveForm(BuildContext context) async {
    final formState = _newUserProfileFormKey.currentState;
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
        await db.collection("User").document(user.uid).setData({
          'First Name': _firstName,
          'Last Name': _lastName,
          'Section': _section,
          'Group': _group
        });
        Navigator.of(context).pushReplacementNamed("/home");
      }catch(e){
        //exception handling
      }
    }
  }
}


