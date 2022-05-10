import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:training_app/pages/user/login_page.dart';

Future<User?> createAccount(String name, String lname, String email, String password, String userType, String trainerId) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  try {
    UserCredential userCrendetial = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    print("Account created Succesfull");

    userCrendetial.user!.updateDisplayName(name);
    String? deviceToken = await firebaseMessaging.getToken();

    var collection = FirebaseFirestore.instance.collection('users');
    collection
        .doc(_auth.currentUser!.uid)
        .update({'auth_token' : deviceToken}) // <-- Updated data
        .then((_) => print('Updated'))
        .catchError((error) => print('Update failed: $error'));

    await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
      "name": name,
      "lname": lname,
      "email": email,
      "status": "Unavalible",
      "auth_token" : deviceToken,
      "user_type" : userType,
      "uid": _auth.currentUser!.uid,
      "trainer_id": trainerId,
    });

    return userCrendetial.user;
  } catch (e) {
    print(e);
    return null;
  }
}


update(String chEmail, String chName, String chlName){
  FirebaseAuth _auth = FirebaseAuth.instance;
  var collection = FirebaseFirestore.instance.collection('users');
  collection
      .doc(_auth.currentUser!.uid) 
      .update({'email' : chEmail,'name' : chName,'lname' : chlName}) // <-- Updated data
      .then((_) => print('Updated'))
      .catchError((error) => print('Update failed: $error'));
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  try {
    String? deviceToken = await firebaseMessaging.getToken();
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    var collection = FirebaseFirestore.instance.collection('users');
    collection
        .doc(_auth.currentUser!.uid)
        .update({'auth_token' : deviceToken}) // <-- Updated data
        .then((_) => print('Updated'))
        .catchError((error) => print('Update failed: $error'));

    print("Login Sucessfull");
    _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) => userCredential.user!.updateDisplayName(value['name']));

    return userCredential.user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    await _auth.signOut().then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
    });
  } catch (e) {
    print("error");
  }
}