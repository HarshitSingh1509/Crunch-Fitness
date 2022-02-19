import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitness/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double totalsubscription = 0;
  List<Map<String, double>> subscription = [];
  int totalabsent = 0;
  List<Map<int, int>> absenttoday = [];
  int totalpresent = 0;
  List<Map<int, int>> presenttoday = [];
  int totaljoinedintimespan = 0;
  int todaynewjoin = 0;
  int todaynewthroughrefferal = 0;
  String ddval = "Last 6 Month";
  List<List<String>> refferaljoinerlist = [];
  List<List<String>> joinerlist = [];
  int ddintval = 2;
  @override
  void initState() {
    // TODO: implement initState
    totalsubs(6);
    absentchart();
    subscriptionchart();
    absenttodayfunc();
    totaljoined(6);
    super.initState();
  }

  Future<void> totalsubs(int n) async {
    double sum = 0;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('/Users');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    querySnapshot.docs.forEach((element1) async {
      QuerySnapshot _collectionRefdoc = await FirebaseFirestore.instance
          .collection('/Users/${element1.id}/Subscription')
          .get();
      _collectionRefdoc.docs.forEach((element) {
        // print(element["price"]);
        // print((element["startdate"] ?? Timestamp(0, 0))
        //     .compareTo(Timestamp(n * 30 * 24 * 60 * 60 * 100, 0)));
        if ((element["startdate"] ?? Timestamp(0, 0))
                .compareTo(Timestamp(n * 30 * 24 * 60 * 60 * 1000, 0)) <
            0) {
          print("its here");
          sum = sum + element["price"];
          setState(() {
            totalsubscription = sum;
          });
        }
      });
    });
  }

  Future<void> subscriptionchart() async {
    double sum = 0;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('/Users');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    querySnapshot.docs.forEach((element1) async {
      QuerySnapshot _collectionRefdoc = await FirebaseFirestore.instance
          .collection('/Users/${element1.id}/Subscription')
          .get();
      _collectionRefdoc.docs.forEach((element) {
        for (int p = 0; p < 5; p++) {
          sum = 0;
          if (((element["startdate"] ?? Timestamp(0, 0)).compareTo(
                      Timestamp((p + 1) * 30 * 24 * 60 * 60 * 1000, 0)) <
                  0) &&
              ((element["startdate"] ?? Timestamp(0, 0))
                      .compareTo(Timestamp((p) * 30 * 24 * 60 * 60 * 1000, 0)) >
                  0)) {
            sum = sum + element["price"];
          }
          setState(() {
            subscriptionchartdata[p] = (SalesData(
                (DateTime.now().month - p) < 1
                    ? (DateTime.now().month - p + 12)
                    : (DateTime.now().month - p),
                subscriptionchartdata[p].sales! + sum));
          });
          print(sum);
        }
      });
    });
  }

  List<SalesData> absentchartdata = [
    SalesData(1, 0),
    SalesData(1, 0),
    SalesData(1, 0),
    SalesData(1, 0),
    SalesData(1, 0)
  ];
  List<SalesData> presentchartdata = [
    SalesData(1, 0),
    SalesData(1, 0),
    SalesData(1, 0),
    SalesData(1, 0),
    SalesData(1, 0)
  ];
  Future<void> absentchart() async {
    double sum = 0;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('/Users');
    //   '/AppData/Attendance/UserAttendance/${months[today.month]},${today.year}/${today.day}');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    querySnapshot.docs.forEach((element1) async {
      for (int i = 0; i < 5; i++) {
        if (today.day - i > 0) {
          DocumentSnapshot qu = await FirebaseFirestore.instance
              .doc(
                  '/AppData/Attendance/UserAttendance/${months[today.month - 1]},${today.year}/${today.day - i}/${element1.id}')
              .get();

          if (qu.exists != true) {
            setState(() {
              absentchartdata[i] = SalesData(
                  (DateTime.now().day - i) <= 0
                      ? DateTime.now().day
                      : DateTime.now().day - i,
                  (DateTime.now().day - i) <= 0
                      ? 0
                      : absentchartdata[i].sales! + 1);
            });
          } else if (qu["status"] == true) {
            setState(() {
              presentchartdata[i] = SalesData(
                  (DateTime.now().day - i) <= 0
                      ? DateTime.now().day
                      : DateTime.now().day - i,
                  (DateTime.now().day - i) <= 0
                      ? 0
                      : presentchartdata[i].sales! + 1);
            });
          }
        }
        ;
        print(presentchartdata);
      }
    });
  }

  Future<String> search(String refid) async {
    try {
      var a = await FirebaseFirestore.instance
          .collection('/Users')
          .where('invite', isEqualTo: refid)
          .get();
      //  QuerySnapshot querySnapshot = await _collectionRef.get();
      return a.docs.first["name"];
    } catch (e) {
      return "";
    }
  }

  Future<void> totaljoined(int n) async {
    totaljoinedintimespan = 0;
    todaynewjoin = 0;
    double sum = 0;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('/Users');
    //   '/AppData/Attendance/UserAttendance/${months[today.month]},${today.year}/${today.day}');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    querySnapshot.docs.forEach((element1) async {
      // DocumentSnapshot qu = await FirebaseFirestore.instance
      //     .doc('/AppData/Attendance/UserAttendance/Feb,2022/1/${element1.id}')
      //     .get();

      if ((element1["joindate"] ?? Timestamp(0, 0))
              .compareTo(Timestamp(n * 30 * 24 * 60 * 60 * 1000, 0)) <
          0) {
        // print(element1["refferedby"]);
        // print(element1["name"]);
        if (element1['refferedby'] != "") {
          String tempname = await search(element1["refferedby"]);
          if (tempname != "") {
            if (((element1["joindate"] as Timestamp).toDate())
                    .difference(DateTime.now())
                    .inDays >=
                0) {
              setState(() {
                todaynewthroughrefferal = todaynewthroughrefferal + 1;
              });
            }
            setState(() {
              refferaljoinerlist.add([
                element1["address"],
                element1["name"],
                tempname,
                element1["refferedby"]
              ]);
            });
            //      print(refferaljoinerlist);
          }
        }

        setState(() {
          joinerlist.add([element1["address"], element1["name"]]);
        });

        setState(() {
          totaljoinedintimespan = totaljoinedintimespan + 1;
        });
      }
      print(((element1["joindate"] as Timestamp).toDate())
              .difference(DateTime.now())
              .inDays >=
          0);
      // print((DateTime(element1["joindate"].toDate()).difference(DateTime.now()))
      //     .toString());
      print(element1["name"]);
      if (((element1["joindate"] as Timestamp).toDate())
              .difference(DateTime.now())
              .inDays >=
          0) {
        setState(() {
          todaynewjoin = todaynewjoin + 1;
        });
      }
    });
  }

  List<SalesData> subscriptionchartdata = [
    SalesData(1, 0),
    SalesData(1, 0),
    SalesData(1, 0),
    SalesData(1, 0),
    SalesData(1, 0)
  ];

  Future<void> absenttodayfunc() async {
    totalabsent = 0;
    totalpresent = 0;
    double sum = 0;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('/Users');
    //   '/AppData/Attendance/UserAttendance/${months[today.month]},${today.year}/${today.day}');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    querySnapshot.docs.forEach((element1) async {
      print(
          "/AppData/Attendance/UserAttendance/${months[today.month - 1]},${today.year}/${today.day}/${element1.id}");
      DocumentSnapshot qu = await FirebaseFirestore.instance
          .doc(
              '/AppData/Attendance/UserAttendance/${months[today.month - 1]},${today.year}/${today.day}/${element1.id}')
          .get();

      if (qu.exists != true) {
        setState(() {
          totalabsent = totalabsent + 1;
        });
      } else if (qu["status"] == true) {
        setState(() {
          totalpresent = totalpresent + 1;
        });
      }
      ;
    });
  }

  List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  DateTime today = DateTime.now();
  // Future<void> presenttodayfunc() async {
  //   totalpresent =0;
  //   double sum = 0;
  //   CollectionReference _collectionRef = FirebaseFirestore.instance
  //       .collection('/AppData/Attendance/UserAttendance/Feb,2022/1');
  //   //   '/AppData/Attendance/UserAttendance/${months[today.month]},${today.year}/${today.day}');
  //   QuerySnapshot querySnapshot = await _collectionRef.get();
  //   querySnapshot.docs.forEach((element1) async {
  //     print(element1.id);
  //     if (element1["status"] == true) {
  //       setState(() {
  //         totalpresent = totalpresent + 1;
  //       });
  //     } else {
  //       setState(() {
  //         totalabsent = totalabsent + 1;
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var heightfactor = screenSize.height * 0.0012;
    var widthfactor = screenSize.width * 0.0007;
    var sizefactor = screenSize.shortestSide * 0.0012;
    return Padding(
      padding: EdgeInsets.only(
          left: 40 * screenSize.shortestSide * 0.0012,
          right: 40 * screenSize.shortestSide * 0.0012),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "OverView",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                width: 150 * screenSize.width * 0.0007,
                height: 40 * screenSize.height * 0.0012,
                color: Colors.white,
                child: Row(
                  children: [
                    SizedBox(
                        width: 115 * screenSize.width * 0.0007,
                        child: DropdownButton<String>(
                          items: <String>[
                            'Last 1 month',
                            'Last 3 month',
                            'Last 6 month',
                            'Last 1 Yr'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 18 * sizefactor),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              ddval = value!;
                              if (value == "Last 1 month") {
                                totaljoined(1);
                                totalsubs(1);
                                ddintval = 0;
                              }
                              if (value == "Last 3 month") {
                                totaljoined(3);
                                totalsubs(3);
                                ddintval = 1;
                              }
                              if (value == "Last 6 month") {
                                totaljoined(6);
                                totalsubs(6);
                                ddintval = 2;
                              }
                              if (value == "Last 1 Yr") {
                                totaljoined(12);
                                totalsubs(12);
                                ddintval = 3;
                              }
                            });
                          },
                          hint: Text(ddval),
                        )),
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    color: Colors.white,
                    width: screenSize.width * 0.2,
                    height: screenSize.height * 0.15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Subscription",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18 * screenSize.shortestSide * 0.0012),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "$totalsubscription",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25 *
                                          screenSize.shortestSide *
                                          0.0012),
                                ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "5",
                                //       style: TextStyle(
                                //           color: lightred,
                                //           fontSize: 10 *
                                //               screenSize.shortestSide *
                                //               0.0012),
                                //     ),
                                //     Icon(
                                //       Icons.arrow_upward,
                                //       size:
                                //           10 * screenSize.shortestSide * 0.0012,
                                //     )
                                //   ],
                                // )
                              ],
                            ),
                            Container(
                                width: 200 * screenSize.width * 0.0007,
                                height: 100 * screenSize.height * 0.0012,
                                child: SfCartesianChart(
                                    isTransposed: true,
                                    primaryXAxis: CategoryAxis(),
                                    series: <ChartSeries>[
                                      BarSeries<SalesData, String>(
                                          dataSource: subscriptionchartdata,
                                          xValueMapper: (SalesData sales, _) =>
                                              sales.year.toString(),
                                          yValueMapper: (SalesData sales, _) =>
                                              sales.sales)
                                    ]))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    color: Colors.white,
                    width: screenSize.width * 0.2,
                    height: screenSize.height * 0.15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Absent Today",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18 * screenSize.shortestSide * 0.0012),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "$totalabsent",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25 *
                                          screenSize.shortestSide *
                                          0.0012),
                                ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "5",
                                //       style: TextStyle(
                                //           color: lightred,
                                //           fontSize: 10 *
                                //               screenSize.shortestSide *
                                //               0.0012),
                                //     ),
                                //     Icon(
                                //       Icons.arrow_upward,
                                //       size:
                                //           10 * screenSize.shortestSide * 0.0012,
                                //     )
                                //   ],
                                // )
                              ],
                            ),
                            Container(
                                width: 200 * screenSize.width * 0.0007,
                                height: 100 * screenSize.height * 0.0012,
                                child: SfCartesianChart(
                                    isTransposed: true,
                                    primaryXAxis: CategoryAxis(),
                                    series: <ChartSeries>[
                                      BarSeries<SalesData, String>(
                                          dataSource: absentchartdata,
                                          xValueMapper: (SalesData sales, _) =>
                                              sales.year.toString(),
                                          yValueMapper: (SalesData sales, _) =>
                                              sales.sales)
                                    ]))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    color: Colors.white,
                    width: screenSize.width * 0.2,
                    height: screenSize.height * 0.15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Present today",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18 * screenSize.shortestSide * 0.0012),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "$totalpresent",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25 *
                                          screenSize.shortestSide *
                                          0.0012),
                                ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "${todaynewjoin}",
                                //       style: TextStyle(
                                //           color: lightred,
                                //           fontSize: 10 *
                                //               screenSize.shortestSide *
                                //               0.0012),
                                //     ),
                                //     Icon(
                                //       Icons.arrow_upward,
                                //       size:
                                //           10 * screenSize.shortestSide * 0.0012,
                                //     )
                                //   ],
                                // )
                              ],
                            ),
                            Container(
                                width: 200 * screenSize.width * 0.0007,
                                height: 100 * screenSize.height * 0.0012,
                                child: SfCartesianChart(
                                    isTransposed: true,
                                    primaryXAxis: CategoryAxis(),
                                    series: <ChartSeries>[
                                      BarSeries<SalesData, String>(
                                          dataSource: presentchartdata,
                                          xValueMapper: (SalesData sales, _) =>
                                              sales.year.toString(),
                                          yValueMapper: (SalesData sales, _) =>
                                              sales.sales)
                                    ]))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20 * screenSize.height * 0.0012,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                child: Padding(
                  padding:
                      EdgeInsets.all(15 * screenSize.shortestSide * 0.0012),
                  child: Container(
                    width: 270 * screenSize.width * 0.0007,
                    height: 35 * screenSize.height * 0.0012,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 220 * screenSize.width * 0.0007,
                          child: Text(
                            "Total Nummber of Members Joined",
                            style: TextStyle(
                              fontSize: 12 * screenSize.shortestSide * 0.0012,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30 * screenSize.width * 0.0007,
                          child: Text(
                            "$totaljoinedintimespan",
                            style: TextStyle(
                              fontSize: 20 * screenSize.shortestSide * 0.0012,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding:
                      EdgeInsets.all(15 * screenSize.shortestSide * 0.0012),
                  child: Container(
                    width: 270 * screenSize.width * 0.0007,
                    height: 35 * screenSize.height * 0.0012,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 220 * screenSize.width * 0.0007,
                          child: Text(
                            "Today new Joined",
                            style: TextStyle(
                              fontSize: 12 * screenSize.shortestSide * 0.0012,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30 * screenSize.width * 0.0007,
                          child: Text(
                            "${todaynewjoin}",
                            style: TextStyle(
                              fontSize: 20 * screenSize.shortestSide * 0.0012,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding:
                      EdgeInsets.all(15 * screenSize.shortestSide * 0.0012),
                  child: Container(
                    width: 270 * screenSize.width * 0.0007,
                    height: 35 * screenSize.height * 0.0012,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 220 * screenSize.width * 0.0007,
                          child: Text(
                            "Today new through refferal",
                            style: TextStyle(
                              fontSize: 12 * screenSize.shortestSide * 0.0012,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30 * screenSize.width * 0.0007,
                          child: Text(
                            "${todaynewthroughrefferal}",
                            style: TextStyle(
                              fontSize: 20 * screenSize.shortestSide * 0.0012,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Card(
          //   elevation: 3,
          //   child: Padding(
          //     padding: EdgeInsets.all(8.0 * screenSize.shortestSide * 0.0012),
          //     child: Column(
          //       children: [
          //         Row(
          //           mainAxisSize: MainAxisSize.max,
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text(
          //               "Statistics",
          //               style: TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 18 * screenSize.shortestSide * 0.0012),
          //             ),
          //             Card(
          //               elevation: 3,
          //               child: Container(
          //                 width: 150 * screenSize.width * 0.0007,
          //                 height: 40 * screenSize.height * 0.0012,
          //                 color: Colors.white,
          //                 child: Padding(
          //                   padding: EdgeInsets.all(
          //                       8.0 * screenSize.shortestSide * 0.0012),
          //                   child: Row(
          //                     children: [
          //                       SizedBox(
          //                         width: 90 * screenSize.width * 0.0007,
          //                         child: Text(
          //                           "Last 6 month",
          //                           style: TextStyle(
          //                               fontSize: 18 *
          //                                   screenSize.shortestSide *
          //                                   0.0012),
          //                         ),
          //                       ),
          //                       Icon(
          //                         Icons.arrow_drop_down,
          //                         size: 18 * screenSize.shortestSide * 0.0012,
          //                       )
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             )
          //           ],
          //         ),
          //         Container(
          //           child: SfCartesianChart(
          //               //  isTransposed: true,
          //               primaryXAxis: CategoryAxis(),
          //               series: <ChartSeries>[
          //                 SplineSeries<SalesData, String>(
          //                     dataSource: [
          //                       // Bind data source
          //                       SalesData('Jan', 35),
          //                       SalesData('Feb', 28),
          //                       SalesData('Mar', 34),
          //                       SalesData('Apr', 32),
          //                       SalesData('May', 40),
          //                       SalesData('June', 40)
          //                     ],
          //                     xValueMapper: (SalesData sales, _) => sales.year,
          //                     yValueMapper: (SalesData sales, _) => sales.sales,
          //                     markerSettings: MarkerSettings(isVisible: true)),
          //                 SplineSeries<SalesData, String>(
          //                     dataSource: [
          //                       // Bind data source
          //                       SalesData('Jan', 30),
          //                       SalesData('Feb', 40),
          //                       SalesData('Mar', 20),
          //                       SalesData('Apr', 50),
          //                       SalesData('May', 25),
          //                       SalesData('June', 35)
          //                     ],
          //                     xValueMapper: (SalesData sales, _) => sales.year,
          //                     yValueMapper: (SalesData sales, _) => sales.sales,
          //                     markerSettings: MarkerSettings(isVisible: true))
          //               ]),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 15 * screenSize.shortestSide * 0.0012,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Card(
                elevation: 3,
                child: Padding(
                  padding:
                      EdgeInsets.all(8.0 * screenSize.shortestSide * 0.0012),
                  child: SizedBox(
                    width: 650 * screenSize.width * 0.0007,
                    height: 800 * screenSize.height * 0.0012,
                    child: Padding(
                        padding: EdgeInsets.all(12 * sizefactor),
                        child: Column(children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "People Joined Through Refferal",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18 * sizefactor),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15 * sizefactor,
                          ),
                          Container(
                            color: Colors.grey[300],
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 150 * widthfactor,
                                  height: 50 * heightfactor,
                                  child: Center(
                                      child: Text(
                                    "Location",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18 * sizefactor),
                                  )),
                                ),
                                SizedBox(
                                  width: 150 * widthfactor,
                                  height: 50 * heightfactor,
                                  child: Center(
                                      child: Text(
                                    "Name",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18 * sizefactor),
                                  )),
                                ),
                                SizedBox(
                                  width: 150 * widthfactor,
                                  height: 50 * heightfactor,
                                  child: Center(
                                      child: Text(
                                    "Reffered by",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18 * sizefactor),
                                  )),
                                ),
                                SizedBox(
                                  width: 150 * widthfactor,
                                  height: 50 * heightfactor,
                                  child: Center(
                                      child: Text(
                                    "Code",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18 * sizefactor),
                                  )),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: 670 * heightfactor,
                              child: ListView.builder(
                                  itemCount: refferaljoinerlist.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(children: [
                                      Row(children: [
                                        SizedBox(
                                          width: 150 * widthfactor,
                                          height: 50 * heightfactor,
                                          child: Center(
                                              child: Text(
                                            "${refferaljoinerlist[index][0]}",
                                            style: TextStyle(
                                                fontSize: 18 * sizefactor),
                                            // style: TextStyle(
                                            //     fontWeight:
                                            //         FontWeight.bold),
                                          )),
                                        ),
                                        SizedBox(
                                          width: 150 * widthfactor,
                                          height: 50 * heightfactor,
                                          child: Center(
                                              child: Text(
                                            "${refferaljoinerlist[index][1]}",
                                            style: TextStyle(
                                                fontSize: 18 * sizefactor),
                                            // style: TextStyle(
                                            //     fontWeight:
                                            //         FontWeight.bold),
                                          )),
                                        ),
                                        SizedBox(
                                          width: 150 * widthfactor,
                                          height: 50 * heightfactor,
                                          child: Center(
                                              child: Text(
                                            "${refferaljoinerlist[index][2]}",
                                            style: TextStyle(
                                                fontSize: 18 * sizefactor),
                                            // style: TextStyle(
                                            //     fontWeight:
                                            //         FontWeight.bold),
                                          )),
                                        ),
                                        SizedBox(
                                          width: 150 * widthfactor,
                                          height: 50 * heightfactor,
                                          child: Center(
                                              child: Text(
                                            "${refferaljoinerlist[index][3]}",
                                            style: TextStyle(
                                                fontSize: 18 * sizefactor),
                                            // style: TextStyle(
                                            //     fontWeight:
                                            //         FontWeight.bold),
                                          )),
                                        )
                                      ])
                                    ]);
                                  })),
                        ])),
                  ),
                ),
              ),
              Card(
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(8.0 * sizefactor),
                  child: SizedBox(
                    width: 350 * widthfactor,
                    height: 800 * heightfactor,
                    child: Padding(
                      padding: EdgeInsets.all(12 * sizefactor),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 250 * widthfactor,
                                child: Text(
                                  "People Newly Joined",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18 * sizefactor),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15 * sizefactor,
                          ),
                          Container(
                            color: Colors.grey[300],
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 150 * widthfactor,
                                  height: 50 * heightfactor,
                                  child: Center(
                                      child: Text(
                                    "Location",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18 * sizefactor),
                                  )),
                                ),
                                SizedBox(
                                  width: 150 * widthfactor,
                                  height: 50 * heightfactor,
                                  child: Center(
                                      child: Text(
                                    "Name",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18 * sizefactor),
                                  )),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: 670 * heightfactor,
                              child: ListView.builder(
                                  itemCount: joinerlist.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Row(children: [
                                      SizedBox(
                                        width: 150 * widthfactor,
                                        height: 50 * heightfactor,
                                        child: Center(
                                            child: Text(
                                          "${joinerlist[index][0]}",
                                          style: TextStyle(
                                              fontSize: 18 * sizefactor),
                                          // style: TextStyle(
                                          //     fontWeight:
                                          //         FontWeight.bold),
                                        )),
                                      ),
                                      SizedBox(
                                        width: 150 * widthfactor,
                                        height: 50 * heightfactor,
                                        child: Center(
                                            child: Text(
                                                "${joinerlist[index][1]}",
                                                style: TextStyle(
                                                    fontSize: 18 * sizefactor)
                                                // style: TextStyle(
                                                //     fontWeight:
                                                //         FontWeight.bold),
                                                )),
                                      ),
                                      // SizedBox(
                                      //   width: 150,
                                      //   height: 50,
                                      //   child: Center(
                                      //       child: Text(
                                      //     "Name",
                                      //     // style: TextStyle(
                                      //     //     fontWeight:
                                      //     //         FontWeight.bold),
                                      //   )),
                                      // ),
                                      // SizedBox(
                                      //   width: 150,
                                      //   height: 50,
                                      //   child: Center(
                                      //       child: Text(
                                      //     "Name",
                                      //     // style: TextStyle(
                                      //     //     fontWeight:
                                      //     //         FontWeight.bold),
                                      //   )),
                                      // )
                                    ]);
                                  })),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final int year;
  final double? sales;
}
