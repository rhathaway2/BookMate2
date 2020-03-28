import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'classes.dart';

/*

*/
class FriendStatus extends StatefulWidget {
  FriendStatus({Key key, this.uid, this.title}) : super(key: key);
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
  void initState() {
    super.initState();
    Firestore.instance
        .collection("users/${widget.uid}/Friends")
        .getDocuments()
        .then((myDocuments) =>
            {f_count = myDocuments.documents.length, update()});
  }

  void update() {
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
              Icon(
                Icons.person,
                size: 30.0,
              ),
              Text(
                "$f_count Friends",
                style: TextStyle(fontSize: 18.0),
              )
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
  BookStatus({Key key, this.uid, this.title}) : super(key: key);
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
  void initState() {
    super.initState();
    Firestore.instance
        .collection("users/${widget.uid}/Books")
        .getDocuments()
        .then((myDocuments) =>
            {b_count = myDocuments.documents.length, update()});
  }

  void update() {
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
              Icon(
                Icons.book,
                size: 30.0,
              ),
              Text(
                "$b_count Books",
                style: TextStyle(fontSize: 18.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//Class for each book card
class CurrentBookCard extends StatefulWidget {
  final String uid;
  CurrentBookCard(this.uid); //constructor

  @override
  _CurrentBookCardState createState() => _CurrentBookCardState();
}

//class for the state of the book card
class _CurrentBookCardState extends State<CurrentBookCard> {
  Book book; //book being displayed
  Widget holdingImage = new Image(image: AssetImage('images/questionmark.png'));

  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection("users/${widget.uid}/Current")
        .document("CurrentBook")
        .get()
        .then((doc) => {
              setState(() {
                book = new Book(
                    title: doc["title"],
                    author: doc['author'],
                    pages: doc['pages'],
                    rating: doc['rating'],
                    coverImageURL: doc['url'],
                    userRating: doc['userRating'].toDouble());
              }),
            });
  }

  Future<Widget> getCoverImageFuture(String coverURL) async {
    Image img;
    final ref = FirebaseStorage.instance.ref().child(coverURL);
    var url = await ref.getDownloadURL();
    img = Image.network(url.toString(), fit: BoxFit.cover);
    return img;
  }

  //get cover of the book
  Widget getCoverImage() {
    if(book == null){
      return Container();
    }
    return FutureBuilder(
        future: getCoverImageFuture(book.coverImageURL),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            holdingImage = snapshot.data;
            return Container(
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.all(Radius.circular(30.0)), 
              ),
              width: 100.0,
              height: 160.0,
              child: ClipRRect(
                borderRadius: new BorderRadius.all(Radius.circular(18.0)), 
                child: snapshot.data,
              )
            );
          } else {
            return Container(
              width: 100.0,
              height: 160.0,
              child: ClipRRect(
                borderRadius: new BorderRadius.all(Radius.circular(18.0)), 
                child: holdingImage
              )
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    if(book == null){
      return Container();
    }
    return Container(
      child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        elevation: 14.0,
        shadowColor: Color(0x802196F3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        color: Colors.teal[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            getCoverImage(),
            Padding(
              padding: EdgeInsets.only(left: 14.0),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Currently Reading", style: TextStyle(fontSize:22.0, fontWeight: FontWeight.bold)),
                Text(book.title, style: TextStyle(fontSize: 18.0)),
                Text(book.author, style: TextStyle(fontSize: 14.0)),
                Text("${book.pages.toString()} pages",
                    style: TextStyle(fontSize: 14.0)),
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
            )
          ],
        ),
        ),
      ),
    );
      
  }
}
