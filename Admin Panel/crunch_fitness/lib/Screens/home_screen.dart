import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitness/Constants/colors.dart';
import 'package:crunch_fitness/Screens/abouttheapp.dart';
import 'package:crunch_fitness/Screens/admin.dart';
import 'package:crunch_fitness/Screens/attendance.dart';
import 'package:crunch_fitness/Screens/bannersandssession.dart';
import 'package:crunch_fitness/Screens/home.dart';
import 'package:crunch_fitness/Screens/memberlist.dart';
import 'package:crunch_fitness/Screens/membership.dart';
import 'package:crunch_fitness/Screens/messages.dart';
import 'package:crunch_fitness/Screens/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  // initState() {
  //   print(FirebaseAuth.instance.currentUser!.email);
  //   super.initState();
  // }

  List<String> tabs = [
    "Home",
    "Banners&Sessions",
    "Membership",
    "Attendance",
    "Members List",
    "Notification",
    "Messages",
  ];
  List<Widget> tabscreens = [
    Home(),
    BannersAndSessions(),
    Membership(),
    Attendance(),
    MemberList(),
    NotificationSend(),
    Messages(),
  ];

  int selectedindex = 0;
  String img = "";
  String name = "";
  Future<void> getadminprofile() async {
    var doc = await FirebaseFirestore.instance.doc("/AppData/Admin").get();
    setState(() {
      img = doc.get("imageurl");
      name = doc.get("name");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getadminprofile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SizedBox(
            height: screenSize.height * 0.07,
            child: Padding(
              padding: EdgeInsets.all(5 * screenSize.shortestSide * 0.0012),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Image(
                      image: AssetImage("assets/Crunch 1@2x.png"),
                      width: screenSize.width * 0.2,
                    ),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),

                        //  physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: tabs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  selectedindex = index;
                                },
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(
                                  5 * screenSize.shortestSide * 0.0012),
                              child: Column(children: [
                                Text(
                                  tabs[index],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18 *
                                          screenSize.shortestSide *
                                          0.0012),
                                ),
                                SizedBox(
                                  height: 5 * screenSize.shortestSide * 0.0012,
                                ),
                                (selectedindex == index)
                                    ? Container(
                                        height: 5 * screenSize.height * 0.0012,
                                        width: 50 * screenSize.width * 0.0007,
                                        color: darkred,
                                      )
                                    : Container()
                              ]),
                            ),
                          );
                        }),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  AdminPage(img: img, name: name),
                            ),
                          );
                        },
                        child: CircleAvatar(
                            radius: 25, backgroundImage: NetworkImage(img)))
                  ],
                ),
              ),
            ),
          ),
          tabscreens[selectedindex]
        ],
      ),
    ));
  }
}
