import 'dart:convert';

import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitnes/Constants/colors.dart';
import 'package:crunch_fitnes/Screens/markattendance.dart';
import 'package:crunch_fitnes/Screens/notification.dart';
import 'package:crunch_fitnes/Screens/trainermarkattend.dart';
import 'package:crunch_fitnes/Screens/trainernotification.dart';
import 'package:crunch_fitnes/Screens/trainerprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';

class TrainerAttendance extends StatefulWidget {
  const TrainerAttendance({Key? key}) : super(key: key);

  @override
  _TrainerAttendanceState createState() => _TrainerAttendanceState();
}

class _TrainerAttendanceState extends State<TrainerAttendance> {
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
    addnewuser();
    // TODO: implement initState
    super.initState();
  }

  Future<void> addnewuser() async {
    print("*************************");
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    String path = "Trainer/${uid}";
    DocumentSnapshot _collectionRef =
        await FirebaseFirestore.instance.doc(path).get();
    dynamic data = _collectionRef.data();
    print(data["imageurl"]);
    final box = GetStorage();
    setState(() {
      img;
    });
    box.write('profileimg', data["imageurl"] ?? profile);
    box.write('name', data["name"]);
    box.write('user', "0");
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
        String path = "AppData/Attendance/TrainerAttendance/" +
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

  String qrCodeResult = "Some Text";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        icon: Icon(Icons.camera),
        onPressed: () async {
          print(jsonEncode({"id": "somerandom", "isother": false}));
          String codeSanner = await BarcodeScanner.scan(); //barcode scanner
          var data;
          setState(() {
            qrCodeResult = codeSanner;
            data = jsonDecode(qrCodeResult);
          });
          Navigator.pop(
              context,
              MaterialPageRoute(
                  builder: (context) => MarkTAttendance(data: data)));
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 15,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                    image: AssetImage("assets/crunch_name.png"),
                    height: 35,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      TrainerNotification()),
                            );
                          },
                          child: ImageIcon(
                              AssetImage("assets/notification-6@2x.png"))),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const TrainerProfile(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(img),
                        ),
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
                  Text(
                    "Attendance",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      showMonthPicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 1, 5),
                        lastDate:
                            DateTime(DateTime.now().year, DateTime.now().month),
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
                            AssetImage("assets/vuesax-linear-note-6@2x.png"),
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
                ],
              ),
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: userattendance.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 15, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              (n - (index)).toString(),
                              style: TextStyle(fontSize: 12),
                            ),
                            Row(
                              children: [
                                Text("Status -"),
                                Text(
                                  userattendance[index]["name"] == "nodata"
                                      ? "Absent"
                                      : (userattendance[index]["status"])
                                          ? "Present"
                                          : "Absent",
                                  style: TextStyle(
                                      color: userattendance[index]["name"] ==
                                              "nodata"
                                          ? Colors.yellow
                                          : (userattendance[index]["status"])
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
        ),
      ),
    );
  }
}
