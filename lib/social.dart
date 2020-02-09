import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*

*/
class SocialPage extends StatefulWidget{
  SocialPage({Key key, this.uid, this.dkey}): super(key:key);
  final String uid;
  final GlobalKey<ScaffoldState> dkey;

  @override
  _SocialPageState createState() => _SocialPageState();

}

/*

*/
class _SocialPageState extends State<SocialPage>{

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
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
                onPressed: () {},
              )
            ],
          ),
        ),
    );
  }
}
