import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitness/Constants/colors.dart';
import 'package:crunch_fitness/Widgets/buttonwidget.dart';
import 'package:crunch_fitness/Widgets/iconbuttonwidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class TrainerProfile extends StatefulWidget {
  TrainerProfile({required this.id, required this.data});
  String id;
  dynamic data;
  @override
  _TrainerProfileState createState() => _TrainerProfileState();
}

class _TrainerProfileState extends State<TrainerProfile> {
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

  List<dynamic> otheractivities = [
    {"name": "Yoga"},
    {"name": "Yoga"},
    {"name": "Yoga"}
  ];
  List<dynamic> userattendance = [];
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

  @override
  void initState() {
    getattendance();
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
              child: SizedBox(
            width: screenSize.width * 0.30,
            child: Column(
              children: [
                CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.data["imageurl"] ??
                        "https://firebasestorage.googleapis.com/v0/b/crunch-fitness-efeba.appspot.com/o/blank-profile-picture-973460_1280.png?alt=media&token=3442a53d-a890-4f36-9b59-0d90352544e7")),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Profile is ${widget.data["isactive"] ? "Active" : "Deactive"}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                ButtonMethodWidget(() {}, 50, 150, "Deactivate", 15),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "UserName -${widget.data["name"]}",
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
                // Text(
                //   "Refferal Code - dggggggggghghfh",
                //   style: TextStyle(fontSize: 18),
                // ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          )),
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
                    // GestureDetector(
                    //   onTap: () {
                    //     setState(() {
                    //       attendancetype = 2;
                    //     });
                    //     //       getotherdata();
                    //     //    getotherattendance();
                    //   },
                    //   child: Text(
                    //     "Other Activities Attendance",
                    //     style: TextStyle(
                    //       color: lightred,
                    //       decoration: TextDecoration.underline,
                    //     ),
                    //   ),
                    // )
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
                                              : (userattendance[index]
                                                      ["status"])
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
          )),
        ),
      ],
    ));
  }
}
