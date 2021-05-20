import 'package:app1/screens/home.dart';
import 'package:app1/screens/login.dart';
import 'package:app1/screens/registration.dart';

import './screens/splash.dart';
import 'package:flutter/material.dart';
void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  get cyan => null; 

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Widget root',
      theme: ThemeData(
        primaryColor: Colors.indigo[300],
      ),
      //home:SplashScreen() ,
      initialRoute: '/',//to mention the route screen of the app
      debugShowCheckedModeBanner: false,
      routes:{
        '/': (context)=>SplashScreen(),
        LoginScreen.ROUTE_LOGIN : (context)=>LoginScreen(),
        RegistrationScreen.ROUTE_REGISTRATION : (context)=>RegistrationScreen(),
        HomeScreen.ROUTE_HOME:(context)=>HomeScreen()
      },
    );
  }
}