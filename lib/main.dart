import 'package:flutter/material.dart';

//imports for tabs
import 'home.dart';
import 'splash.dart';
import 'login.dart';
import 'register.dart';
import 'constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookMate',
      theme: Constants.lightTheme,
      darkTheme: Constants.darkTheme,
      home: SplashPage(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomePage(),
        '/login': (BuildContext context) => LoginPage(),
        '/register': (BuildContext context) => RegisterPage(),
      });
  }
}



