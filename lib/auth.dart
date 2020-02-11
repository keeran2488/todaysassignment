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
              children: buildInputs() + buildButtons(),
            ),
          ),
        ));
  }

  List<Widget> buildInputs() {
    return <Widget>[
      Image(
        width: double.maxFinite,
        image: NetworkImage('https://media.istockphoto.com/photos/rocky-mountain-peak-picture-id904856396?k=6&m=904856396&s=612x612&w=0&h=ZVZpbtWCmkHLN6cGpRtGdBIhwZZsMwXn5xSL3ThqslU='),
      ),
      SizedBox(
        height: kDefaultPadding,
      ),
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
      SizedBox(
        height: kDefaultPadding,
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
        CustomButton(
          title: 'Sign In',
          onPressed: signIn,
        ),
        FlatButton(
          onPressed: moveToRegister,
          child: Text("Doesn't have account? Sign up"),
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
        child: Text("Already have account? Sign in"),
      )
    ];
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: _email, password: _password))
            .user;
        //Navigate to home
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home(user: user)));
      } catch (e) {
        AlertDialog(
          title: Text("Error occured!"),
          content: Text("${e.message}"),
          elevation: 24.0,
        );
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
