import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitness/Constants/colors.dart';
import 'package:crunch_fitness/Widgets/buttonwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Plans extends StatefulWidget {
  Plans({required this.id});
  String id;
  @override
  _PlansState createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  bool loading = true;
  List<String> alltopics = [];
  List<List<dynamic>> subtopics = [];
  List<dynamic> activitydata = [];
  List<String> activityid = [];
  @override
  void initState() {
    loadactivities();
    getalltopics();

    // TODO: implement initState
    super.initState();
  }
  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   successpayment(response.paymentId!);
  //   Fluttertoast.showToast(
  //       msg: "SUCCESS: " + response.paymentId!,
  //       toastLength: Toast.LENGTH_SHORT);
  // }

  Future<void> successpayment(String id, double amount, String name,
      String topicid, bool isotheractivity, double duration) async {
    // FirebaseFirestore firestore = FirebaseFirestore.instance;
    // FirebaseAuth auth = FirebaseAuth.instance;
    // String uid = auth.currentUser!.uid;
    // print(uid);

    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection('/Users/${widget.id}/Transaction');
    _collectionRef.doc(id).set({
      'amount': amount,
      'name': name,
      'topic': topicid,
      'transactionate': Timestamp.fromDate(DateTime.now())
    });
    if (isotheractivity) {
      CollectionReference _collectionRef1 = FirebaseFirestore.instance
          .collection('/Users/${widget.id}/OtherActivities');
      dynamic data = _collectionRef1.doc(topicid).get();
      _collectionRef1.doc(topicid).set({
        'price': amount,
        'name': name,
        'startdate': Timestamp.fromDate(DateTime.now()),
        'enddate': Timestamp.fromDate(
            DateTime.now().add(Duration(days: (duration * 30).round()))),
        'ishold': false,
        'holddate': Timestamp.fromDate(DateTime.now())
      });
    } else {
      CollectionReference _collectionRef1 = FirebaseFirestore.instance
          .collection('/Users/${widget.id}/Subscription');
      dynamic data = _collectionRef1.doc(topicid).get();
      _collectionRef1.doc(topicid).set({
        'price': amount,
        'name': name,
        'startdate': Timestamp.fromDate(DateTime.now()),
        'enddate': Timestamp.fromDate(
            DateTime.now().add(Duration(days: (duration * 30).round()))),
        'ishold': false,
        'holddate': Timestamp.fromDate(DateTime.now())
      });
    }
  }

  Future<void> getalltopics() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('AppData/Topics/maintopics');
    await _collectionRef.get().then((value) async {
      setState(() {
        alltopics = value.docs.map((doc) => doc.id).toList();
      });
      await getallsubcategoryoftopic();
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

  Future<void> getallsubcategoryoftopic() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    print(alltopics);
    for (int i = 0; i < await alltopics.length; i++) {
      print(i);
      CollectionReference _collectionRef = FirebaseFirestore.instance
          .collection('/AppData/Topics/maintopics/${alltopics[i]}/topics');
      QuerySnapshot querySnapshot = await _collectionRef.get();

      // Get data from docs and convert map to List
      setState(() {
        subtopics.add(querySnapshot.docs.map((doc) => doc).toList());
      });
    }
    setState(() {
      loading = false;
    });
    print("*******");
    print(subtopics);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: SingleChildScrollView(
                child: Column(children: [
            SizedBox(
              height: 15,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 10),
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
                    "Plans",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ],
              ),
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: alltopics.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alltopics[index],
                          style: TextStyle(fontSize: 15, color: darkred),
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: subtopics[index].length,
                            itemBuilder: (BuildContext context, int i) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 8,
                                          left: 15,
                                          right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                subtopics[index][i]["name"],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  "Rs ${subtopics[index][i]["price"]}/-")
                                            ],
                                          ),
                                          ButtonMethodWidget(() {
                                            successpayment(
                                                    "By Admin",
                                                    double.parse(
                                                        subtopics[index][i]
                                                            ["price"]),
                                                    subtopics[index][i]["name"],
                                                    alltopics[index],
                                                    false,
                                                    double.parse(
                                                        subtopics[index][i]
                                                            ["duration"]))
                                                .then((value) =>
                                                    showAlertDialog(context));
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute<void>(
                                            //     builder:
                                            //         (BuildContext context) =>
                                            //             Payment(
                                            //       amount: double.parse(
                                            //           subtopics[index][i]
                                            //               ["price"]),
                                            //       duration: double.parse(
                                            //           subtopics[index][i]
                                            //               ["duration"]),
                                            //       name: subtopics[index][i]
                                            //           ["name"],
                                            //       topicid: alltopics[index],
                                            //       isotheractivity: false,
                                            //     ),
                                            //   ),
                                            // );
                                          }, 35.0, 100.0, "Subscribe", 12.0)
                                        ],
                                      ),
                                    )),
                              );
                            })
                      ],
                    ),
                  );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Other Activities",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 15, color: darkred),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: activitydata.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 0),
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, bottom: 8, left: 15, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      activitydata[i]["name"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("Rs ${activitydata[i]["price"]}/-")
                                  ],
                                ),
                                ButtonMethodWidget(() {
                                  successpayment(
                                          "By Admin",
                                          double.parse(
                                              activitydata[i]["price"]),
                                          activitydata[i]["name"],
                                          activityid[i],
                                          true,
                                          double.parse(
                                              activitydata[i]["duration"]))
                                      .then(
                                          (value) => showAlertDialog(context));
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute<void>(
                                  //     builder: (BuildContext context) =>
                                  //         Payment(
                                  //       amount: double.parse(
                                  //           activitydata[i]["price"]),
                                  //       duration: double.parse(
                                  //           activitydata[i]["duration"]),
                                  //       name: activitydata[i]["name"],
                                  //       topicid: activityid[i],
                                  //       isotheractivity: true,
                                  //     ),
                                  //   ),
                                  // );
                                }, 35.0, 100.0, "Subscribe", 12.0)
                              ],
                            ),
                          )),
                    );
                  }),
            )
          ])));
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Successs"),
      content: Text(
          "This Plan is successfully subscribed, Please refresh the page to see the changes"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
