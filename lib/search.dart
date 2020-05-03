import 'package:bookmate2/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'classes.dart';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Class to represent search menu to add items to grocery list
class SearchList extends StatefulWidget {
  SearchList({Key key, this.uid, this.refresh}) : super(key: key);
  final String uid;
  final void Function() refresh;

  @override
  SearchListState createState() => SearchListState();
}

class SearchListState extends State<SearchList> {
  //variables for this class
  String _searchString = "";
  //Book to display when searching
  Book display1, display2;
  bool bookToDisplay = false;
  bool secondBookToo = false;
  bool searching = false;
  bool errorOccurred = false;
  //text controller used to clear text form
  final TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        automaticallyImplyLeading: false,
        //backgroundColor: Colors.white,
        title: Text("Find A Book"),
      ),
      body: Column(children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                key: Key("search"),
                onTap: () {
                  setState(() {
                    searching = false;
                    errorOccurred = false;
                    bookToDisplay = false;
                  });
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
            setState(() {
              searching = true;
            });
            FocusScope.of(context).previousFocus(); //dismiss keyboard
            searchForBook().then((ret) => {
                  setState(() {
                    searching = false;
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
                  Positioned(left: 70.0, child: buildAddBookCard(display1)),
                  Positioned(top: 5.0, child: getCoverImage(display1)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
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
                        addBookToFireBaseUser(display1).then((resp) => {
                              setState(() {
                                bookToDisplay = false;
                                _textController.clear();
                              }),
                              widget.refresh()
                            });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
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
                        setState(() {
                          bookToDisplay = false;
                          secondBookToo = false;
                          _textController.clear();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            secondBookToo ? Column(
              children: <Widget>[
                Container(
                  height: 154.0,
                  width: 400.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned(left: 70.0, child: buildAddBookCard(display2)),
                      Positioned(top: 5.0, child: getCoverImage(display2)),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
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
                            addBookToFireBaseUser(display2).then((resp) => {
                                  setState(() {
                                    bookToDisplay = false;
                                    secondBookToo = false;
                                    _textController.clear();
                                  }),
                                  widget.refresh()
                                });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
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
                            setState(() {
                              bookToDisplay = false;
                              secondBookToo = false;
                              _textController.clear();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ) : new Container(),
          ],
        ),
      );
    } else if (searching == true) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
              child: CircularProgressIndicator(
                strokeWidth: 5,
                backgroundColor: Colors.teal[300],
              ),
            ),
            Text(
              "Searching... This may take a few seconds",
              style: TextStyle(fontSize: 14.0),
            )
          ],
        ),
      );
    } else if (errorOccurred == true) {
      return Container(child: Text("An Error occurred. Please try again"));
    } else {
      return Container();
    }
  }

  Future<Widget> getCoverImageFuture(coverURL) async {
    Image img;
    final ref = FirebaseStorage.instance.ref().child(coverURL);
    var url = await ref.getDownloadURL();
    img = Image.network(url.toString(), fit: BoxFit.cover);
    return img;
  }

  //get cover of the book
  Widget getCoverImage(Book book) {
    return FutureBuilder(
        future: getCoverImageFuture(book.coverImageURL),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              padding: EdgeInsets.only(left: 2),
              width: 100.0,
              height: 150.0,
              child: snapshot.data,
              /*
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: new DecorationImage(
                  image: snapshot.data
                ),  
              ),*/
            );
          } else {
            return Container(
              padding: EdgeInsets.only(left: 2),
              width: 100.0,
              height: 150.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('images/questionmark.png')),
              ),
            );
          }
        });
  }

  //get Add book card
  Widget buildAddBookCard(Book book) {
    String booktitle = book.title;
    if(book.title.length > 35){
      booktitle = book.title.substring(0, 35) + "...";
    }
  
    return Container(
        width: 290.0,
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
                Text(booktitle, style: Theme.of(context).textTheme.headline),
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

  /*
  Add a book to firebase for the current user
  */
  Future<void> addBookToFireBaseUser(Book book) async {
    Firestore.instance
        .collection("users/${widget.uid}/Books")
        .document((book.title))
        .setData({
      "title": book.title,
      "author": book.author,
      "pages": book.pages,
      "rating": book.rating,
      "url": book.coverImageURL,
      "userRating": book.userRating,
    });
  }

  /*
  Add a book to firebase for global use
  */
  void addBookToFireBaseGlobal(Book book) {
    Firestore.instance.collection("Books").document((book.title)).setData({
      "title": book.title,
      "author": book.author,
      "pages": book.pages,
      "rating": book.rating,
      "url": book.coverImageURL,
    });
  }

  //perform search for boo
  Future<void> searchForBook() async {
    String query = createQueryTitle();
    String url = "http://${Constants.IP_ADDR}/books/$query";

    await get(url).then((response) => {
          //update the screen
          setState(() {
            if (response.body == "Error") {
              setState(() {
                errorOccurred = true;
                bookToDisplay = false;
                searching = false;
              });
            } else {
              var allResponses = response.body.split("<br>");
              var resp = allResponses[0].split("|");
              String title = resp[0];
              String author = resp[1];
              var rating = double.parse(resp[2]);
              var pages = int.parse(resp[3]);
              var bookCoverUrl = "$title$author.jpg";

              Book b = new Book(
                  title: title,
                  author: author,
                  pages: pages,
                  rating: rating,
                  coverImageURL: bookCoverUrl);
              display1 = b; 
              addBookToFireBaseGlobal(b);

              try {
                var resp2 = allResponses[1].split("|");
                String title2 = resp2[0];
                String author2 = resp2[1];
                var rating2 = double.parse(resp2[2]);
                var pages2 = int.parse(resp2[3]);
                var bookCoverUrl2 = "$title2$author2.jpg";
                Book c = new Book(
                    title: title2,
                    author: author2,
                    pages: pages2,
                    rating: rating2,
                    coverImageURL: bookCoverUrl2);
                display2 = c;

                bookToDisplay = true;
                secondBookToo = true;
                searching = false;

                //update firebase
                addBookToFireBaseGlobal(c);
              }
              catch(e){
                secondBookToo = false;
                bookToDisplay = true;
                searching = false;
              }
              
            }
          })
        });
  }
}
