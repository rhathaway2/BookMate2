//flutter imports
import 'package:bookmate2/BookDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

//file imports
import 'classes.dart';
import 'search.dart';

/*
The purpose of this class is to display all the books in the users library
It contains 2 lists of books booklist and favorited
*/
class LibraryPage extends StatefulWidget {
  LibraryPage({Key key, this.uid, this.dkey}) : super(key: key);
  final String uid;
  final List<Book> booklist = [];
  final List<Book> favorited = [];
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

  bool bookAdded = false;

  //Constructor
  _LibraryPageState({this.booklist, this.favorited});

  @override
  void initState() {
    super.initState();
  }

  void addCallback() {
    setState(() {
      bookAdded = true;
    });
  }

  void forceUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "AddButton",
          elevation: 4.0,
          backgroundColor: Colors.teal[200],
          icon: const Icon(Icons.add),
          label: const Text('Add Book'),
          onPressed: () {
            openSearchMenu();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      /*  bottomNavigationBar: BottomAppBar(
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
        */
        body: buildBookList());
  }

  /*
  open search menu
  */
  void openSearchMenu() {
    bookAdded = false;
    //open search menu
    Navigator.of((context)).push(MaterialPageRoute(
        builder: (context) =>
            SearchList(uid: widget.uid, refresh: addCallback)));
  }

  /*
  Get List of books from firebase
  */
  Widget buildBookList() {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("users/${widget.uid}/Books")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new ListTile(
              leading: Icon(Icons.mood_bad),
              title: Text("No books in library"),
              subtitle: Text("Click below to find books"),
            );
          }
          return new ListView(children: getBookList(snapshot));
        });
  }

  /*
  Map firebase snapshop to BookCards
  */
  getBookList(AsyncSnapshot<QuerySnapshot> snapshot) {
    //add all books to booklist vector
    snapshot.data.documents.map((doc) => {
          if (doc.documentID != "inializer")
            {
              booklist.add(new Book(
                  title: doc["title"],
                  author: doc['author'],
                  pages: doc['pages'],
                  rating: doc['rating'],
                  coverImageURL: doc['url'],
                  userRating: doc['userRating'].toDouble())),
            }
        });
    return snapshot.data.documents
        .map(
          (doc) => new Container(
            width: 400.0,
            height: 160.0,
            child: new BookCard(
              new Book(
                  title: doc["title"],
                  author: doc['author'],
                  pages: doc['pages'],
                  rating: doc['rating'],
                  coverImageURL: doc['url'],
                  userRating: doc['userRating'].toDouble()),
              false,
              widget.uid,
              forceUpdate,
            ),
          ),
        )
        .toList();
  }
}

//Class for each book card
class BookCard extends StatefulWidget {
  final Book book; //book displayed on card
  final bool isFavorited;
  final String uid;
  final void Function() refresh;
  BookCard(this.book, this.isFavorited, this.uid, this.refresh); //constructor

  @override
  _BookCardState createState() => _BookCardState(book, isFavorited);
}

//class for the state of the book card
class _BookCardState extends State<BookCard> {
  Book book; //book being displayed
  bool isFavorited;
  Widget holdingImage = new Image(image: AssetImage('images/questionmark.png'));
  _BookCardState(this.book, this.isFavorited);

  Future<Widget> getCoverImageFuture(String coverURL) async {
    Image img;
    final ref = FirebaseStorage.instance.ref().child(coverURL);
    var url = await ref.getDownloadURL();
    img = Image.network(url.toString(), fit: BoxFit.cover);
    return img;
  }

  //get cover of the book
  Widget getCoverImage() {
    return FutureBuilder(
        future: getCoverImageFuture(widget.book.coverImageURL),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            holdingImage = snapshot.data;
            return Container(
              padding: EdgeInsets.only(left: 2),
              width: 100.0,
              height: 160.0,
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
              height: 160.0,
              child: holdingImage,
            );
          }
        });
  }

  //get book card
  Widget get bookCard {
    return Container(
        width: MediaQuery.of(context).size.width - 70,
        height: 160.0,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(
              //top: 1.0,
              //bottom: 1.0,
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
                        heroTag: Key(widget.book.title),
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

  //remove a book from firebase
  Future<void> removeBook(Book b) async {
    await Firestore.instance
        .collection("users/${widget.uid}/Books")
        .document((b.title))
        .delete()
        .then((resp) => {widget.refresh()});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: IconSlideAction(
              caption: "Delete",
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                removeBook(widget.book);
              },
            ),
          )
        ],
        child: GestureDetector(
          onTap: () {
            Navigator.of((context)).push(MaterialPageRoute(
                builder: (context) =>
                    BookDetailsPage(uid: widget.uid, book: widget.book)));
          },
          child: Container(
            height: 160.0,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Positioned(left: 70.0, child: bookCard),
                Positioned(top: 5.0, child: getCoverImage()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
