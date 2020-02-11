import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:todaysassignment/functions/constants.dart';

import 'package:todaysassignment/custom_plugin/inputfield.dart';

class LogInForm extends StatefulWidget {
  @override
  _LogInFormState createState() => _LogInFormState();
}

enum FormType {
  login,
  register,
}

class _LogInFormState extends State<LogInForm> {
  String _email, _password;
  FormType _formType = FormType.login;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void moveToRegister() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToSignIn() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login Form"),
        ),
        body: Container(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: kDefaultPadding * 2,
              ),
              children: buildInputs() + buildButtons(),
            ),
          ),
        ));
  }

  List<Widget> buildInputs() {
    return <Widget>[
      SizedBox(
        height: kDefaultPadding,
      ),
//      TextFormField(
//        validator: (input) {
//          if (input.isEmpty) {
//            return "Please type an email.";
//          } else if (!input.contains("@")) {
//            return "Enter a valid email.";
//          }
//          return null;
//        },
//        onSaved: (input) => _email = input,
//        decoration: InputDecoration(
//          labelText: 'Email',
//          border: OutlineInputBorder(),
//          contentPadding: EdgeInsets.symmetric(
//            vertical: 0,
//            horizontal: kDefaultPadding,
//          ),
//        ),
//      ),
      CustomTextForm(
        title: 'Email',
        validator: (input) {
          if (input.isEmpty) {
            return "Please type an email.";
          } else if (!input.contains("@")) {
            return "Enter a valid email.";
          }
          return null;
        },
        onSaved: (input) => _email = input,
      ),
      CustomTextForm(
        title: 'Password',
        validator: (input) {
          if (input.isEmpty) {
            return 'Your password needs to be atleast 6 characters.';
          }
          return null;
        },
        onSaved: (input) => _password = input,
      ),
      SizedBox(
        height: kDefaultPadding,
      ),
    ];
  }

  List<Widget> buildButtons() {
    if (_formType == FormType.login) {
      return <Widget>[
        RaisedButton(
          shape: BeveledRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(kDefaultPadding / 3)),
          ),
          onPressed: signIn,
          child: Text("Sign in"),
        ),
        FlatButton(
          onPressed: moveToRegister,
          child: Text("Doesn't have account? Sign up"),
        )
      ];
    }
    return <Widget>[
      RaisedButton(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(kDefaultPadding / 3)),
        ),
        onPressed: signIn,
        child: Text("Sign up"),
      ),
      FlatButton(
        onPressed: moveToSignIn,
        child: Text("Already have account? Sign in"),
      )
    ];
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        if(_formType == FormType.login){
          FirebaseUser user = (await FirebaseAuth.instance
                  .signInWithEmailAndPassword(email: _email, password: _password))
              .user;
          //Navigate to home
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home(user: user)));
        }else{
          FirebaseUser user = (await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(email: _email, password: _password))
              .user;
          print("User ID: ${user.email}");
        }
      } catch (e) {
        print("Error: ${e.message}");
        showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Try again!"),
              content: Text("${e.message}"),
              actions: <Widget>[
                FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  }, 
                  child: Text("OK")
                ),
              ],
              elevation: 24.0,
          );
        });
      }
    }
  }
}

class Home extends StatefulWidget {
  const Home({Key key, @required this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Welcome ${widget.user.email}'),
      ),
    );
  }
}
