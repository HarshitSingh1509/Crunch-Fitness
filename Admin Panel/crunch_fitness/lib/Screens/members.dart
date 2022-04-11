import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitness/Constants/colors.dart';
import 'package:crunch_fitness/Screens/addnewplantouser.dart';
import 'package:crunch_fitness/Widgets/buttonwidget.dart';
import 'package:crunch_fitness/Widgets/iconbuttonwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';

class Members extends StatefulWidget {
  Members({required this.id, required this.data});
  String id;
  dynamic data;
  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {
  int n = 0;
  DateTime selectedDate = DateTime.now();
  int attendancetype = 1;
  int selectedindex = 0;
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
  String img = "";
  DateTime selectedDate1 = DateTime.now();
  Future<void> getattendance() async {
    userattendance.clear();

    if (selectedDate.month == DateTime.now().month &&
        selectedDate.year == DateTime.now().year) {
      print("hereeeeeeeeeeeeee");
      setState(() {
        n = DateTime.now().day;
      });
    } else {
      setState(() {
        n = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
      });
    }

    try {
      for (int i = n; i >= 1; i--) {
        String path = "AppData/Attendance/UserAttendance/" +
            months[DateTime.now().month - 1].toString() +
            ',' +
            DateTime.now().year.toString() +
            "/$i/" +
            widget.id;

        DocumentSnapshot _collectionRef =
            await FirebaseFirestore.instance.doc(path).get();

        setState(() {
          _collectionRef.exists
              ? userattendance.add(_collectionRef.data())
              : userattendance.add({"name": "nodata"});
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getotherdata() async {
    userattendance.clear();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection('AppData/Topics/Other Activities');
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    setState(() {
      otheractivities = querySnapshot.docs.map((doc) => doc.data()).toList();
    });
    print(otheractivities);

    getotherattendance(otheractivities[0]["name"]);
  }

  Future<void> getotherattendance(String name) async {
    userattendance.clear();
    int n = 0;
    if (selectedDate.month == DateTime.now().month &&
        selectedDate.year == DateTime.now().year) {
      print("hereeeeeeeeeeeeee");
      setState(() {
        n = DateTime.now().day;
      });
    } else {
      setState(() {
        n = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
      });
    }

    try {
      for (int i = n; i >= 1; i--) {
        String path =
            "/AppData/Attendance/OtherActivities/$name/attendance/${months[DateTime.now().month - 1]},${DateTime.now().year}/$i/${widget.id}";

        print(path);
        DocumentSnapshot _collectionRef =
            await FirebaseFirestore.instance.doc(path).get();

        print(_collectionRef.exists);
        setState(() {
          _collectionRef.exists
              ? userattendance.add(_collectionRef.data())
              : userattendance.add({"name": "nodata"});
        });
      }
    } catch (e) {
      print(e);
    }
  }

  List<dynamic> otheractivities = [
    {"name": "Yoga"},
    {"name": "Yoga"},
    {"name": "Yoga"}
  ];
  List<dynamic> userattendance = [
    {
      "name": "Harshit",
      "status": true,
      "timeout": Timestamp(1000, 0),
      "timein": Timestamp(1000, 0)
    },
    {
      "name": "Harshit",
      "status": true,
      "timeout": Timestamp(1000, 0),
      "timein": Timestamp(1000, 0)
    },
    {
      "name": "Harshit",
      "status": true,
      "timeout": Timestamp(1000, 0),
      "timein": Timestamp(1000, 0)
    },
  ];
  // dynamic data ;
  //  Future<void> getuserdata() async {

  //   String uid = widget.id;
  //   String path = "Users/${uid}";
  //   DocumentSnapshot _collectionRef =
  //       await FirebaseFirestore.instance.doc(path).get();
  //   setState(() {
  //     if (_collectionRef.exists) {
  //       data = _collectionRef.data();
  //     }
  //   });

  // }

  List<String> topicid = [];
  List<dynamic> topicdata = [];
  List<dynamic> activitydata = [];
  List<String> activityid = [];

  Future<void> gettopicid() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection('/Users/${widget.id}/Subscription');
    await _collectionRef.get().then((value) async {
      setState(() {
        topicid = value.docs.map((doc) => doc.id).toList();
        topicdata = value.docs.map((doc) => doc.data()).toList();
      });
    });

    // Get data from docs and convert map to List

    print(topicdata);
  }

  Future<void> loadactivities() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection('/Users/${widget.id}/OtherActivities');
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List

    setState(() {
      activitydata = querySnapshot.docs.map((doc) => doc.data()).toList();
      activityid = querySnapshot.docs.map((doc) => doc.id).toList();
    });
    print(activitydata[0].toString());
  }

  dynamic data;
  @override
  void initState() {
    getattendance();
    gettopicid();
    loadactivities();
    data = widget.data;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var heightfactor = screenSize.height * 0.0012;
    var widthfactor = screenSize.width * 0.0007;
    var sizefactor = screenSize.shortestSide * 0.0012;
    return Scaffold(
        body: Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height - 50,
          child: SingleChildScrollView(
              child: Row(
            children: [
              SizedBox(
                width: screenSize.width * 0.15,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(data["imageurl"] ??
                          "https://firebasestorage.googleapis.com/v0/b/crunch-fitness-efeba.appspot.com/o/blank-profile-picture-973460_1280.png?alt=media&token=3442a53d-a890-4f36-9b59-0d90352544e7"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Profile is ${data["isactive"] ? "Active" : "Deactive"}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ButtonMethodWidget(() async {
                      String path = "Users/${widget.id}";

                      await FirebaseFirestore.instance.doc(path).set(
                          {"isactive": !data["isactive"]},
                          SetOptions(merge: true)).then((value) {
                        setState(() {
                          data["isactive"] = !data["isactive"];
                        });
                        //  data["isactive"] = !data["isactive"]
                      });
                    }, 50, 150,
                        "${data["isactive"] ? "Deactivate" : "Activate"}", 15),
                    SizedBox(
                      height: 20,
                    ),
                    //    Text("Member from 11/12/2022")
                  ],
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.30,
                child: Column(
                  children: [
                    ButtonMethodWidget(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => Plans(
                            id: widget.id,
                          ),
                        ),
                      );
                    }, 70, 150, " Add New Plan", 15),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: topicdata.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Expiry Date of Subscription is ${DateFormat.MMMMEEEEd().format((topicdata[index]["enddate"].toDate()))}",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  ButtonMethodWidget(() {
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime.now(),
                                        maxTime: DateTime.now()
                                            .add(Duration(days: 365)),
                                        onChanged: (date) {
                                      print('change $date');
                                    }, onConfirm: (date) async {
                                      setState(() {
                                        selectedindex = 0;
                                        selectedDate1 = date;
                                      });
                                      String path =
                                          "/Users/${widget.id}/Subscription/${topicid[index]}";

                                      await FirebaseFirestore.instance
                                          .doc(path)
                                          .set({
                                        "enddate":
                                            Timestamp.fromDate(selectedDate1)
                                      }, SetOptions(merge: true)).then((value) {
                                        setState(() {
                                          topicdata[index]["enddate"] =
                                              Timestamp.fromDate(selectedDate1);
                                        });
                                        //  data["isactive"] = !data["isactive"]
                                      });
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.en);
                                  }, 35, 80, "Extend", 15)
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Subscribed to ${topicid[index]}",
                                style: TextStyle(fontSize: 20, color: darkred),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                  height: 80,
                                  width: screenSize.width * 0.25,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${topicdata[index]["name"]}",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Rs ${topicdata[index]["price"]}/-",
                                                style: TextStyle(fontSize: 12),
                                              )
                                            ],
                                          ),
                                          ButtonMethodWidget(() async {
                                            String path =
                                                "/Users/${widget.id}/Subscription/${topicid[index]}";
                                            if (topicdata[index]["ishold"] !=
                                                null) {
                                              if (!topicdata[index]["ishold"] ||
                                                  topicdata[index]["ishold"] ==
                                                      null) {
                                                await FirebaseFirestore.instance
                                                    .doc(path)
                                                    .set(
                                                        {
                                                      "ishold": true,
                                                      "holddate":
                                                          Timestamp.fromDate(
                                                              DateTime.now())
                                                    },
                                                        SetOptions(
                                                            merge: true)).then(
                                                        (value) {
                                                  setState(() {
                                                    topicdata[index]["ishold"] =
                                                        true;
                                                  });
                                                });
                                              } else {
                                                await FirebaseFirestore.instance
                                                    .doc(path)
                                                    .set(
                                                        {
                                                      "ishold": false,
                                                      "enddate": Timestamp.fromDate(topicdata[
                                                              index]["enddate"]
                                                          .toDate()
                                                          .add(Duration(
                                                              minutes: (DateTime
                                                                      .now())
                                                                  .difference(DateTime.parse(topicdata[
                                                                              index]
                                                                          ["holddate"]
                                                                      .toDate()
                                                                      .toString()))
                                                                  .inMinutes)))
                                                    },
                                                        SetOptions(
                                                            merge: true)).then(
                                                        (value) {
                                                  gettopicid();
                                                  loadactivities();
                                                });
                                              }
                                            } else {
                                              await FirebaseFirestore.instance
                                                  .doc(path)
                                                  .set({
                                                "ishold": true,
                                                "holddate": Timestamp.fromDate(
                                                    DateTime.now())
                                              }, SetOptions(merge: true)).then(
                                                      (value) {
                                                setState(() {
                                                  topicdata[index]["ishold"] =
                                                      true;
                                                });
                                              });
                                            }
                                          },
                                              35,
                                              80,
                                              "${topicdata[index]["ishold"] == null || !topicdata[index]["ishold"] ? "Hold" : "UnHold"}",
                                              //   "Hold/Unhold",
                                              15)
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          );
                        }),
                    Text(
                      "Other Activities data",
                      style: TextStyle(fontSize: 18),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: activitydata.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Expiry Date of Subscription is ${DateFormat.MMMMEEEEd().format((activitydata[index]["enddate"].toDate()))}",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  ButtonMethodWidget(() {
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime.now(),
                                        maxTime: DateTime.now()
                                            .add(Duration(days: 365)),
                                        onChanged: (date) {
                                      print('change $date');
                                    }, onConfirm: (date) async {
                                      setState(() {
                                        selectedindex = 0;
                                        selectedDate1 = date;
                                      });
                                      String path =
                                          "/Users/${widget.id}/OtherActivities/${activityid[index]}";

                                      await FirebaseFirestore.instance
                                          .doc(path)
                                          .set({
                                        "enddate":
                                            Timestamp.fromDate(selectedDate1)
                                      }, SetOptions(merge: true)).then((value) {
                                        setState(() {
                                          activitydata[index]["enddate"] =
                                              Timestamp.fromDate(selectedDate1);
                                        });
                                        //  data["isactive"] = !data["isactive"]
                                      });
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.en);
                                  }, 35, 80, "Extend", 15)
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              // Text(
                              //   "Subscribed to ${activitydata[index]["name"]}",
                              //   style: TextStyle(fontSize: 20, color: darkred),
                              // ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                  height: 80,
                                  width: screenSize.width * 0.25,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${activitydata[index]["name"]}",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Rs ${activitydata[index]["price"]}/-",
                                                style: TextStyle(fontSize: 12),
                                              )
                                            ],
                                          ),
                                          ButtonMethodWidget(() async {
                                            String path =
                                                "/Users/${widget.id}/OtherActivities/${activityid[index]}";
                                            if (activitydata[index]["ishold"] !=
                                                null) {
                                              if (!activitydata[index]
                                                      ["ishold"] ||
                                                  activitydata[index]
                                                          ["ishold"] ==
                                                      null) {
                                                await FirebaseFirestore.instance
                                                    .doc(path)
                                                    .set(
                                                        {
                                                      "ishold": true,
                                                      "holddate":
                                                          Timestamp.fromDate(
                                                              DateTime.now())
                                                    },
                                                        SetOptions(
                                                            merge: true)).then(
                                                        (value) {
                                                  setState(() {
                                                    activitydata[index]
                                                        ["ishold"] = true;
                                                  });
                                                });
                                              } else {
                                                await FirebaseFirestore.instance
                                                    .doc(path)
                                                    .set(
                                                        {
                                                      "ishold": false,
                                                      "enddate": Timestamp.fromDate(activitydata[
                                                              index]["enddate"]
                                                          .toDate()
                                                          .add(Duration(
                                                              minutes: (DateTime
                                                                      .now())
                                                                  .difference(DateTime.parse(activitydata[
                                                                              index]
                                                                          ["holddate"]
                                                                      .toDate()
                                                                      .toString()))
                                                                  .inMinutes)))
                                                    },
                                                        SetOptions(
                                                            merge: true)).then(
                                                        (value) {
                                                  gettopicid();
                                                  loadactivities();
                                                });
                                              }
                                            } else {
                                              await FirebaseFirestore.instance
                                                  .doc(path)
                                                  .set({
                                                "ishold": true,
                                                "holddate": Timestamp.fromDate(
                                                    DateTime.now())
                                              }, SetOptions(merge: true)).then(
                                                      (value) {
                                                setState(() {
                                                  activitydata[index]
                                                      ["ishold"] = true;
                                                });
                                              });
                                            }
                                          },
                                              35,
                                              80,
                                              "${activitydata[index]["ishold"] == null || !activitydata[index]["ishold"] ? "Hold" : "UnHold"}",
                                              15)
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          );
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "UserName - ${widget.data["name"]}",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Email Id - ${widget.data["email"]}",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Mobile Number - ${widget.data["number"]}",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Refferal Code - ${widget.data["invite"]}",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              )
            ],
          )),
        ),
        Container(
            height: MediaQuery.of(context).size.height - 50,
            child: VerticalDivider(color: Colors.red)),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.48,
          height: MediaQuery.of(context).size.height - 50,
          child: SingleChildScrollView(
            child: attendancetype == 1
                ? Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showMonthPicker(
                                  context: context,
                                  firstDate:
                                      DateTime(DateTime.now().year - 1, 5),
                                  lastDate: DateTime(DateTime.now().year,
                                      DateTime.now().month),
                                  initialDate: selectedDate,
                                  locale: Locale("en"),
                                ).then((date) {
                                  if (date != null) {
                                    setState(() {
                                      selectedDate = date;
                                    });
                                    getattendance();
                                    // getotherdata();
                                  }
                                });
                              },
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(months[selectedDate.month - 1]
                                            .toString() +
                                        ',' +
                                        selectedDate.year.toString()),
                                    // ImageIcon(
                                    //   AssetImage(
                                    //       "assets/vuesax-linear-note-6@2x.png"),
                                    //   size: 20,
                                    // )
                                  ],
                                ),
                                height: 30,
                                width: 90,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  attendancetype = 2;
                                });
                                getotherdata();
                                //    getotherattendance();
                              },
                              child: Text(
                                "Other Activities Attendance",
                                style: TextStyle(
                                  color: lightred,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )
                          ],
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
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: screenSize.width * 0.40,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            top: 15,
                                            bottom: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              (n - (index)).toString(),
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            Row(
                                              children: [
                                                Text("Status -"),
                                                Text(
                                                  userattendance[index]
                                                              ["name"] ==
                                                          "nodata"
                                                      ? "Absent"
                                                      : (userattendance[index]
                                                              ["status"])
                                                          ? "Present"
                                                          : "Absent",
                                                  style: TextStyle(
                                                      color: userattendance[
                                                                      index]
                                                                  ["name"] ==
                                                              "nodata"
                                                          ? Colors.yellow
                                                          : (userattendance[
                                                                      index]
                                                                  ["status"])
                                                              ? darkred
                                                              : darkred),
                                                ),
                                              ],
                                            ),
                                            Text(
                                                "In Time - ${userattendance[index]["name"] == "nodata" ? "Unavilable" : DateFormat.Hm().format((userattendance[index]["timein"].toDate()))}",
                                                style: TextStyle(fontSize: 12)),
                                            Text(
                                                "Out Time - ${userattendance[index]["name"] == "nodata" || userattendance[index]["timeout"] == null ? "Unavilable" : DateFormat.Hm().format((userattendance[index]["timeout"].toDate()))}",
                                                style: TextStyle(fontSize: 12))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  icobbuttonWidget(
                                      () {},
                                      25,
                                      Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 20,
                                      ))
                                ],
                              ),
                            );
                          }),
                    ],
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: GestureDetector(
                                onTap: () {
                                  showMonthPicker(
                                    context: context,
                                    firstDate:
                                        DateTime(DateTime.now().year - 1, 5),
                                    lastDate:
                                        DateTime(DateTime.now().year + 1, 9),
                                    initialDate: selectedDate,
                                    locale: Locale("en"),
                                  ).then((date) {
                                    if (date != null) {
                                      setState(() {
                                        selectedDate = date;
                                      });
                                      getotherdata();
                                    }
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(months[selectedDate.month - 1]
                                            .toString() +
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
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  attendancetype = 1;
                                  getattendance();
                                });
                              },
                              child: Text(
                                "Attendance",
                                style: TextStyle(
                                  color: lightred,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )
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
                                      getotherattendance(
                                          otheractivities[selectedindex]
                                              ["name"]);
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
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: SizedBox(
                                  width: screenSize.width * 0.48,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: screenSize.width * 0.40,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5,
                                                right: 5,
                                                top: 15,
                                                bottom: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  (n - (index)).toString(),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Status -"),
                                                    Text(
                                                      userattendance[index]
                                                                  ["name"] ==
                                                              "nodata"
                                                          ? "Absent"
                                                          : (userattendance[
                                                                      index]
                                                                  ["status"])
                                                              ? "Present"
                                                              : "Absent",
                                                      style: TextStyle(
                                                          color: userattendance[
                                                                          index]
                                                                      [
                                                                      "name"] ==
                                                                  "nodata"
                                                              ? Colors.yellow
                                                              : (userattendance[
                                                                          index]
                                                                      [
                                                                      "status"])
                                                                  ? darkred
                                                                  : darkred),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                    "In Time - ${userattendance[index]["name"] == "nodata" ? "Unavilable" : DateFormat.Hm().format(userattendance[index]["timein"].toDate())}",
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                                Text(
                                                    "Out Time - ${userattendance[index]["name"] == "nodata" || userattendance[index]["timeout"] == null ? "Unavilable" : DateFormat.Hm().format((userattendance[index]["timeout"].toDate()))}",
                                                    style:
                                                        TextStyle(fontSize: 12))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      icobbuttonWidget(
                                          () {},
                                          25,
                                          Icon(
                                            Icons.edit,
                                            size: 20,
                                            color: Colors.white,
                                          ))
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
    ));
  }
}
