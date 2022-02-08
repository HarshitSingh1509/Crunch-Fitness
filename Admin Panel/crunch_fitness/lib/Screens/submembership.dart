import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitness/Constants/size.dart';
import 'package:crunch_fitness/Screens/addnewplan.dart';
import 'package:crunch_fitness/Screens/addsession.dart';
import 'package:crunch_fitness/Screens/editactivityorsubtopic.dart';
import 'package:crunch_fitness/Widgets/buttonwidget.dart';
import 'package:crunch_fitness/Widgets/iconbuttonwidget.dart';
import 'package:flutter/material.dart';

class SubMembership extends StatefulWidget {
  SubMembership({required this.topicid});
  String topicid;
  @override
  _SubMembershipState createState() => _SubMembershipState();
}

class _SubMembershipState extends State<SubMembership> {
  List<dynamic> subtopics = [];
  List<String> subtopicid = [];
  Future<void> getallsubcategoryoftopic() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection('/AppData/Topics/maintopics/${widget.topicid}/topics');
    await _collectionRef.get().then((querySnapshot) async {
      setState(() {
        subtopics = (querySnapshot.docs.map((doc) => doc.data()).toList());
        subtopicid = (querySnapshot.docs.map((doc) => doc.id).toList());
      });
    });

    // Get data from docs and convert map to List

    print("*******");
    print(subtopics);
  }

  @override
  void initState() {
    getallsubcategoryoftopic();
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
    return Scaffold(
        body: SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 1000 * heightfactor,
      child: Padding(
        padding: EdgeInsets.only(left: 40 * sizefactor, right: 40 * sizefactor),
        child: Column(
          children: [
            SizedBox(
              height: 20 * sizefactor,
            ),
            SizedBox(
              height: 20 * sizefactor,
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
                      mainAxisExtent: 115 * heightfactor,
                    ),
                    itemCount: subtopics.length,
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
                                height: 90 * heightfactor,
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
                                                "${subtopics[index]["name"]}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18 * sizefactor),
                                              ),
                                              SizedBox(
                                                height: 10 * sizefactor,
                                              ),
                                              Text(
                                                "Rs.  ${subtopics[index]["price"]}/-",
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
                                              '/AppData/Topics/maintopics/${widget.topicid}/topics/${subtopicid[index]}',
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
                  builder: (BuildContext context) => AddNewPlan(
                      path:
                          '/AppData/Topics/maintopics/${widget.topicid}/topics'),
                ),
              );
            }, 50 * heightfactor, 150 * widthfactor, "Add New Plan",
                15 * sizefactor),
          ],
        ),
      ),
    ));
  }
}
