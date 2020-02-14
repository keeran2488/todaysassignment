import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:todaysassignment/functions/constants.dart';

import 'package:todaysassignment/custom_plugin/inputfield.dart';

import 'custom_plugin/button.dart';

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

  FocusNode _emailFocus, _passwordFocus;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Form(
        key: _formKey,
        child: ListView(
          children: buildInputs() + buildButtons(),
        ),
      ),
    ));
  }

  List<Widget> buildInputs() {
    return <Widget>[
      Image(
        width: double.maxFinite,
        image: NetworkImage(
            'https://i.ebayimg.com/images/g/gSUAAOSwACFdYOTv/s-l400.jpg'
        ),
      ),
      SizedBox(
        height: kDefaultPadding,
      ),
      CustomTextForm(
        focus: _emailFocus,
        title: 'Email',
        inputAction: TextInputAction.next,
        obscureText: false,
        validator: (input) {
          if (input.isEmpty) {
            return "Please type an email.";
          } else if (!input.contains("@")) {
            return "Enter a valid email.";
          }
          return null;
        },
        onSaved: (input) => _email = input,
        onNext: (x){
          FocusScope.of(context).unfocus();
          FocusScope.of(context).requestFocus(_passwordFocus);
        },
      ),
      SizedBox(
        height: kDefaultPadding,
      ),
      CustomTextForm(
        focus: _passwordFocus,
        title: 'Password',
        inputAction: TextInputAction.go,
        obscureText: true,
        validator: (input) {
          if (input.isEmpty) {
            return 'Your password needs to be atleast 6 characters.';
          }
          return null;
        },
        onSaved: (input) => _password = input,
        onNext: (x){
          FocusScope.of(context).unfocus();
          signIn();
        },
      ),
      SizedBox(
        height: kDefaultPadding,
      ),
    ];
  }

  List<Widget> buildButtons() {
    if (_formType == FormType.login) {
      return <Widget>[
        CustomButton(
          title: 'Sign In',
          onPressed: signIn,
        ),
        FlatButton(
          onPressed: moveToRegister,
          child: Text(
            "Doesn't have account? Sign up",
            style: TextStyle(
              color: Theme.of(context).errorColor,
            ),
          ),
        )
      ];
    }
    return <Widget>[
      CustomButton(
        title: 'Sign Up',
        onPressed: signIn,
      ),
      FlatButton(
        onPressed: moveToSignIn,
        child: Text(
          "Already have account? Sign in",
          style: TextStyle(
            color: Theme.of(context).errorColor,
          ),
        ),
      )
    ];
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        if (_formType == FormType.login) {
          FirebaseUser user = (await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: _email, password: _password))
              .user;
          print("User ID: ${user.email}");
        } else {
          FirebaseUser user = (await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: _email, password: _password))
              .user;
          print("User ID: ${user.email}");
        }
      } catch (e) {
        print("Error: ${e.message}");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Try again!"),
                content: Text("${e.message}"),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("OK")),
                ],
                elevation: 24.0,
              );
            });
      }
    }
  }
}
