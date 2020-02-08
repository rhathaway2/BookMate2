import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'library.dart';
import 'activity.dart';
import 'social.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.uid, this.user}) : super(key: key);
  final String uid;
  final DocumentSnapshot user;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  //key for opening drawer
  final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();

  final List<Tab> _tabs = [
    Tab(text: "Activity", icon: Icon(Icons.poll, color: Colors.cyan)),
    Tab(text: "Social", icon: Icon(Icons.people, color: Colors.cyan)),
    Tab(text: "Library", icon: Icon(Icons.book, color: Colors.cyan)),
  ];


  @override
  Widget build(BuildContext context) {
    //List of widgets to be displayed for each tab
    final List<Widget> _pages = [
      ActivityPage(uid: widget.uid, dkey: _drawerKey),
      SocialPage(uid: widget.uid, dkey: _drawerKey),
      LibraryPage(uid: widget.uid, dkey: _drawerKey),
    ];

    return MaterialApp(
      title: 'BookMate',
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          key: _drawerKey,
          drawer: new SideDrawer(user: widget.user),
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("BookMate"),
            textTheme: TextTheme(
                title: TextStyle(
                    color: Colors.cyan, fontSize: 25.0, fontFamily: 'roboto')),
            bottom: TabBar(labelColor: Colors.cyan, tabs: _tabs),
          ),
          body: TabBarView(
            children: _pages,
          ),
        ),
      ),
    );
  }
}

/*
Side drawer menu
*/
class SideDrawer extends StatelessWidget {
  SideDrawer({this.user});
  final DocumentSnapshot user;

  /*
    function to log out current firebase user
    */
  Future<void> _userLogOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("${user["fname"]} ${user["surname"]}"),
            accountEmail: Text("${user["email"]}"),
            currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("${user["fname"][0]}${user["surname"][0]}",
                    style: TextStyle(fontSize: 40.0))),
          ),
          ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () {
                //do stuff
                //exit drawer
                Navigator.of(context).pop();
              }),
          ListTile(
              leading: Icon(Icons.arrow_back),
              title: Text("Log out"),
              onTap: () {
                //do stuff
                _userLogOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage()
                    ),
                    (_) => false);
              }),
        ],
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
