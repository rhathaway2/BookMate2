import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'classes.dart';
import 'activity_page_widgets.dart';
import 'package:flutter_xlider/flutter_xlider.dart';


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
        child:Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          WeekActivity(uid: widget.uid),
          CurrentBookCard(widget.uid),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FriendStatus(uid: widget.uid,),
              BookStatus(uid: widget.uid,)
            ],
          ),
        ],
      ),),),
    );
  }
}


class WeekActivity extends StatefulWidget {
  final String uid;
  WeekActivity({this.uid});
  @override
  WeekActivityState createState() => WeekActivityState();
}

class WeekActivityState extends State<WeekActivity> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: WeekBarGraph(uid: widget.uid),
    );
  }
}

class WeekBarGraph extends StatefulWidget {
  final String uid;
  WeekBarGraph({this.uid});
  @override
  WeekBarGraphState createState() => WeekBarGraphState();
}

class WeekBarGraphState extends State<WeekBarGraph> {
  bool colapsed = true;
  double _lowerValue=0;
  double _upperValue=500;
  final Duration animDuration = Duration(milliseconds: 2500);

  int touchedIndex;

  List<ReadingData> readingData = [
    ReadingData(day: "Mon", pages: 0),
    ReadingData(day: "Tue", pages: 0),
    ReadingData(day: "Wed", pages: 0),
    ReadingData(day: "Thur", pages: 0),
    ReadingData(day: "Fri", pages: 0),
    ReadingData(day: "Sat", pages: 0),
    ReadingData(day: "Sun", pages: 0),
  ];

  @override
  void initState(){
    super.initState();
    Firestore.instance
        .collection("users/${widget.uid}/WeeklyReadingData").document("data").get().then((data) => {
          for(var i=0; i < readingData.length; i++){
            readingData[i].pages = data[readingData[i].day].toDouble()
          },
          update()
        });
    
    }

  void update() {
    setState(() {
      //update
    });
  }

  void updateDailyReading(double pages){
    String currentDay="";
    //get current day
    DateTime date = DateTime.now();
    switch(date.weekday){
      case 1: currentDay="Mon"; break;
      case 2: currentDay="Tue"; break;
      case 3: currentDay="Wed"; break;
      case 4: currentDay="Thur"; break;
      case 5: currentDay="Fri"; break;
      case 6: currentDay="Sat"; break;
      case 7: currentDay="Sun"; break;
    }

    Firestore.instance
      .collection("users/${widget.uid}/WeeklyReadingData").document("data")
      .setData({
        "$currentDay": pages
      }, merge: true);
  }

  Widget buildReadingUpdateDialog(BuildContext context){
    return new AlertDialog(
      title: const Text("Daily Reading Log"),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("How many pages did you read today?"),
          FlutterSlider(
            values: [500],
            min: 0,
            max: 500,
            onDragCompleted: (handlerIndex, lowerValue, upperValue){
              setState(() {
                updateDailyReading(lowerValue);
              });
            },

          ),
        ],
      ),
    );
  }

  //retrieve weekly reading data from firebase
  getWeekData(){
    Firestore.instance
        .collection("users/${widget.uid}/WeeklyReadingData").document("data").get().then((data) => {
          for(int i=0; i < readingData.length; i++){
            readingData[i].pages = data[readingData[i].day].toDouble()
          },
          update()
        });
  }

  String getMonth(int mon){
    switch(mon){
      case 0:
        return "January";
      case 1:
        return "February";
      case 2:
        return "March";
      case 3:
        return "April";
      case 4:
        return "May";
      case 5:
        return "June";
      case 6:
        return "July";
      case 7:
        return "August";
      case 8:
        return "September";
      case 9:
        return "October";
      case 10:
        return "November";
      case 11:
        return "December";
      default:
        return "Invalid Date";
    }
  }

  String getCurretWeekString(){
    var now = DateTime.now();
    var weekStart = now.subtract(Duration(days: now.weekday-1));
    var weekEnd = now.add(Duration(days: DateTime.daysPerWeek-now.weekday));
    
    String weekInfo = "Mon " + getMonth(weekStart.month) + " " + weekStart.day.toString() + " - ";
    weekInfo +=  ("Sun " + getMonth(weekEnd.month) + " " + weekEnd.day.toString());
    return weekInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 14.0,
        shadowColor: Color(0x802196F3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.teal[200],
        child: colapsed ? collapsedGraphDisply() : fullGraphDisplay(/*context*/),
      ),
    );
  }

  Widget collapsedGraphDisply() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                'Weekly Reading',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                getCurretWeekString(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
                icon: Icon(colapsed ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                    size: 45.0),
                onPressed: () {
                  setState(() {
                    colapsed = !colapsed;
                  });
                }),
          ),
        ),
      ],
    );
  }

  Widget fullGraphDisplay(/*BuildContext context*/) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                'Weekly Reading',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                getCurretWeekString(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              colapsed ? Container() : const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: BarChart(
                  mainBarData(),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
                icon: Icon(colapsed ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                    size: 45.0),
                onPressed: () {
                  setState(() {
                    colapsed = !colapsed;
                  });
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 65.0),
          child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
                icon: Icon(Icons.add,
                    size: 45.0),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => buildReadingUpdateDialog(context),
                  ).then((_) => getWeekData());
                }),
          ),
        ),
      ],
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            color: Colors.teal[200],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, readingData[i].pages,
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, readingData[i].pages,
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, readingData[i].pages,
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, readingData[i].pages,
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, readingData[i].pages,
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, readingData[i].pages,
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, readingData[i].pages,
                isTouched: i == touchedIndex);
          default:
            return null;
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
              }
              return BarTooltipItem(
                  weekDay + '\n' + (rod.y - 1).toInt().toString() + " pages",
                  TextStyle(color: Colors.yellow));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: const SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }
}
