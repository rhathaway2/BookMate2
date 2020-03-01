import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*

*/
class SocialPage extends StatefulWidget{
  SocialPage({Key key, this.uid, this.dkey, this.title}): super(key:key);
  final String uid;
  final String title;
  final GlobalKey<ScaffoldState> dkey;

  @override
  _SocialPageState createState() => _SocialPageState();

}

/*

*/
class _SocialPageState extends State<SocialPage>{
  bool searchVisible=false;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      /*
      floatingActionButton: FloatingActionButton.extended(
          elevation: 4.0,
          backgroundColor: Colors.teal[200],
          icon: const Icon(Icons.group_add),
          label: const Text('Add Friend'),
          onPressed: () {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  widget.dkey.currentState.openDrawer();
                },
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  searchVisible = !searchVisible;
                  setState(() {});
                },
              )
            ],
          ),
        ),
        */
        body: buildFriendsList(),
    );
  }

  /*
  Get List of books from firebase
  */
  Widget buildFriendsList() {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("users/${widget.uid}/Friends")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new ListTile(
              leading: Icon(Icons.mood_bad),
              title: Text("You have no friends"),
              subtitle: Text("Unlucky"),
            );
          }
          return new ListView(children: getFriendsList(snapshot));
        });
  }

  /*
  Map firebase snapshop to BookCards
  */
  getFriendsList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map(
          (doc) => new Container(
            child: FriendCard(uid: widget.uid),
          ),
        )
        .toList();
  }
}


class FriendCard extends StatefulWidget{
  final String uid;

  FriendCard({this.uid});

  @override
  _FriendCardState createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard>{

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}


