import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'classes.dart';

/*

*/
class ActivityPage extends StatefulWidget {
  ActivityPage({Key key, this.uid, this.dkey, this.user}) : super(key: key);
  final DocumentSnapshot user;
  final String uid;
  final GlobalKey<ScaffoldState> dkey;
  final List<Post> activity = [];

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

/*

*/
class _ActivityPageState extends State<ActivityPage> {
  TextEditingController postTitleInputController;
  TextEditingController postDescripInputController;
  bool searchVisible = false;

  @override
  void initState() {
    postTitleInputController = new TextEditingController();
    postDescripInputController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal[200],
        elevation: 4.0,
        icon: const Icon(Icons.add),
        label: const Text('Create Post'),
        onPressed: () {
          _postDialog();
        },
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
              onPressed: () {
                //searchVisible = !searchVisible;
                //setState(() {});
              },
            )
          ],
        ),
      ),
      body: buildActivityList(),
    );
  }

  /*
  Get List of books from firebase
  */
  Widget buildActivityList() {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("users/${widget.uid}/Posts")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new ListTile(
              leading: Icon(Icons.mood_bad),
              title: Text("No Activity or Posts yes"),
              subtitle: Text("Click below to post"),
            );
          }
          return new ListView(children: getActivityList(snapshot));
        });
  }

  getActivityList(AsyncSnapshot<QuerySnapshot> snapshot) {
    //add all books to booklist vector
    snapshot.data.documents.map((doc) => {
          if (doc.documentID != "inializer")
            {
              widget.activity.add(new Post(
                  title: doc['title'],
                  contents: doc["contents"],
                  time: doc["Date"].toString())),
            }
        });
    return snapshot.data.documents
        .map((doc) => new Padding(
            padding: EdgeInsets.all(5.0),
            child: new Container(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(15.0),
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.black),
                    bottom: BorderSide(width: 1.0, color: Colors.black),
                    left: BorderSide(width: 1.0, color: Colors.black),
                    right: BorderSide(width: 1.0, color: Colors.black),
                  ),
                ),
                child: new ListTile(
                  leading: new CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text("${widget.user["fname"][0]}",
                          style: TextStyle(fontSize: 30.0))),
                  title: Text(doc['title']),
                  subtitle: Text(doc['contents']),
                ))))
        .toList();
  }

  _postDialog() async {
    await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: Column(
              children: <Widget>[
                Text("Create a new Post"),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(labelText: 'Post Title*'),
                    controller: postTitleInputController,
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Post Contents*'),
                    controller: postDescripInputController,
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    postTitleInputController.clear();
                    postDescripInputController.clear();
                    Navigator.pop(context);
                  }),
              FlatButton(
                  child: Text('Add'),
                  onPressed: () {
                    if (postDescripInputController.text.isNotEmpty &&
                        postTitleInputController.text.isNotEmpty) {
                      Firestore.instance
                          .collection('Posts')
                          .document(postTitleInputController.text)
                          .setData({
                            "title": postTitleInputController.text,
                            "contents": postDescripInputController.text,
                            "date": DateTime.now()
                          })
                          .then((result) => {
                                Navigator.pop(context),
                                postTitleInputController.clear(),
                                postDescripInputController.clear(),
                              })
                          .catchError((err) => print(err));
                    }
                  })
            ],
          );
        });
  }
}

class WeekActivity extends StatefulWidget {
  @override
  WeekActivityState createState() => WeekActivityState();
}

class WeekActivityState extends State<WeekActivity> {

  List<ReadingData> readingData = [
    ReadingData(day: "Sun", pages: 10),
    ReadingData(day: "Mon", pages: 23),
    ReadingData(day: "Tue", pages: 43),
    ReadingData(day: "Wed", pages: 13),
    ReadingData(day: "Thu", pages: 15),
    ReadingData(day: "Fri", pages: 34),
    ReadingData(day: "Sat", pages: 27),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Container(
          child: WeekBarGraph(),
        ),
      ),
    );
  }
}


class WeekBarGraph extends StatefulWidget {
  @override
  WeekActivityState createState() => WeekActivityState();
}

class WeekBarBraphState extends State<WeekBarGraph> {

  final Duration animDuration = Duration(milliseconds: 250);

  int touchedIndex;

  List<ReadingData> readingData = [
    ReadingData(day: "Sun", pages: 10),
    ReadingData(day: "Mon", pages: 23),
    ReadingData(day: "Tue", pages: 43),
    ReadingData(day: "Wed", pages: 13),
    ReadingData(day: "Thu", pages: 15),
    ReadingData(day: "Fri", pages: 34),
    ReadingData(day: "Sat", pages: 27),
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.teal[200],
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'Weekly Activity',
                    style: TextStyle(
                        color: Colors.teal[200], fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Pages read this week',
                    style: TextStyle(
                        color: Colors.teal[200], fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}