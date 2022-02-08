import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitness/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  int totalpresentuser = 0;
  int totalpresentstaff = 0;
  int totalabsentuser = 0;
  int totalabsentstaff = 0;
  List<dynamic> staffattendance = [];
  Future<void> absenttodayfuncuser() async {
    print(
        '/AppData/Attendance/UserAttendance/${months[selectedDate.month - 1]},${selectedDate.year}/${selectedDate.day}/');
    userattendance = [];
    totalabsentuser = 0;
    totalpresentuser = 0;
    double sum = 0;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('/Users');
    //   '/AppData/Attendance/UserAttendance/${months[today.month]},${today.year}/${today.day}');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    querySnapshot.docs.forEach((element1) async {
      DocumentSnapshot qu = await FirebaseFirestore.instance
          .doc(
              '/AppData/Attendance/UserAttendance/${months[selectedDate.month - 1]},${selectedDate.year}/${selectedDate.day}/${element1.id}')
          .get();

      if (qu.exists != true) {
        setState(() {
          totalabsentuser = totalabsentuser + 1;
          userattendance.add({"name": element1["name"], "status": "nodata"});
        });
      } else if (qu["status"] == true) {
        setState(() {
          totalpresentuser = totalpresentuser + 1;
          userattendance.add(qu);
        });
      }
      ;
    });
  }

  Future<void> getactivityattendance(String id) async {
    userattendance = [];
    totalabsentuser = 0;
    totalpresentuser = 0;
    double sum = 0;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('/Users');
    //   '/AppData/Attendance/UserAttendance/${months[today.month]},${today.year}/${today.day}');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    querySnapshot.docs.forEach((element1) async {
      DocumentSnapshot qu = await FirebaseFirestore.instance
          .doc(
              '/AppData/Attendance/OtherActivities/$id/attendance${months[selectedDate.month - 1]}.${selectedDate.year}/${selectedDate.day}/${element1.id}')
          .get();

      if (qu.exists != true) {
        setState(() {
          totalabsentuser = totalabsentuser + 1;
          userattendance.add({"name": element1["name"], "status": "nodata"});
        });
      } else if (qu["status"] == true) {
        setState(() {
          totalpresentuser = totalpresentuser + 1;
          userattendance.add(qu.data());
        });
      }
      ;
    });
  }

  List<dynamic> activitydata = [
    {"name": "Main Attendance"}
  ];
  List<String> activityid = [""];
  Future<void> loadactivities() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection('/AppData/Topics/Other Activities');
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List

    setState(() {
      print(querySnapshot.docs.map((doc) => doc.data()).toList());
      otheractivities
          .addAll(querySnapshot.docs.map((doc) => doc.data()).toList());
      activityid.addAll(querySnapshot.docs.map((doc) => doc.id).toList());
    });
    print(activitydata);
  }

  Future<void> absenttodayfuncstaff() async {
    totalabsentstaff = 0;
    totalpresentstaff = 0;
    staffattendance = [];
    double sum = 0;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('/Trainer');
    //   '/AppData/Attendance/UserAttendance/${months[today.month]},${today.year}/${today.day}');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    querySnapshot.docs.forEach((element1) async {
      DocumentSnapshot qu = await FirebaseFirestore.instance
          .doc(
              '/AppData/Attendance/TrainerAttendance/${months[selectedDate1.month - 1]},${selectedDate1.year}/${selectedDate1.day}/${element1.id}')
          .get();

      if (qu.exists != true) {
        setState(() {
          totalabsentstaff = totalabsentstaff + 1;
          staffattendance.add({"name": element1["name"], "status": "nodata"});
        });
      } else if (qu["status"] == true) {
        setState(() {
          totalpresentstaff = totalpresentstaff + 1;
          staffattendance.add(qu.data());
        });
      }
      print(staffattendance);
      ;
    });
  }

  List<dynamic> trainersearch = [];
  List<dynamic> usersearch = [];
  int selectedindex = 0;
  List<dynamic> otheractivities = [
    {"name": "Main Attendance"}
  ];
  List<dynamic> userattendance = [];
  int n = 0;
  bool issearch = false;
  DateTime selectedDate = DateTime.now();
  DateTime selectedDate1 = DateTime.now();
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
  Future<void> userattendancefunc() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection(
        "/AppData/Attendance/UserAttendance/${months[selectedDate.month - 1]}.${selectedDate.year}/${selectedDate.day}");
    //   '/AppData/Attendance/UserAttendance/${months[selectedDate.month - 1]},${selectedDate.year}/${selectedDate.day}');
    await _collectionRef.get().then((value) async {
      setState(() {
        userattendance = value.docs.map((doc) => doc.data()).toList();
        print(userattendance);
        // alltopics = value.docs.map((doc) => doc.data()).toList();
      });
    });
  }

  @override
  void initState() {
    // userattendancefunc();
    absenttodayfuncstaff();
    absenttodayfuncuser();
    loadactivities();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height - 50,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "User/Member",
                        style: TextStyle(fontSize: 20, color: lightred),
                      ),
                      Text(
                        "Present - $totalpresentuser   Absent - $totalabsentuser",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2018, 3, 5),
                                maxTime: DateTime.now(), onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                              setState(() {
                                selectedindex = 0;
                                selectedDate = date;
                              });
                              absenttodayfuncuser();
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(selectedDate.day.toString() +
                                  " " +
                                  months[selectedDate.month - 1].toString() +
                                  ',' +
                                  selectedDate.year.toString()),
                              // ImageIcon(
                              //   AssetImage(
                              //       "assets/vuesax-linear-note-6@2x.png"),
                              //   size: 20,
                              // )
                            ],
                          ),
                        ),
                        height: 30,
                        width: 90,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      SizedBox(
                          width: 250,
                          height: 50,
                          child: Card(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(hintText: "Search for User"),
                              onTap: (() {
                                usersearch = userattendance;
                                issearch = !issearch;
                                print(issearch);
                              }),
                              onChanged: ((value) {
                                setState(() {
                                  userattendance = usersearch
                                      .where((element) => element["name"]
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();
                                });
                              }),
                            ),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: ListView.builder(
                        //  physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: otheractivities.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedindex = index;
                                if (index == 0) {
                                  absenttodayfuncuser();
                                } else {
                                  print(activityid[index]);
                                  getactivityattendance(
                                      otheractivities[index]["name"]);
                                }
                                // getotherattendance(
                                //     otheractivities[selectedindex]["name"]);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Column(children: [
                                Text(otheractivities[index]["name"]),
                                SizedBox(
                                  height: 5,
                                ),
                                (selectedindex == index)
                                    ? Container(
                                        height: 5,
                                        width: 50,
                                        color: darkred,
                                      )
                                    : Container()
                              ]),
                            ),
                          );
                        }),
                  ),
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: userattendance.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 15),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, top: 15, bottom: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userattendance[index]["name"]),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      ((index) + 1).toString(),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Row(
                                      children: [
                                        Text("Status -"),
                                        Text(
                                          userattendance[index]["status"] ==
                                                  "nodata"
                                              ? "Absent"
                                              : (userattendance[index]
                                                      ["status"])
                                                  ? "Present"
                                                  : "Absent",
                                          style: TextStyle(
                                              color: userattendance[index]
                                                          ["status"] ==
                                                      "nodata"
                                                  ? Colors.yellow
                                                  : (userattendance[index]
                                                          ["status"])
                                                      ? darkred
                                                      : darkred),
                                        ),
                                      ],
                                    ),
                                    Text(
                                        "In Time - ${userattendance[index]["status"] == "nodata" ? "Unavilable" : DateFormat.Hm().format(userattendance[index]["timein"].toDate())}",
                                        style: TextStyle(fontSize: 12)),
                                    Text(
                                        "Out Time - ${userattendance[index]["status"] == "nodata" || userattendance[index]["timeout"] == null ? "Unavilable" : DateFormat.Hm().format((userattendance[index]["timeout"].toDate()))}",
                                        style: TextStyle(fontSize: 12))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
        Container(
            height: MediaQuery.of(context).size.height - 50,
            child: VerticalDivider(color: Colors.red)),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.48,
          height: MediaQuery.of(context).size.height - 50,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Staff/trainer",
                        style: TextStyle(fontSize: 20, color: lightred),
                      ),
                      Text(
                        "Present - $totalpresentstaff   Absent - $totalabsentstaff",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2018, 3, 5),
                                maxTime: DateTime.now(), onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                              setState(() {
                                selectedDate1 = date;
                              });
                              absenttodayfuncstaff();
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(selectedDate1.day.toString() +
                                  " " +
                                  months[selectedDate1.month - 1].toString() +
                                  ',' +
                                  selectedDate1.year.toString()),
                              // ImageIcon(
                              //   AssetImage(
                              //       "assets/vuesax-linear-note-6@2x.png"),
                              //   size: 20,
                              // )
                            ],
                          ),
                        ),
                        height: 30,
                        width: 90,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      SizedBox(
                          width: 250,
                          height: 50,
                          child: Card(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Search for Trainer"),
                              onTap: (() {
                                trainersearch = staffattendance;
                                issearch = !issearch;
                                print(issearch);
                              }),
                              onChanged: ((value) {
                                setState(() {
                                  staffattendance = trainersearch
                                      .where((element) => element["name"]
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();
                                });
                              }),
                            ),
                          ))
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 50,
                //   child: Padding(
                //     padding: const EdgeInsets.all(5),
                //     child: ListView.builder(
                //         //  physics: NeverScrollableScrollPhysics(),
                //         scrollDirection: Axis.horizontal,
                //         shrinkWrap: true,
                //         itemCount: otheractivities.length,
                //         itemBuilder: (BuildContext context, int index) {
                //           return GestureDetector(
                //             onTap: () {
                //               setState(() {
                //                 selectedindex = index;
                //                 // getotherattendance(
                //                 //     otheractivities[selectedindex]["name"]);
                //               });
                //             },
                //             child: Padding(
                //               padding: const EdgeInsets.all(5),
                //               child: Column(children: [
                //                 Text(otheractivities[index]["name"]),
                //                 SizedBox(
                //                   height: 5,
                //                 ),
                //                 (selectedindex == index)
                //                     ? Container(
                //                         height: 5,
                //                         width: 50,
                //                         color: darkred,
                //                       )
                //                     : Container()
                //               ]),
                //             ),
                //           );
                //         }),
                //   ),
                // ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: staffattendance.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 15),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, top: 15, bottom: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${staffattendance[index]["name"]}"),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      ((index + 1)).toString(),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Row(
                                      children: [
                                        Text("Status -"),
                                        Text(
                                          staffattendance[index]["status"] ==
                                                  "nodata"
                                              ? "Absent"
                                              : (staffattendance[index]
                                                      ["status"])
                                                  ? "Present"
                                                  : "Absent",
                                          style: TextStyle(
                                              color: staffattendance[index]
                                                          ["status"] ==
                                                      "nodata"
                                                  ? Colors.yellow
                                                  : (staffattendance[index]
                                                          ["status"])
                                                      ? darkred
                                                      : darkred),
                                        ),
                                      ],
                                    ),
                                    Text(
                                        "In Time - ${staffattendance[index]["status"] == "nodata" ? "Unavilable" : DateFormat.Hm().format(staffattendance[index]["timein"].toDate())}",
                                        style: TextStyle(fontSize: 12)),
                                    Text(
                                        "Out Time - ${staffattendance[index]["status"] == "nodata" || staffattendance[index]["timeout"] == null ? "Unavilable" : DateFormat.Hm().format((staffattendance[index]["timeout"].toDate()))}",
                                        style: TextStyle(fontSize: 12))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
