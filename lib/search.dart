import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'classes.dart';
import 'package:http/http.dart';
import 'dart:developer';
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
  //Book to display when searching
  Book display;
  bool bookToDisplay = false;
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
                    labelStyle: TextStyle(color: Colors.teal[300]),
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.teal[300]),
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
            print("Searching");
            searchForBook().then((ret) => {
                  setState(() {
                    //display = ret;
                    //bookToDisplay = true;
                  })
                });
          },
          elevation: 5,
          minWidth: 200,
          color: Colors.teal[200],
          //Labels the button with search
          child: Text('Search'),
        ),
        buildBookDisplay(),
      ]),
    );
  } // build

  //Display a book with add and cancel buttons if a books exists to be displayed
  Widget buildBookDisplay() {
    if (bookToDisplay == true) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              height: 154.0,
              width: 400.0,
              child: Stack(
                children: <Widget>[
                  Positioned(left: 70.0, child: buildAddBookCard(display)),
                  Positioned(top: 5.0, child: getCoverImage(display)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
              Padding(
              padding: EdgeInsets.all(10.0),
              child: ButtonTheme(
                minWidth: 150.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text("Add"),
                  color: Colors.teal[200],
                  textColor: Colors.white,
                  onPressed: () {
                    
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: ButtonTheme(
                minWidth: 150.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text("Cancel"),
                  color: Colors.pink,
                  textColor: Colors.white,
                  onPressed: () {

                  },
                ),
              ),
            ),
            ],)
          ],
        ),
      );
    } else {
      return Container(
      );
    }
  }

  //get cover of the book
  Widget getCoverImage(Book book) {
    return Container(
      width: 100.0,
      height: 150.0,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: book.coverImageURL == "NULL"
              ? AssetImage('images/questionmark.png')
              : NetworkImage(book.coverImageURL ?? ''),
        ),
      ),
    );
  }

  //get Add book card
  Widget buildAddBookCard(Book book) {
    return Container(
        width: 400.0,
        height: 160.0,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 1.0,
              bottom: 1.0,
              left: 35.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(book.title, style: Theme.of(context).textTheme.headline),
                Text(book.author, style: Theme.of(context).textTheme.subhead),
                Text("${book.pages.toString()} pages",
                    style: Theme.of(context).textTheme.subhead),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                    ),
                    Text(': ${book.rating} / 5'),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  //Replace spaces with underscores so title
  //works with search url
  String createQueryTitle() {
    String query = "";
    _searchString.split(" ").forEach((word) => query += (word + "_"));
    return query;
  }

  //perform search for boo
  Future<void> searchForBook() async {
    String query = createQueryTitle();
    String url = "http://10.0.0.31:8000/books/$query";

    await get(url).then((response) => {
          setState(() {
            var resp = response.body.split("|");

            String title = resp[0];
            print(title);
            String author = resp[1];
            var rating = double.parse(resp[2]);
            var pages = int.parse(resp[3]);
            var isbn = int.parse(resp[4]);

            Book b = new Book(
                title: title,
                author: author,
                pages: pages,
                rating: rating,
                isbn: isbn,
                coverImageURL: "NULL");
            display = b;
            bookToDisplay = true;
          })
        });
  }
}
