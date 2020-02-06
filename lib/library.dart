//flutter imports
import 'package:flutter/material.dart';

//file imports
import 'classes.dart';

/*
The purpose of this class is to display all the books in the users library
It contains 2 lists of books booklist and favorited
*/
class LibraryPage extends StatefulWidget {

  //List of books to display
  static Book test1 = new Book(
    title: "Ender's Game",
    author: "Orson Scott Card",
    pages: 350,
    isbn: 1234567890,
    rating: 4.67,
    coverImageURL: "https://raw.githubusercontent.com/rhathaway2/BookMate/master/imgs/endersgame.jpg"
  );  
  static Book test2 = new Book(
    title: "The Eye of the World",
    author: "Robert Jordan",
    pages: 465,
    isbn: 0987654321,
    rating: 4.89,
    coverImageURL: "https://raw.githubusercontent.com/rhathaway2/BookMate/master/imgs/eyeoftheworld.jpg"
  );  
  static Book test3 = new Book(
    title: "Dune",
    author: "Frank Herbert",
    pages: 542,
    isbn: 0987654321,
    rating: 4.37,
    coverImageURL: "https://raw.githubusercontent.com/rhathaway2/BookMate/master/imgs/dune.jpg"
  );  
  static Book test4 = new Book(
    title: "Hyperion",
    author: "Dan Simmons",
    pages: 398,
    isbn: 0987654321,
    rating: 4.74,
    coverImageURL: "https://raw.githubusercontent.com/rhathaway2/BookMate/master/imgs/hyperion.jpg"
  );  



  final List<Book> booklist=[test1, test2, test3, test4];
  final List<Book> favorited=[];

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
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              )
            ],
          ),
        ),
        body: _buildBookList());
  }

  //function to build book list
  Widget _buildBookList() {
    return ListView.builder(
        key: UniqueKey(),
        padding: const EdgeInsets.all(10.0),
        //number of items is the size of our list
        itemCount: booklist.length,
        itemBuilder: (context, i) {
          //build each individual row
          Book cur = booklist[i];
          bool fav = favorited.contains(cur);
          return BookCard(cur, fav);
        });
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

  //init state function
  void initState() {
    super.initState();
  }

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
