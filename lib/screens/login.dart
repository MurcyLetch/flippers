import 'package:app1/screens/registration.dart';
import 'package:app1/session/session_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {
  static const ROUTE_LOGIN = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                      "assets/images/yell.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                emailInput(),
                passwordInput(),
                loginBtn(),
                signupWidget(),
              ],
            ),
          ),
        ),
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

  Widget loginBtn() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: ElevatedButton(
        onPressed: performLogin,
        child: Text(
          "Log In",
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

  void performLogin() async {
    if (_formKey.currentState.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailCtrl.text,
          password: _pwdCtrl.text,
        );
        User user = userCredential.user;
        if (user.emailVerified) {
          notifyUser(context, 'Logging you in..');
          SessionManagement.storeLoggedInDetails(uid: user.uid);
          Navigator.pushReplacementNamed(context, HomeScreen.ROUTE_HOME);
        } else {
          notifyUser(context, 'Please verify your email address.');
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          notifyUser(context, 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          notifyUser(context, 'Wrong password provided for that user.');
        }
      }
    }
  }

  Widget signupWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'New User?',
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, RegistrationScreen.ROUTE_REGISTRATION);
          },
          style: TextButton.styleFrom(
          primary: Colors.indigo[300],
        ),
          child: Text(
            ' Sign Up Now !',
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
      SnackBar(
        content: Text(s),
      ),
    );
  }
}