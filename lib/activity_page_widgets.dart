import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'classes.dart';


/*

*/
class FriendStatus extends StatefulWidget {
  FriendStatus({Key key, this.uid, this.title})
      : super(key: key);
  final String uid;
  final String title;
  @override
  _FriendStatusState createState() => _FriendStatusState();
}

/*

*/
class _FriendStatusState extends State<FriendStatus> {
  int f_count;

  @override
  void initState(){
    super.initState();
    Firestore.instance.collection("users/${widget.uid}/Friends").getDocuments().then((myDocuments) => {
      f_count = myDocuments.documents.length,
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
    return Container(
      width: 165.0,
      height: 100.0,
      child: Card(
        elevation: 14.0,
        shadowColor: Color(0x802196F3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.teal[200],
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
          children: <Widget>[
            Icon(Icons.person, size: 30.0,),
            Text("$f_count Friends", style: TextStyle(fontSize: 18.0),)
          ],
        ),
        ),
      ),
    );
  }
}


/*

*/
class BookStatus extends StatefulWidget {
  BookStatus({Key key, this.uid, this.title})
      : super(key: key);
  final String uid;
  final String title;
  @override
  _BookStatusState createState() => _BookStatusState();
}

/*

*/
class _BookStatusState extends State<BookStatus> {
  int b_count;

  @override
  void initState(){
    super.initState();
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
    return Container(
      width: 165.0,
      height: 100.0,
      child: Card(
        elevation: 14.0,
        shadowColor: Color(0x802196F3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.teal[200],
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
          children: <Widget>[
            Icon(Icons.book, size: 30.0,),
            Text("$b_count Books", style: TextStyle(fontSize: 18.0),)
          ],
        ),
        ),
      ),
    );
  }
}
