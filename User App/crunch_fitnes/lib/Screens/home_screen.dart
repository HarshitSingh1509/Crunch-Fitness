import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitnes/Constants/colors.dart';
import 'package:crunch_fitnes/Screens/attendance.dart';
import 'package:crunch_fitnes/Screens/mainscreen.dart';
import 'package:crunch_fitnes/Screens/others.dart';
import 'package:crunch_fitnes/Screens/plans.dart';
import 'package:crunch_fitnes/Screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatefulWidget {
  HomePage({required this.index});
  int index;
  @override
  _HomePageState createState() => _HomePageState();
}

Future<void> updatetoken() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid;
  String? token = await FirebaseMessaging.instance.getToken();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  print("token updated");
  users.doc(auth.currentUser!.uid).set(
      {'token': await FirebaseMessaging.instance.getToken()},
      SetOptions(merge: true));
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    updatetoken();
    // TODO: implement initState
    super.initState();
  }

  final pages = [
    const MainScreen(),
    const Attendance(),
    const Plans(),
    const Others(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffC4DFCB),
      // appBar: AppBar(
      //   // leadingWidth: 350,
      //   leading: Text(
      //     "Crunch The fitness Studio",
      //     style: TextStyle(
      //       color: Theme.of(context).primaryColor,
      //       fontSize: 25,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      //   actions: [
      //     Icon(
      //       Icons.notifications,
      //       color: Colors.black,
      //     ),
      //     SizedBox(
      //       width: 20,
      //     ),
      //     Icon(
      //       Icons.people,
      //       color: Colors.black,
      //     )
      //   ],
      //   centerTitle: false,
      //   backgroundColor: Colors.white,
      // ),
      body: pages[widget.index],
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          // color: Theme.of(context).primaryColor,
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [lightred, darkred]),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                iconSize: 50,
                enableFeedback: false,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => HomePage(index: 0)),
                    ModalRoute.withName('/second'),
                  );
                },
                icon: widget.index == 0
                    ? Column(
                        children: [
                          const Icon(
                            Icons.home_outlined,
                            color: Colors.white,
                            size: 33,
                          ),
                          Text(
                            "Home",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    : Column(
                        children: [
                          const Icon(
                            Icons.home_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text(
                            "Home",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => HomePage(index: 1),
                    ),
                  );
                },
                child: widget.index == 1
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const ImageIcon(AssetImage("assets/note@2x.png"),
                              size: 33, color: Colors.white),
                          Text(
                            "Attendance",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const ImageIcon(AssetImage("assets/note@2x.png"),
                              size: 30, color: Colors.white),
                          Text(
                            "Attendance",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => HomePage(index: 2),
                    ),
                  );
                },
                child: widget.index == 2
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const ImageIcon(
                              AssetImage(
                                  "assets/vuesax-linear-archive-book-1@2x.png"),
                              size: 33,
                              color: Colors.white),
                          Text(
                            "Plans",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const ImageIcon(
                              AssetImage(
                                  "assets/vuesax-linear-archive-book-1@2x.png"),
                              size: 30,
                              color: Colors.white),
                          Text(
                            "Plans",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => HomePage(index: 3),
                    ),
                  );
                },
                child: widget.index == 3
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const ImageIcon(AssetImage("assets/menu@2x.png"),
                              size: 33, color: Colors.white),
                          Text(
                            "Others",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const ImageIcon(AssetImage("assets/menu@2x.png"),
                              size: 30, color: Colors.white),
                          Text(
                            "Others",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => HomePage(index: 4),
                    ),
                  );
                },
                child: widget.index == 4
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const ImageIcon(
                              AssetImage("assets/vuesax-outline-user@2x.png"),
                              size: 33,
                              color: Colors.white),
                          Text(
                            "Profile",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const ImageIcon(
                              AssetImage("assets/vuesax-outline-user@2x.png"),
                              size: 30,
                              color: Colors.white),
                          Text(
                            "Profile",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
          ],
        ),
      ),
    );
  }
}
