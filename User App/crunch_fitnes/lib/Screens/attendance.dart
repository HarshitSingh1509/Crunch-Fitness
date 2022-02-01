import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitnes/Constants/colors.dart';
import 'package:crunch_fitnes/Screens/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  int n = 0;
  DateTime selectedDate = DateTime.now();
  int attendancetype = 1;
  int selectedindex = 0;
  List<dynamic> userattendance = [];
  List<dynamic> otheractivities = [];
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
  @override
  void initState() {
    img = GetStorage().read('profileimg');
    print(img);
    getattendance();
    // TODO: implement initState
    super.initState();
  }

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
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      for (int i = n; i >= 1; i--) {
        String path = "AppData/Attendance/UserAttendance/" +
            months[DateTime.now().month - 1].toString() +
            ',' +
            DateTime.now().year.toString() +
            "/$i/" +
            auth.currentUser!.uid.toString();

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
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      for (int i = n; i >= 1; i--) {
        String path =
            "/AppData/Attendance/OtherActivities/$name/attendance/${months[DateTime.now().month - 1]},${DateTime.now().year}/$i/${auth.currentUser!.uid.toString()}";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: attendancetype == 1
            ? Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 8, right: 8, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Card(
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.arrow_back_ios),
                            ),
                          ),
                        ),
                        Text(
                          "Attendance",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: ImageIcon(
                                  AssetImage("assets/notification-6@2x.png")),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        Notifications(),
                                  ),
                                );
                              },
                            ),
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  GetStorage().read('profileimg') ?? ""),
                            )
                          ],
                        )
                      ],
                    ),
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
                              firstDate: DateTime(DateTime.now().year - 1, 5),
                              lastDate: DateTime(
                                  DateTime.now().year, DateTime.now().month),
                              initialDate: selectedDate,
                              locale: Locale("en"),
                            ).then((date) {
                              if (date != null) {
                                setState(() {
                                  selectedDate = date;
                                });
                                getattendance();
                              }
                            });
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(months[selectedDate.month - 1].toString() +
                                    ',' +
                                    selectedDate.year.toString()),
                                ImageIcon(
                                  AssetImage(
                                      "assets/vuesax-linear-note-6@2x.png"),
                                  size: 20,
                                )
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
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, top: 15, bottom: 15),
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
                                        userattendance[index]["name"] ==
                                                "nodata"
                                            ? "Absent"
                                            : (userattendance[index]["status"])
                                                ? "Present"
                                                : "Absent",
                                        style: TextStyle(
                                            color: userattendance[index]
                                                        ["name"] ==
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
                                      "In Time - ${userattendance[index]["name"] == "nodata" ? "Unavilable" : DateFormat.Hm().format((userattendance[index]["timein"].toDate()))}",
                                      style: TextStyle(fontSize: 12)),
                                  Text(
                                      "Out Time - ${userattendance[index]["name"] == "nodata" || userattendance[index]["timeout"] == null ? "Unavilable" : DateFormat.Hm().format((userattendance[index]["timeout"].toDate()))}",
                                      style: TextStyle(fontSize: 12))
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ],
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 8, right: 8, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.arrow_back_ios),
                          ),
                        ),
                        Text(
                          "Attendance",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        Row(
                          children: [
                            ImageIcon(
                                AssetImage("assets/notification-6@2x.png")),
                            SizedBox(
                              width: 15,
                            ),
                            CircleAvatar()
                          ],
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
                              showMonthPicker(
                                context: context,
                                firstDate: DateTime(DateTime.now().year - 1, 5),
                                lastDate: DateTime(DateTime.now().year + 1, 9),
                                initialDate: selectedDate,
                                locale: Locale("en"),
                              ).then((date) {
                                if (date != null) {
                                  setState(() {
                                    selectedDate = date;
                                  });
                                }
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(months[DateTime.now().month - 1]
                                        .toString() +
                                    ',' +
                                    DateTime.now().year.toString()),
                                ImageIcon(
                                  AssetImage(
                                      "assets/vuesax-linear-note-6@2x.png"),
                                  size: 20,
                                )
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
                                      otheractivities[selectedindex]["name"]);
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
                                        userattendance[index]["name"] ==
                                                "nodata"
                                            ? "Absent"
                                            : (userattendance[index]["status"])
                                                ? "Present"
                                                : "Absent",
                                        style: TextStyle(
                                            color: userattendance[index]
                                                        ["name"] ==
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
                                      "In Time - ${userattendance[index]["name"] == "nodata" ? "Unavilable" : DateFormat.Hm().format(userattendance[index]["timein"].toDate())}",
                                      style: TextStyle(fontSize: 12)),
                                  Text(
                                      "Out Time - ${userattendance[index]["name"] == "nodata" || userattendance[index]["timeout"] == null ? "Unavilable" : DateFormat.Hm().format((userattendance[index]["timeout"].toDate()))}",
                                      style: TextStyle(fontSize: 12))
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ],
              ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
}
