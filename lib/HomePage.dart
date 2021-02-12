import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _initialized = false;
  bool _error = false;

  final databaseReference = FirebaseDatabase.instance.reference();

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body: SafeArea(
      child: Column(children: <Widget>[
        Center(child: Text('Firebase')),
        SizedBox(height: 20),
        FlatButton(onPressed: (){

          registerUser();
        }, child: Text('Register')),
        SizedBox(height: 20),
        FlatButton(onPressed: (){

          loginUser();
        }, child: Text('Login')),
        SizedBox(height: 20),
        FlatButton(onPressed: (){

          createData();
        }, child: Text('Create Data')),
        SizedBox(height: 20),
        FlatButton(onPressed: (){

          readData();
        }, child: Text('Read Data')),
        SizedBox(height: 20),
        FlatButton(onPressed: (){

          updateData();
        }, child: Text('Update Data')),
        SizedBox(height: 20),
        FlatButton(onPressed: (){

          deleteData();
        }, child: Text('Delete Data'))
      ],
      ),
    ));
  }

  registerUser() async {

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: "hitesh@gmail.com",
          password: "Test@123"
      );

      final User user = userCredential.user;

      if (user != null){

        print(user.email);
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  loginUser() async {

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "sam@gmail.com",
          password: "Test@5533"
      );

      final User user = userCredential.user;

      if (user != null){

        print(user.email);
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  createData(){

    databaseReference.child("flutterDevsTeam1").set({
      'name': 'Deepak Nishad',
      'description': 'Team Lead'
    });
  }

  readData(){

    databaseReference.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
  }

  void updateData(){

    databaseReference.child('flutterDevsTeam1').update({
      'description': 'CEO'
    });
  }

  void deleteData(){

    databaseReference.child('flutterDevsTeam1').remove();
  }
}
