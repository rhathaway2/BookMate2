import 'package:flutter/material.dart';
import 'library.dart';
import 'activity.dart';
import 'social.dart';

class HomePage extends StatefulWidget {
  
  HomePage({Key key, this.uid}) : super(key:key);
  final String uid;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  final List<Tab> _tabs = [
    Tab(text: "Activity", icon: Icon(Icons.poll, color: Colors.cyan)),
    Tab(text: "Social", icon: Icon(Icons.people, color: Colors.cyan)),
    Tab(text: "Library", icon: Icon(Icons.book, color: Colors.cyan)),
  ];

  @override
  Widget build(BuildContext context) {
    //List of widgets to be displayed for each tab
    final List<Widget> _pages = [
      ActivityPage(uid: widget.uid),
      SocialPage(uid: widget.uid),
      LibraryPage(uid: widget.uid),
    ];

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
