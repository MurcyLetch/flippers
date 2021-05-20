import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class RegistrationScreen extends StatefulWidget {
  static const ROUTE_REGISTRATION = "/registration";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _pwdCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    child: Image.asset(
                      "assets/images/yell1.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                username(),
                emailInput(),
                passwordInput(),
                signupBtn(),
                loginWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget username() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "Type ur name",
          hintText: "abc xyz",
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.cyan,
              style: BorderStyle.solid,
              width: 4.0,
            ),
          ),
        ),
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your name";
          }
          return null;
        },
        controller: _nameCtrl,
      ),
    );
  }

  Widget emailInput() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "Email",
          hintText: "user@domain.com",
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.cyan,
              style: BorderStyle.solid,
              width: 4.0,
            ),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter an email address";
          }
          return null;
        },
        controller: _emailCtrl,
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "Password",
          hintText: "Enter a strong password",
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.cyan,
              style: BorderStyle.solid,
              width: 4.0,
            ),
          ),
        ),
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter a strong password";
          } else if (value.length < 8) {
            return "Password must be atleast 8 characters long";
          }
          return null;
        },
        controller: _pwdCtrl,
      ),
    );
  }

  Widget signupBtn() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: ElevatedButton(
        onPressed: performSignup,
        child: Text(
          "Sign Up",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(150, 50),
          elevation: 20,
          primary: Colors.indigo[300],
        ),
      ),
    );
  }

  void performSignup()async{ 
    String name=_nameCtrl.text;
    String email=_emailCtrl.text;
    String pass=_pwdCtrl.text;
    if (_formKey.currentState.validate()) {
      try {
  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: pass,
  );
  User _currentUser=userCredential.user;
  _currentUser.sendEmailVerification();
  storeUserDetails(_currentUser.uid,name,email);
  notifyUser(context, 'an email with verification link has been sent to you' );
} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    notifyUser(context,'The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
    notifyUser(context,'The account already exists for that email.');
  }
} catch (e) {
  notifyUser(context, e);
}
    }
  }

  Widget loginWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already Registered?',
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_LOGIN);
          },
          style: TextButton.styleFrom(
          primary: Colors.indigo[300],
          ),
          child: Text(
            ' Log in',
            style: TextStyle(
              fontSize: 15.0
            ),
          ),
        ),
      ],
    );
  }

  void notifyUser(BuildContext context, String s) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:Text(s)),
      );
  }

  void storeUserDetails(String uid, String name, String email) async{
    Map<String,dynamic> userDetails={
      'name':name,
      'email':email,
      'desc':'nothing to share',
      'image':'',
    };
    await FirebaseFirestore.instance.collection('users').doc(uid).set(userDetails)
    .then((_) => notifyUser(context, 'User Registered'),)
    .catchError((onError)=>notifyUser(context, onError),);

  }

  
}