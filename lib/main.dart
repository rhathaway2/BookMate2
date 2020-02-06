import 'package:flutter/material.dart';

//imports for tabs
import 'library.dart';
//import 'social.dart';
//import 'activity.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //List of widgets to be displayed for each tab
  final List<Widget> _pages = [
    PlaceHolderWidget(),
    PlaceHolderWidget(),
    LibraryPage(),
  ];

  final List<Tab> _tabs = [
    Tab(text: "Activity", icon: Icon(Icons.poll, color: Colors.cyan)),
    Tab(text: "Social", icon: Icon(Icons.people, color: Colors.cyan)),
    Tab(text: "Library", icon: Icon(Icons.book, color: Colors.cyan)),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookMate',
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("BookMate"),
            textTheme: TextTheme(
                title: TextStyle(
                    color: Colors.cyan, fontSize: 25.0, fontFamily: 'roboto')),
            bottom: TabBar(labelColor: Colors.cyan, tabs: _tabs),
          ),
          body: TabBarView(children: _pages),
        ),
      ),
    );
  }
}

class PlaceHolderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}
