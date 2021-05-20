import 'package:app1/session/session_management.dart';
import 'package:firebase_core/firebase_core.dart';

import '../storage/local_data.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';

class SplashScreen extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase
      .initializeApp(); //helps to initialise flutter project's app with firebase
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  "   H    e    y  !!",
                  style: TextStyle(
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "FlippeRs",
                  style: TextStyle(
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                imageZone(),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      // write the code to take action against the click
                      if (snapshot.connectionState == ConnectionState.done) {
                        performRouting(context);
                      } else {
                        // add a widget
                        return CircularProgressIndicator();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 50),
                      elevation: 20,
                      primary: Colors.indigo[300],
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget imageZone() {
    return Container(
      height: 400,
      child: PageView.builder(
        itemBuilder: (ctx, index) => Column(
          children: [
            Expanded(
            child: ClipRRect(
            child: Image.asset(LocalData.pagerList[index]['image']),
            ),
            ),
            Text(LocalData.pagerList[index]['title'])
          ],
        ),
        itemCount: LocalData.pagerList.length,
      ),
    );
  }
  void performRouting(BuildContext context) {
    SessionManagement.getLoggedInStatus().then((value) {
      value
          ? Navigator.pushReplacementNamed(context, HomeScreen.ROUTE_HOME)
          : Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_LOGIN);
    }).catchError((onError) => print(onError));
  }
}


