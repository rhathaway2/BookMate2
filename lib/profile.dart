import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*

*/
class ProfilePage extends StatefulWidget{
  ProfilePage({Key key, this.uid, this.dkey, this.title}): super(key:key);
  final String uid;
  final String title;
  final GlobalKey<ScaffoldState> dkey;

  @override
  _ProfilePageState createState() => _ProfilePageState();

}

/*

*/
class _ProfilePageState extends State<ProfilePage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      
    );
  }

}
