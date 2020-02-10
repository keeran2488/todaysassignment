import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class LogInForm extends StatefulWidget {
  @override
  _LogInFormState createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Form"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              TextFormField(
                validator: (input){
                  if(input.isEmpty) {
                    return "Please type an email.";
                  }else if(!input.contains("@")){
                    return "Enter a valid email.";
                  }
                  return null;
                },
                onSaved: (input) => _email = input,
                decoration: InputDecoration(
                    labelText: 'Email'
                ),
              ),
              TextFormField(
                validator: (input){
                  if(input.isEmpty){
                    return 'Your password needs to be atleast 6 characters.';
                  }
                  return null;
                },
                onSaved: (input) => _password = input,
                decoration: InputDecoration(
                    labelText: 'Password'
                ),
                obscureText: true,
              ),
              RaisedButton(
                onPressed: signIn,
                child: Text("Sign in"),
              )
            ]
        ),
      ),
    );
  }

  Future<void> signIn() async{
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      try{
        FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)).user;
        //Navigate to home
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(user: user)));
      }catch(e) {
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
  const Home({Key key, @required this.user}) : super(key: key) ;
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


