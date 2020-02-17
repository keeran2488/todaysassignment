

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User{
  const User({@required this.uid, this.email});

  final String uid;
  final String email;
}

class FirebaseAuthServices{
  final _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user){
    return user == null ? null : User(uid: user.uid, email: user.email);
  }

  Stream<User> get onAuthStatusChanged{
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  Future<User> createUserWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  Future<void> onSignOut() async {
    return await _firebaseAuth.signOut();
  }
}