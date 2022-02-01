import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class MarkTAttendance extends StatefulWidget {
  MarkTAttendance({required this.data});
  Map<String, dynamic> data;

  @override
  _MarkTAttendanceState createState() => _MarkTAttendanceState();
}

class _MarkTAttendanceState extends State<MarkTAttendance> {
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
  bool loading = true;
  bool inatt = true;
  Future<void> checkdocandsetting(Map<String, dynamic> dat) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    int day = DateTime.now().day;
    String month = months[DateTime.now().month - 1].toString() +
        ',' +
        DateTime.now().year.toString();

    CollectionReference users = FirebaseFirestore.instance
        .collection('/AppData/Attendance/TrainerAttendance/');
    DocumentSnapshot doc = await users
        .doc(months[DateTime.now().month - 1].toString() +
            ',' +
            DateTime.now().year.toString())
        .get();

    if (doc.exists) {
      attendancemarking('/AppData/Attendance/TrainerAttendance//', '');
    } else {
      users.doc(month).set({"name": month});
      attendancemarking('/AppData/Attendance/TrainerAttendance/', '');
    }

    // .update({'name': name, 'email': email, 'number': number})
    // .then((value) => print("User Added"))
    // .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> attendancemarking(String path, String id) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    int day = DateTime.now().day;
    String month = months[DateTime.now().month - 1].toString() +
        ',' +
        DateTime.now().year.toString();
    CollectionReference newusers =
        FirebaseFirestore.instance.collection('$path$month/$day');
    newusers.doc(uid).get().then((value) {
      if (value.exists) {
        newusers.doc(uid).set({"timeout": Timestamp.fromDate(DateTime.now())},
            SetOptions(merge: true));
        setState(() {
          inatt = false;
        });
      } else {
        newusers.doc(uid).set({
          "name": GetStorage().read('name'),
          "status": true,
          "timein": Timestamp.fromDate(DateTime.now())
        }, SetOptions(merge: true)).then((value) {
          setState(() {
            inatt = true;
          });
          CollectionReference _collectionRef1 = FirebaseFirestore.instance
              .collection('/Trainer/$uid/Notification');

          _collectionRef1.add({
            'body': "You have been marked present${id}",
            'head': "Attendance",
            'isseen': false,
            'time': Timestamp.fromDate(DateTime.now())
          });
        });
      }
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // var dat = json.decode(widget.data);
    //print(dat['isother']);
    checkdocandsetting(widget.data);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: Container(
                height: 50, width: 50, child: CircularProgressIndicator()))
        : Scaffold(
            body: Center(
              child: Text(
                  "You have Succefully ${inatt ? "entered in" : "exited from"} Studio ${widget.data["isother"] ? "for ${widget.data["id"]}" : ""}"),
            ),
          );
  }
}
