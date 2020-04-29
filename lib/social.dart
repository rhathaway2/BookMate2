import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'classes.dart';
import 'library.dart';

/*

*/
class SocialPage extends StatefulWidget {
  SocialPage({Key key, this.uid, this.dkey, this.title}) : super(key: key);
  final String uid;
  final String title;
  final GlobalKey<ScaffoldState> dkey;

  @override
  _SocialPageState createState() => _SocialPageState();
}

/*

*/
class _SocialPageState extends State<SocialPage> {
  bool searchVisible = false;
  List<Friend> friendsList = [];
  String fname;
  String lname;

  @override
  void initState() {
    super.initState();
    getFriendsListList().then((value) => setState(() {}));
    getMe();
  }

  bool listContains(String first, String last) {
    for (var i = 0; i < friendsList.length; i++) {
      if (friendsList[i].fname == first && friendsList[i].lname == last) {
        return true;
      }
    }
    return false;
  }

  bool isMe(String first, String last) {
    return first == fname && last == lname;
  }

  Future<void> getMe() async {
    Firestore.instance
        .collection("users")
        .document("${widget.uid}")
        .get()
        .then((doc) => {
              fname = doc["fname"],
              lname = doc['surname'],
            });
  }

  Future<void> getFriendsListList() async {
    Firestore.instance
        .collection("users/${widget.uid}/Friends")
        .getDocuments()
        .then((QuerySnapshot snap) => {
              snap.documents.forEach((doc) {
                friendsList.add(
                  new Friend(
                    fname: doc['fname'],
                    lname: doc['surname'],
                    uid: doc['uid'],
                  ),
                );
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(text: "All Users"),
              Tab(text: "My Friends"),
            ],
          ),
        ),
        body: TabBarView(children: [
          buildAllUsersList(),
          buildFriendsList(),
        ]),
      ),
    );
  }

  /*
  Get List of books from firebase
  */
  Widget buildFriendsList() {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("users/${widget.uid}/Friends")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return new ListView(children: getFriendsList(snapshot));
        });
  }

  /*
  Map firebase snapshop to BookCards
  */
  getFriendsList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map(
          (doc) => new Container(
            child: FriendCard(
              uid: widget.uid,
              friend: Friend(
                fname: doc['fname'],
                lname: doc['surname'],
                uid: doc['uid'],
              ),
              flag: 1,
              friendslist: friendsList,
            ),
          ),
        )
        .toList();
  }

  Widget buildAllUsersList() {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("allUsers/").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return new ListView(children: getAllUsersList(snapshot));
        });
  }

  /*
  Map firebase snapshop to BookCards
  */
  List<Widget> getAllUsersList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map(
          (doc) => new Container(
            child: FriendCard(
              uid: widget.uid,
              friend: Friend(
                fname: doc['fname'],
                lname: doc['surname'],
                uid: doc['uid'],
              ),
              flag: listContains(doc['fname'], doc['surname'])
                  ? 2
                  : isMe(doc['fname'], doc['surname']) ? 3 : 0,
              friendslist: friendsList,
            ),
          ),
        )
        .toList();
  }

  bool inFriendsList(String first, String last) {
    bool found = false;
    for (final element in friendsList) {
      if (element.fname == first && element.lname == last) {
        found = true;
        break;
      }
    }
    return found;
  }
}

class FriendCard extends StatefulWidget {
  final String uid;
  final Friend friend;
  final int flag;
  final List<Friend> friendslist;

  FriendCard({this.uid, this.friend, this.flag, this.friendslist});

  @override
  _FriendCardState createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  Widget buttonText = Text("Add");

  @override
  void initState() {
    super.initState();
    if (inFriendsList(widget.friend.fname, widget.friend.lname)) {
      buttonText = Icon(Icons.check);
    }
  }

  bool inFriendsList(String first, String last) {
    bool found = false;
    for (final element in widget.friendslist) {
      if (element.fname == first && element.lname == last) {
        found = true;
        break;
      }
    }
    return found;
  }

  /*
  Add friend to firebase
  */
  Future<void> addFriend(Friend fun) async {
    Firestore.instance
        .collection("users/${widget.uid}/Friends")
        .document(fun.fname + " " + fun.lname)
        .setData({
      "fname": fun.fname,
      "surname": fun.lname,
      "uid": fun.uid,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: 60.0,
        child: Card(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: CircleAvatar(
                  backgroundColor: Colors.teal[200],
                  child: Text(widget.friend.fname[0] + widget.friend.lname[0],
                      style: TextStyle(fontSize: 20.0, color: Colors.white)),
                ),
              ),
              Text(widget.friend.fname + " " + widget.friend.lname),
              //add button
              Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  color: Colors.teal[200],
                  child: widget.flag == 0
                      ? buttonText
                      : (widget.flag == 1)
                          ? Text("View Profile")
                          : widget.flag == 2 ? Icon(Icons.check) : Text("You"),
                  onPressed: () {
                    if (widget.flag == 0) {
                      addFriend(widget.friend);
                      setState(() {
                        buttonText = Icon(Icons.check);
                        widget.friendslist.add(widget.friend);
                      });
                    } else if (widget.flag == 1) {
                      //vuew profile
                      Navigator.of((context)).push(MaterialPageRoute(
                          builder: (context) =>
                              FriendProfilePage(uid: widget.friend.uid.trim())));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FriendProfilePage extends StatefulWidget {
  final String uid;

  FriendProfilePage({this.uid});

  @override
  FriendProfilePageState createState() => FriendProfilePageState();
}

class FriendProfilePageState extends State<FriendProfilePage> {
  DocumentSnapshot fdoc;
  int f_count, b_count;

  @override
  void initState() {
    print(widget.uid);
    fdoc=null;
    f_count=null;
    b_count=null;
    super.initState();
    Firestore.instance
        .collection("users")
        .document(widget.uid.trim())
        .get()
        .then((DocumentSnapshot result) => { fdoc = result,update() });
    Firestore.instance
        .collection("users/${widget.uid}/Friends")
        .getDocuments()
        .then((myDocuments) =>
            {f_count = myDocuments.documents.length,});
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
    if (this.fdoc == null || f_count == null || b_count == null) {
      return SizedBox(height: MediaQuery.of(context).size.height);
    }
    else{
      return Scaffold(
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
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              Center(
                child: CircleAvatar(
                  backgroundColor: Colors.teal[200],
                  minRadius: 70.0,
                  child: Text(
                    "${this.fdoc["fname"][0]}${this.fdoc["surname"][0]}",
                    style: TextStyle(fontSize: 50.0, color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              Center(
                child: Text(
                  "${this.fdoc["fname"]} ${this.fdoc["surname"]}",
                  style: TextStyle(fontSize: 30.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              Center(child: Text("$f_count Friends  |  $b_count Books")),
              Divider(),
              Container(
                height:320.0,  
                child:buildBookList(),
              ),
            ],
          ),
        ),
      ),
    );
    }
  } //build()

  /*
  Get List of books from firebase
  */
  Widget buildBookList() {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("users/${widget.uid}/Books")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data.documents.length==0) {
            return new ListTile(
              title: Center(child: Text("No books in library"),),
            );
          }
          return new ListView(children: getBookList(snapshot));
        });
  }

  /*
  Map firebase snapshop to BookCards
  */
  getBookList(AsyncSnapshot<QuerySnapshot> snapshot) {
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
              false
            ),
          ),
        )
        .toList();
  }

}
