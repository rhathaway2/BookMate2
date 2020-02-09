import 'package:flutter/material.dart';

//imports for tabs
import 'home.dart';
import 'splash.dart';
import 'login.dart';
import 'register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookMate',
      theme: ThemeData(
        backgroundColor: Colors.white,
        primarySwatch: Colors.teal,
      ),
      home: SplashPage(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomePage(),
        '/login': (BuildContext context) => LoginPage(),
        '/register': (BuildContext context) => RegisterPage(),
      });
  }
}



