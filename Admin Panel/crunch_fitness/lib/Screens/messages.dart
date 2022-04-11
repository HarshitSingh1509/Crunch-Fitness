import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitness/Constants/size.dart';
import 'package:crunch_fitness/Screens/addsession.dart';
import 'package:crunch_fitness/Widgets/buttonwidget.dart';
import 'package:crunch_fitness/Widgets/iconbuttonwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  List<dynamic> alldata = [];
  bool isload = false;
  List<dynamic> profiledata = [];
  bool isloading = false;
  Future<void> getmessage() async {
    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection('/AppData/HelpandSupport/allmessages/');
    await _collectionRef.get().then((value) async {
      print(true);
      print(value.docs.first.data());
      value.docs.forEach((element) async {
        var data = element.get("uid");
        print(element.get("uid"));
        DocumentSnapshot docsnp =
            await FirebaseFirestore.instance.doc('/Users/$data').get();
        var dataf = docsnp.data() as Map;
        setState(
          () {
            profiledata
                .add({"name": dataf['name'], "imageurl": dataf["imageurl"]});

            print(profiledata);
            setState(() {
              alldata.add(element.data());
            });
            print(alldata);
          },
        );
        // setState(() {
        //   alldata = value.docs.map((doc) => doc.data()).toList();
        //   print(alldata);
        // });
      });
    }).then((value) {
      setState(() {
        isload = false;
      });
    });
  }

  Future<void> gettoken() async {}
  int selectedindex = 0;
  @override
  void initState() {
    getmessage();
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
      //  height: 700,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(
              left: 40 * sizefactor,
              right: 40 * sizefactor,
              top: 100 * sizefactor),
          child: isload
              ? CircularProgressIndicator()
              : Card(
                  child: Padding(
                    padding: EdgeInsets.all(20 * sizefactor),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 500 * heightfactor,
                          width: 350 * widthfactor,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: alldata.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedindex = index;
                                    });
                                  },
                                  child: SizedBox(
                                    width: 350 * widthfactor,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: 350 * widthfactor,
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 25 * sizefactor,
                                                child: Image(
                                                    height: 50 * heightfactor,
                                                    width: 50 * widthfactor,
                                                    image: NetworkImage(
                                                        profiledata[index]
                                                                ["imageurl"] ??
                                                            "https://firebasestorage.googleapis.com/v0/b/crunch-fitness-efeba.appspot.com/o/blank-profile-picture-973460_1280.png?alt=media&token=3442a53d-a890-4f36-9b59-0d90352544e7")),
                                              ),
                                              SizedBox(
                                                width: 10 * widthfactor,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    profiledata[index]
                                                            ["name"] ??
                                                        "",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            18 * sizefactor),
                                                  ),
                                                  SizedBox(
                                                    height: 15 * heightfactor,
                                                  ),
                                                  SizedBox(
                                                      width: 180 * widthfactor,
                                                      child: Text(
                                                        alldata[index]
                                                            ["message"],
                                                        style: TextStyle(
                                                            fontSize: 18 *
                                                                sizefactor),
                                                        maxLines: 1,
                                                      ))
                                                ],
                                              ),
                                              SizedBox(
                                                width: 15 * widthfactor,
                                              ),
                                              SizedBox(
                                                width: 50 * widthfactor,
                                                child: Text(
                                                  alldata[index]["time"] ?? "",
                                                  style: TextStyle(
                                                      fontSize:
                                                          18 * sizefactor),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Divider()
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                            height: 500 * heightfactor,
                            width: 500 * widthfactor,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    CircleAvatar(
                                      child: Image(
                                          height: 50 * heightfactor,
                                          width: 50 * widthfactor,
                                          image: NetworkImage(profiledata[
                                                  selectedindex]["imageurl"] ??
                                              "https://firebasestorage.googleapis.com/v0/b/crunch-fitness-efeba.appspot.com/o/blank-profile-picture-973460_1280.png?alt=media&token=3442a53d-a890-4f36-9b59-0d90352544e7")),
                                    ),
                                    SizedBox(
                                      width: 10 * widthfactor,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          profiledata[selectedindex]["name"] ??
                                              "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18 * widthfactor),
                                        ),
                                        SizedBox(
                                          height: 15 * heightfactor,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 15 * widthfactor,
                                    ),
                                    Text(
                                      alldata[selectedindex]["time"] ?? "",
                                      style:
                                          TextStyle(fontSize: 18 * sizefactor),
                                    )
                                  ],
                                ),
                                Divider(),
                                Text(
                                  alldata[selectedindex]["message"] ?? "",
                                  style: TextStyle(fontSize: 18 * sizefactor),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Center(
  //     child: SizedBox(
  //       width: 900,
  //       height: 500,
  //       child: Row(
  //         children: [
  //           SizedBox(
  //             height: 500,
  //             width: 800,
  //             child: ListView.builder(
  //                 shrinkWrap: true,
  //                 itemCount: 5,
  //                 itemBuilder: (BuildContext context, int index) {
  //                   return Row(
  //                     children: [
  //                       CircleAvatar(
  //                         child: Image(
  //                             height: 50,
  //                             width: 50,
  //                             image: NetworkImage(
  //                                 "https://firebasestorage.googleapis.com/v0/b/crunch-fitness-efeba.appspot.com/o/blank-profile-picture-973460_1280.png?alt=media&token=3442a53d-a890-4f36-9b59-0d90352544e7")),
  //                       )
  //                     ],
  //                   );
  //                 }),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
}
