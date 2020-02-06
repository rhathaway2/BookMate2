/*
The purpose of this file is to store all of the various classes that will be used throughout the app
in a single file

Current Classes:
1. Note
2. Review
3. Books
*/

/*
Class to store a note
*/
class Note{
  String title;
  String contents;
}

/*
Class to represent a review
*/
class Review{
  String book;
  String title;
  String contents;
  String reviewer;
}

/*
class to store information about each book
*/
class Book{
  String title;                
  String author;               
  int pages;                   
  int isbn;                    
  double rating;               
  String coverImageURL;
  //constructor for book       
  Book({
    this.title,
    this.author,               
    this.pages,                
    this.isbn,                 
    this.rating,               
    this.coverImageURL,
  });
}