import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitness/Constants/size.dart';
import 'package:crunch_fitness/Screens/addsession.dart';
import 'package:crunch_fitness/Screens/editsessions.dart';
import 'package:crunch_fitness/Widgets/buttonwidget.dart';
import 'package:crunch_fitness/Widgets/iconbuttonwidget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

class BannersAndSessions extends StatefulWidget {
  const BannersAndSessions({Key? key}) : super(key: key);

  @override
  _BannersAndSessionsState createState() => _BannersAndSessionsState();
}

class _BannersAndSessionsState extends State<BannersAndSessions> {
  initState() {
    loadsession();
    loadbanner();
    super.initState();
  }

  List<String> sessionid = [];
  Future<String> uploadimage(Uint8List _image1, int i) async {
    String s = "";

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage
        .ref()
        .child("Banners/Banner${i + 1}/" + DateTime.now().toString());
    UploadTask uploadTask = ref.putData(_image1);
    return uploadTask.then((res) async {
      s = await res.ref.getDownloadURL();
      // setState(() {
      //   img = s;
      // });
      return s;
    });
  }

  Future<void> loadsession() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('AppData/Sessions/SessionData');
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final sessioniddata = querySnapshot.docs.map((doc) => doc.id).toList();
    setState(() {
      session = allData;
      sessionid = sessioniddata;
    });
    print(allData);
  }

  List<String> banner = [];
  loadbanner() async {
    banner = [];
    DocumentSnapshot qu =
        await FirebaseFirestore.instance.doc('/AppData/Banners/').get();
    setState(() {
      banner.add(qu["Banner1"]);
      banner.add(qu["Banner2"]);
      banner.add(qu["Banner3"]);
      banner.add(qu["Banner4"]);
      banner.add(qu["Banner5"]);
      banner.add(qu["Banner6"]);
      print(banner);
    });
  }

  List<dynamic> session = [];
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var heightfactor = screenSize.height * 0.0012;
    var widthfactor = screenSize.width * 0.0007;
    var sizefactor = screenSize.shortestSide * 0.0012;
    SizeConfigs().init(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 1000 * heightfactor,
      child: Padding(
        padding: EdgeInsets.only(left: 40 * sizefactor, right: 40 * sizefactor),
        child: Column(
          children: [
            SizedBox(
              height: 20 * heightfactor,
            ),
            SizedBox(
              height: 50 * heightfactor,
            ),
            Container(
              // height: 500,
              // width: 700,
              child: SizedBox(
                height: 200 * heightfactor,
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 250 * widthfactor,
                      mainAxisSpacing: 40 * heightfactor,
                      mainAxisExtent: 70 * heightfactor,
                    ),
                    itemCount: 6,
                    itemBuilder: (BuildContext ctx, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15.0 * sizefactor),
                        ),
                        child: Container(
                          width: 150 * widthfactor,
                          height: 80 * heightfactor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0 * sizefactor),
                                child: SizedBox(
                                  width: 80 * widthfactor,
                                  child: Text(
                                    "Bannner${index + 1}",
                                    style: TextStyle(fontSize: 18 * sizefactor),
                                  ),
                                ),
                              ),
                              Image(
                                  height: 40,
                                  width: 40,
                                  image: NetworkImage(banner[index])),
                              Padding(
                                padding: EdgeInsets.all(8.0 * sizefactor),
                                child: ButtonMethodWidget(() async {
                                  Uint8List? bytesFromPicker =
                                      await ImagePickerWeb.getImageAsBytes();
                                  String s = await uploadimage(
                                      bytesFromPicker!, index);
                                  DocumentReference qu = await FirebaseFirestore
                                      .instance
                                      .doc('/AppData/Banners/');
                                  qu.set({"Banner${index + 1}": s},
                                      SetOptions(merge: true));
                                  loadbanner();
                                  //                                    CollectionReference _collectionRef =
                                  //     FirebaseFirestore.instance.collection('/Users');
                                  // //   '/AppData/Attendance/UserAttendance/${months[today.month]},${today.year}/${today.day}');
                                  // QuerySnapshot querySnapshot = await _collectionRef.get();
                                  // querySnapshot.docs.forEach((element1) async {
                                  //   DocumentSnapshot qu = await FirebaseFirestore.instance
                                  //       .doc('/AppData/Attendance/UserAttendance/Feb,2022/1/${element1.id}')
                                  //       .get();

                                  // FirebaseAuth auth = FirebaseAuth.instance;
                                  // CollectionReference users =
                                  //     FirebaseFirestore.instance.collection(
                                  //         widget.n == 1 ? 'Users' : 'Trainer');
                                  // users
                                  //     .doc(auth.currentUser!.uid)
                                  //     .update({'imageurl': s.toString()})
                                  //     .then((value) => print("User Added"))
                                  // .catchError((error) =>
                                  //     print("Failed to add user: $error"));
                                }, 50 * heightfactor, 100 * widthfactor,
                                    "upload", 15 * sizefactor),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),

              // constraints: BoxConstraints(
              //     minHeight: 400,
              //     minWidth: 1000,
              //     maxHeight: 400,
              //     maxWidth: 1500),
            ),
            Container(
              // height: 500,
              // width: 700,
              child: SizedBox(
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10 * widthfactor,
                      mainAxisSpacing: 40 * heightfactor,
                      mainAxisExtent: 140 * heightfactor,
                    ),
                    itemCount: session.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Padding(
                          padding: EdgeInsets.only(
                              left: 15 * sizefactor,
                              right: 15 * sizefactor,
                              bottom: 15 * sizefactor),
                          child: Row(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(15.0 * sizefactor),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                        padding:
                                            EdgeInsets.all(8.0 * sizefactor),
                                        child: Image.network(
                                          session[index]["imageurl"],
                                          height: 80 * heightfactor,
                                          width: 90 * widthfactor,
                                        )),
                                    Padding(
                                      padding: EdgeInsets.all(8.0 * sizefactor),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 70 * widthfactor,
                                            height: 18 * heightfactor,
                                            child: Text(
                                              "${session[index]["name"]}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18 * sizefactor),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 65 * heightfactor,
                                            width: 150 * widthfactor,
                                            child: Text(
                                              "${session[index]["details"]}",
                                              style: TextStyle(
                                                  fontSize: 18 * sizefactor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5 * sizefactor,
                              ),
                              Column(
                                children: [
                                  icobbuttonWidget(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            EditSession(
                                          sessionid: sessionid[index],
                                          data: session[index],
                                        ),
                                      ),
                                    );
                                  },
                                      25 * sizefactor,
                                      Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 15 * sizefactor,
                                      )),
                                  SizedBox(
                                    height: 7 * sizefactor,
                                  ),
                                  icobbuttonWidget(
                                      () {},
                                      25 * sizefactor,
                                      Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 15 * sizefactor,
                                      ))
                                ],
                              )
                            ],
                          ));
                    }),
              ),

              // constraints: BoxConstraints(
              //     minHeight: 400,
              //     minWidth: 1000,
              //     maxHeight: 400,
              //     maxWidth: 1500),
            ),
            ButtonMethodWidget(() {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => AddSession(),
                ),
              );
            }, 50 * heightfactor, 150 * widthfactor, "Add New Session",
                15 * sizefactor)
          ],
        ),
      ),
    );
  }
}
