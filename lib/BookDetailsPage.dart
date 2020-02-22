import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'classes.dart';

/*

*/
class BookDetailsPage extends StatefulWidget {
  BookDetailsPage({Key key, this.uid, this.book}) : super(key: key);
  final String uid;
  final Book book;

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

/*

*/
class _BookDetailsPageState extends State<BookDetailsPage> {
  String url;
  @override
  void initState() {
    super.initState();
    getBookURL();
  }

  Future<void> getBookURL() async{
    final ref = FirebaseStorage.instance.ref().child(widget.book.coverImageURL);
    var _url = await ref.getDownloadURL();
    setState(() {
      url = _url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.white,
        appBar: AppBar(
          bottomOpacity: 0.0,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.teal[200],
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          automaticallyImplyLeading: false,
          //backgroundColor: Colors.white,
        ),
        body: Column(children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
                child: Container(
              height: 260.0,
              width: 200.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        url ?? "",
                        scale: 2.0,
                      )),
                  borderRadius:
                      BorderRadius.all(Radius.elliptical(50.0, 50.0))),
            )),
          ),
          //start inputs
          SmoothStarRating(
              allowHalfRating: true,
              onRatingChanged: (value) {
                //update display rating
                widget.book.userRating = value;
                setState(() {});
                //update user rating in firebase
                Firestore.instance
                    .collection("users/${widget.uid}/Books")
                    .document((widget.book.title))
                    .setData({
                  "title": widget.book.title,
                  "author": widget.book.author,
                  "pages": widget.book.pages,
                  "isbn": widget.book.isbn,
                  "rating": widget.book.rating,
                  "url": widget.book.coverImageURL,
                  "userRating": value
                });
              },
              starCount: 5,
              rating: widget.book.userRating,
              size: 40.0,
              defaultIconData: Icons.star_border,
              filledIconData: Icons.star,
              halfFilledIconData: Icons.star_half,
              color: Colors.amber,
              borderColor: Colors.amber,
              spacing: 0.0),

          Divider(
            height: 25.0,
            indent: 10.0,
            endIndent: 10.0,
            color: Colors.black87,
          ),
          Card(
              color: Colors.teal[200],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Center(
                          child: Text(
                        widget.book.title,
                        style: TextStyle(fontSize: 25.0, color: Colors.white),
                      ))),
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Center(
                          child: Text(
                        "By ${widget.book.author}",
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ))),
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Center(
                          child: Text(
                        "${widget.book.pages} pages",
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ))),
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Center(
                          child: Text(
                        "${widget.book.rating} / 5.0 via Goodreads",
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ))),
                ],
              )),
             Divider(
            height: 25.0,
            indent: 10.0,
            endIndent: 10.0,
            color: Colors.black87,
          ),
          //review text box
          
        ]));
  }
}
