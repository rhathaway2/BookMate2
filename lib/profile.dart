import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*

*/
class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.uid, this.dkey, this.title, this.user})
      : super(key: key);
  final String uid;
  final String title;
  final GlobalKey<ScaffoldState> dkey;
  final DocumentSnapshot user;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

/*

*/
class _ProfilePageState extends State<ProfilePage> {
  int f_count;
  int b_count;

  @override
  void initState(){
    super.initState();
    Firestore.instance.collection("users/${widget.uid}/Friends").getDocuments().then((myDocuments) => {
      f_count = myDocuments.documents.length,
      update()
    });
    Firestore.instance.collection("users/${widget.uid}/Books").getDocuments().then((myDocuments) => {
      b_count = myDocuments.documents.length,
      update()
    });
  }

  void update(){
    setState(() {
      //update
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 20.0),),
          Center(
            child: CircleAvatar(
              backgroundColor: Colors.teal[200],
              minRadius: 100.0,
              child: Text(
                "${widget.user["fname"][0]}${widget.user["surname"][0]}",
                style: TextStyle(fontSize: 80.0, color: Colors.white),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10.0),),
          Center(
            child: Text(
              "${widget.user["fname"]} ${widget.user["surname"]}",
                style: TextStyle(fontSize: 30.0),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10.0),),
          Center(
            child: Text("${f_count} Friends  |  ${b_count} Books")
          ),
        ],
      ),
    );
  }
}
