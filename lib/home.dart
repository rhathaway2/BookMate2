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
  static bool darkTheme = false;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  //key for opening drawer
  final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();

  final List<Tab> _tabs = [
    Tab(
        child: Row(
      children: <Widget>[
        Icon(Icons.poll, color: Colors.teal[200]),
        Text("Activity")
      ],
    )),
    Tab(
        child: Row(
      children: <Widget>[
        Icon(Icons.people, color: Colors.teal[200]),
        Text("Social")
      ],
    )),
    Tab(
        child: Row(
      children: <Widget>[
        Icon(Icons.book, color: Colors.teal[200]),
        Text("Library")
      ],
    )),
  ];

  //function to toggle dark mode
  void toggleDarkMode(){
    //update boolean
    HomePage.darkTheme = !HomePage.darkTheme;
    //update firebase
    Firestore.instance.document("users/${widget.uid}").updateData({"darkMode": HomePage.darkTheme});
    //update app
    setState((){});
  }

  void initState(){
    super.initState();
    //get dark mode setting from firebase
    Firestore.instance.document("users/${widget.uid}").get()
    .then(
      (res) => res["darkMode"] == true ? HomePage.darkTheme=true : HomePage.darkTheme=false
    );
  }

  @override
  Widget build(BuildContext context) {
    
    //List of widgets to be displayed for each tab
    final List<Widget> _pages = [
      ActivityPage(uid: widget.uid, user: widget.user, dkey: _drawerKey),
      SocialPage(uid: widget.uid, dkey: _drawerKey),
      LibraryPage(uid: widget.uid, dkey: _drawerKey),
    ];

    //get dark mode setting from firebase
    Firestore.instance.document("users/${widget.uid}").get()
    .then(
      (res) => res["darkMode"] == true ? HomePage.darkTheme=true : HomePage.darkTheme=false
    );

    return MaterialApp(
      title: 'BookMate',
      theme: ThemeData(
        appBarTheme:
            AppBarTheme(color: Colors.white, brightness: Brightness.light),
        backgroundColor: Colors.white,
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        appBarTheme:
            AppBarTheme(color: Colors.black54, brightness: Brightness.dark),
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        backgroundColor: Colors.black87,
      ),
      themeMode: (HomePage.darkTheme==true) ? ThemeMode.dark : ThemeMode.light,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          key: _drawerKey,
          drawer: new SideDrawer(user: widget.user, darkTheme: HomePage.darkTheme, toggleDarkTheme: toggleDarkMode,),
          appBar: AppBar(
            //backgroundColor: Colors.white,
            title: Text("BookMate"),
            textTheme: TextTheme(
                title: TextStyle(
                    color: Colors.teal[200],
                    fontSize: 25.0,
                    fontFamily: 'roboto')),
            bottom: TabBar(labelColor: Colors.teal[200], tabs: _tabs),
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
  SideDrawer({this.user, this.darkTheme, this.toggleDarkTheme});
  final DocumentSnapshot user;
  final bool darkTheme;
  final void Function() toggleDarkTheme;

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
            decoration: BoxDecoration(color: Colors.teal[200]),
            accountName: Text("${user["fname"]} ${user["surname"]}"),
            accountEmail: Text("${user["email"]}"),
            currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("${user["fname"][0]}${user["surname"][0]}",
                    style: TextStyle(fontSize: 40.0, color: Colors.teal[200]))),
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
              leading: Icon(Icons.person),
              title: Text("Dark Theme"),
              trailing: IconButton(
                icon: (darkTheme==true ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank)),
                onPressed: (){
                  toggleDarkTheme();
                },
              ),
          ),
          ListTile(
              leading: Icon(Icons.arrow_back),
              title: Text("Log out"),
              onTap: () {
                //do stuff
                _userLogOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
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
