import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'library.dart';
import 'register.dart';
import 'activity.dart';
import 'social.dart';
import 'login.dart';
import 'profile.dart';
import 'constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.uid, this.user}) : super(key: key);
  final String uid;
  final DocumentSnapshot user;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  //key for opening drawer
  final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
  //bool darktheme
  bool darkTheme;
  //tab controller
  TabController controlla ;

  final List<String> _title = ["Dashboard", "Friends", "Library", "Profile"];

  _HomePageState({this.darkTheme});

  //function to toggle dark mode
  void toggleDarkMode(){
    //update boolean
    darkTheme = !darkTheme;
    //update firebase
    Firestore.instance.document("users/${widget.uid}").updateData({"darkMode": darkTheme});
    //update app
    setState((){});
  }

  void update(){
    setState((){});
  }

  void initState(){
    super.initState();
    darkTheme = widget.user['darkMode'];
    controlla = TabController(vsync: this, length: _title.length);
  }

  @override
  Widget build(BuildContext context) {
    
    //List of widgets to be displayed for each tab
    final List<Widget> _pages = [
      ActivityPage(uid: widget.uid, user: widget.user, dkey: _drawerKey),
      SocialPage(uid: widget.uid, dkey: _drawerKey),
      LibraryPage(uid: widget.uid, dkey: _drawerKey),
      ProfilePage(uid: widget.uid, dkey: _drawerKey),
    ];

    return MaterialApp(
      title: 'BookMate',
      theme: Constants.lightTheme,
      darkTheme: Constants.darkTheme,
      themeMode: (darkTheme==true) ? ThemeMode.dark : ThemeMode.light,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          key: _drawerKey,
          drawer: new SideDrawer(user: widget.user, darkTheme: darkTheme, toggleDarkTheme: toggleDarkMode, controlla: controlla, update: update),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _drawerKey.currentState.openDrawer();
                },
              ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(_title[controlla.index]),
              ]
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: controlla,
            children: _pages,
          ),
        ),
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomePage(),
        '/login': (BuildContext context) => LoginPage(),
        '/register': (BuildContext context) => RegisterPage(),
      });
  }
}

/*
Side drawer menu
*/
class SideDrawer extends StatelessWidget {
  SideDrawer({this.user, this.darkTheme, this.toggleDarkTheme, this.controlla, this.update});
  final DocumentSnapshot user;
  final bool darkTheme;
  final void Function() toggleDarkTheme;
  final TabController controlla;
  final void Function() update;

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
                controlla.animateTo(3);
                update();
                //exit drawer
                Navigator.of(context).pop();
              }),
          ListTile(
              leading: Icon(Icons.poll),
              title: Text("Activity"),
              onTap: () {
                //do stuff
                controlla.animateTo(0);
                update();
                //exit drawer
                Navigator.of(context).pop();
              }),
          ListTile(
              leading: Icon(Icons.group),
              title: Text("Friends"),
              onTap: () {
                //do stuff
                controlla.animateTo(1);
                update();
                //exit drawer
                Navigator.of(context).pop();
              }),
          ListTile(
              leading: Icon(Icons.book),
              title: Text("Library"),
              onTap: () {
                //do stuff
                controlla.animateTo(2);
                update();
                //exit drawer
                Navigator.of(context).pop();
              }),
          ListTile(
              leading: Icon(Icons.brightness_4),
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
                _userLogOut().then((value){
                  Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                });
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
