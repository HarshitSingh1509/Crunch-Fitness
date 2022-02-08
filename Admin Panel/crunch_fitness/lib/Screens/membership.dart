import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitness/Constants/size.dart';
import 'package:crunch_fitness/Screens/addnewplan.dart';
import 'package:crunch_fitness/Screens/addsession.dart';
import 'package:crunch_fitness/Screens/editactivityorsubtopic.dart';
import 'package:crunch_fitness/Screens/submembership.dart';
import 'package:crunch_fitness/Widgets/buttonwidget.dart';
import 'package:crunch_fitness/Widgets/iconbuttonwidget.dart';
import 'package:flutter/material.dart';

class Membership extends StatefulWidget {
  const Membership({Key? key}) : super(key: key);

  @override
  _MembershipState createState() => _MembershipState();
}

class _MembershipState extends State<Membership> {
  List<String> alltopicsid = [];
  List<dynamic> alltopics = [];
  List<List<dynamic>> subtopics = [];
  List<dynamic> activitydata = [];
  List<String> activityid = [];
  TextEditingController name = TextEditingController();
  Future<void> getalltopics() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('AppData/Topics/maintopics');
    await _collectionRef.get().then((value) async {
      setState(() {
        alltopicsid = value.docs.map((doc) => doc.id).toList();
        // alltopics = value.docs.map((doc) => doc.data()).toList();
      });
    });

    // Get data from docs and convert map to List

    print(alltopics);
  }

  Future<void> loadactivities() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection('/AppData/Topics/Other Activities');
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List

    setState(() {
      activitydata = querySnapshot.docs.map((doc) => doc.data()).toList();
      activityid = querySnapshot.docs.map((doc) => doc.id).toList();
    });
    print(activitydata);
  }

  @override
  void initState() {
    getalltopics();
    loadactivities();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var heightfactor = screenSize.height * 0.0012;
    var widthfactor = screenSize.width * 0.0007;
    var sizefactor = screenSize.shortestSide * 0.0012;
    SizeConfigs().init(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 1000,
      child: Padding(
        padding: EdgeInsets.only(left: 40 * sizefactor, right: 40 * sizefactor),
        child: Column(
          children: [
            SizedBox(
              height: 20 * heightfactor,
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
                      crossAxisSpacing: 40 * widthfactor,
                      mainAxisSpacing: 40 * heightfactor,
                      mainAxisExtent: 100 * heightfactor,
                    ),
                    itemCount: alltopicsid.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Container(
                          // height: 500,
                          // width: 700,
                          child: Padding(
                        padding: EdgeInsets.only(
                            left: 15 * sizefactor,
                            right: 15 * sizefactor,
                            bottom: 15 * sizefactor),
                        child: SingleChildScrollView(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 300 * widthfactor,
                                height: 70 * heightfactor,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        15.0 * sizefactor),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.all(8.0 * sizefactor),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${alltopicsid[index]}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18 * sizefactor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5 * sizefactor,
                              ),
                              Column(
                                children: [
                                  icobbuttonWidget(() {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute<void>(
                                    //     builder: (BuildContext context) =>
                                    //         SubMembership(),
                                    //   ),
                                    // );
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => SubMembership(
                                                topicid: alltopicsid[index])));
                                  },
                                      25 * sizefactor,
                                      Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 15 * sizefactor,
                                      )),
                                  SizedBox(
                                    height: 7 * heightfactor,
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
                          ),
                        ),
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
              return showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Add New Topic"),
                  content: SizedBox(
                    width: 800 * widthfactor,
                    height: 70 * heightfactor,
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: 5 * sizefactor, bottom: 5 * sizefactor),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(10.0 * sizefactor),
                            ),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 15 * sizefactor,
                                    right: 15 * sizefactor,
                                    top: 5 * sizefactor),
                                child: TextFormField(
                                    controller: name,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Enter Topic Name',
                                        labelStyle: TextStyle(
                                            fontSize: 18 * sizefactor)))))),
                  ),
                  actions: <Widget>[
                    ButtonMethodWidget(() async {
                      await FirebaseFirestore.instance
                          .collection('/AppData/Topics/maintopics')
                          .doc(name.text)
                          .set({
                        "name": name.text,
                      }, SetOptions(merge: true)).then(
                              (value) => Navigator.pop(context));
                    }, 25, 100, "Add", 10)
                  ],
                ),
              );
              // Navigator.push(
              //   context,
              //   MaterialPageRoute<void>(
              //     builder: (BuildContext context) => AddSession(),
              //   ),
              // );
            }, 50 * heightfactor, 150 * widthfactor, "Add New Topic",
                15 * sizefactor),
            SizedBox(
              height: 20 * heightfactor,
            ),
            Container(
              // height: 500,
              // width: 700,
              child: SizedBox(
                height: 250 * heightfactor,
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 40 * widthfactor,
                      mainAxisSpacing: 40 * heightfactor,
                      mainAxisExtent: 110 * heightfactor,
                    ),
                    itemCount: activitydata.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Container(
                          // height: 500,
                          // width: 700,
                          child: Padding(
                        padding: EdgeInsets.only(
                            left: 15 * sizefactor,
                            right: 15 * sizefactor,
                            bottom: 15 * sizefactor),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 300 * widthfactor,
                              height: 90 * heightfactor,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(15.0 * sizefactor),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(8.0 * sizefactor),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${activitydata[index]["name"]}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18 * sizefactor),
                                            ),
                                            SizedBox(
                                              height: 10 * sizefactor,
                                            ),
                                            Text(
                                              "Rs. ${activitydata[index]["price"]} /-",
                                              style: TextStyle(
                                                  fontSize: 18 * sizefactor),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5 * widthfactor,
                            ),
                            Column(
                              children: [
                                icobbuttonWidget(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          EditActivity(
                                        path:
                                            '/AppData/Topics/Other Activities/${activityid[index]}',
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
                                  height: 7 * heightfactor,
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
                        ),
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
                  builder: (BuildContext context) =>
                      AddNewPlan(path: '/AppData/Topics/Other Activities'),
                ),
              );
            }, 50 * heightfactor, 150 * widthfactor, "Add New Activity",
                15 * sizefactor),
          ],
        ),
      ),
    );
  }
}
