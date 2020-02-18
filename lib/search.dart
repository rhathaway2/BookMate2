import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'dart:convert';

//Class to represent search menu to add items to grocery list
class SearchList extends StatefulWidget {
  SearchList({Key key, this.uid}) : super(key: key);
  final String uid;

  @override
  SearchListState createState() => SearchListState();
}

class SearchListState extends State<SearchList> {
  //variables for this class
  String _searchString = "";
  //Text styling for list tiles
  final TextStyle _itemFont = const TextStyle(fontSize: 18.0);
  //text controller used to clear text form
  final TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        automaticallyImplyLeading: false,
        //backgroundColor: Colors.white,
        title: Text("Find A Book", style: TextStyle(color: Colors.black)),
      ),
      body: Column(children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                key: Key("search"),
                onTap: () {
                  //clear search list when text field is tapped
                },
                onChanged: (value) {
                  _searchString = value;
                },
                controller: _textController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal[300]),
                        borderRadius: BorderRadius.circular(30.0)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal[300]),
                        borderRadius: BorderRadius.circular(30.0)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal[300]),
                      borderRadius: BorderRadius.circular(30.0),
                    )))),
        //Search button
        MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          key: Key("searchButton"),
          onPressed: () {
            FocusScope.of(context).previousFocus(); //dismiss keyboard
            //search
          },
          elevation: 5,
          minWidth: 200,
          color: Colors.teal[200],
          //Labels the button with search
          child: Text('Search'),
        ),
      ]),
    );
  } // build
}
