import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';

//imports for tabs
import 'library.dart';
import 'social.dart';
import 'activity.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookMate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'BookMate'),
    );
  }
}

/*

*/
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


/*

*/
class _MyHomePageState extends State<MyHomePage> {

  static int _currentIndex = 0; //index of current tab
  //List of widgets to be displayed for each tab
  final List<Widget> _pages = [
    PlaceHolderWidget(Colors.green),
    PlaceHolderWidget(Colors.blue),
    PlaceHolderWidget(Colors.red),
  ];

  static void changePage(int index){
    _navigationController.value = index;
    _currentIndex = index;
  }

  //controller for circular bottom nav bar
  static CircularBottomNavigationController _navigationController = 
  new CircularBottomNavigationController(_currentIndex);
  //List of tabItems for circulatr bottom navigation bar
  List<TabItem> tabItems =  List.of([
    new TabItem(Icons.poll, "Activity", Colors.cyan, labelStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.cyan),),
    new TabItem(Icons.people, "Social", Colors.cyan, labelStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.cyan)),
    new TabItem(Icons.book, "Library", Colors.cyan, labelStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.cyan)),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      //body
      body: _pages[_currentIndex],

      //Adds Navigation bar to the bottom of the app screen
      bottomNavigationBar: CircularBottomNavigation(
        tabItems,
        controller: _navigationController,
        selectedCallback: (int selectedPos){
          //call set state and update index of current page
          setState(() {
            _navigationController.value = selectedPos;
            _currentIndex = selectedPos;
          });
        },
      )
    );
  }
}



class PlaceHolderWidget extends StatelessWidget{
  final Color color;
  PlaceHolderWidget(this.color);

  @override
  Widget build(BuildContext context){
    return Container(
      color: color,
    );
  }
}
