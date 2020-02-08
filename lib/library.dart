//flutter imports
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//file imports
import 'classes.dart';

/*
The purpose of this class is to display all the books in the users library
It contains 2 lists of books booklist and favorited
*/
class LibraryPage extends StatefulWidget {
  LibraryPage({Key key, this.uid, this.dkey}): super(key:key);
  final String uid;
  final List<Book> booklist=[];
  final List<Book> favorited=[];
  final GlobalKey<ScaffoldState> dkey;


  @override
  _LibraryPageState createState() =>
      _LibraryPageState(booklist: this.booklist, favorited: this.favorited);
}

/*

*/
class _LibraryPageState extends State<LibraryPage> {
  //Variables
  List<Book> booklist;
  List<Book> favorited;

  //Constructor
  _LibraryPageState({this.booklist, this.favorited});

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          elevation: 4.0,
          icon: const Icon(Icons.add),
          label: const Text('Add Book'),
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
        body: buildBookList());
  }

  /*
  Get List of books from firebase
  */
  Widget buildBookList(){
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("users/${widget.uid}/Books").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData) {
          return new ListTile(
            leading: Icon(Icons.mood_bad),
            title: Text("No books in library"),
          subtitle: Text("Click below to find books"),
          );
        }
        return new ListView(children: getBookList(snapshot));
      }
    );
  }

  getBookList(AsyncSnapshot<QuerySnapshot> snapshot){
    //add all books to booklist vector
    snapshot.data.documents.map((doc) => {
      if(doc.documentID != "inializer"){
        booklist.add(new Book(title: doc["title"], author: doc['author'], pages: doc['pages'], isbn: doc['isbn'], rating: doc['rating'], coverImageURL: doc['url'] )),
      }
    });
    return snapshot.data.documents.map(
      (doc) => 
        new Container(
          width: 400.0,
          height: 160.0,
          child: new BookCard(
            new Book(title: doc["title"], author: doc['author'], pages: doc['pages'], isbn: doc['isbn'], rating: doc['rating'], coverImageURL: doc['url'] ), false
            )))
    .toList();
  }

}

//Class for each book card
class BookCard extends StatefulWidget {
  final Book book; //book displayed on card
  final bool isFavorited;
  BookCard(this.book, this.isFavorited); //constructor

  @override
  _BookCardState createState() => _BookCardState(book, isFavorited);
}

//class for the state of the book card
class _BookCardState extends State<BookCard> {
  Book book; //book being displayed
  bool isFavorited;
  _BookCardState(this.book, this.isFavorited);

  //get cover of the book
  Widget get coverImage {
    return Container(
      width: 100.0,
      height: 150.0,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(this.book.coverImageURL ?? ''),
        ),
      ),
    );
  }

  //get book card
  Widget get bookCard {
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
                Text(widget.book.title,
                    style: Theme.of(context).textTheme.headline),
                Text(widget.book.author,
                    style: Theme.of(context).textTheme.subhead),
                Text("${widget.book.pages.toString()} pages",
                    style: Theme.of(context).textTheme.subhead),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                    ),
                    Text(': ${widget.book.rating} / 5'),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 100.0,
                      ),
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            isFavorited = !isFavorited;
                          });
                        },
                        child: Icon(isFavorited
                            ? Icons.favorite
                            : Icons.favorite_border),
                        backgroundColor: Colors.pink,
                        mini: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
      child: Container(
          height: 160.0,
          width: 200.0,
          child: Stack(
            children: <Widget>[
              Positioned(left: 70.0, child: bookCard),
              Positioned(top: 5.0, child: coverImage),
            ],
          )),
    );
  }
}
