import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitness/Constants/colors.dart';
import 'package:crunch_fitness/Widgets/buttonwidget.dart';
import 'package:flutter/material.dart';

class NotificationSend extends StatefulWidget {
  const NotificationSend({Key? key}) : super(key: key);

  @override
  _NotificationSendState createState() => _NotificationSendState();
}

class _NotificationSendState extends State<NotificationSend> {
  List<String> user = [];
  Future<void> totalsubsintime(int n) async {
    user = [];
    double sum = 0;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('/Users');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    querySnapshot.docs.forEach((element1) async {
      QuerySnapshot _collectionRefdoc = await FirebaseFirestore.instance
          .collection('/Users/${element1.id}/Subscription')
          .get();
      _collectionRefdoc.docs.forEach((element) {
        if ((element["enddate"] ?? Timestamp(0, 0))
                .compareTo(Timestamp(n * 24 * 60 * 60 * 100, 0)) >
            0) {
          setState(() {
            CollectionReference _collectionRef1 = FirebaseFirestore.instance
                .collection('/Users/${element1.id}/Notification');

            _collectionRef1.add({
              'body': message.text,
              'head': topic.text,
              'isseen': false,
              'time': Timestamp.fromDate(DateTime.now())
            });
            user.add(element1.id);
            print(user.length);
          });
        }
      });

      QuerySnapshot _collectionRefdoc1 = await FirebaseFirestore.instance
          .collection('/Users/${element1.id}/OtherActivities')
          .get();
      _collectionRefdoc1.docs.forEach((element) {
        if ((element["enddate"] ?? Timestamp(0, 0))
                .compareTo(Timestamp(n * 24 * 60 * 60 * 100, 0)) >
            0) {
          setState(() {
            CollectionReference _collectionRef1 = FirebaseFirestore.instance
                .collection('/Users/${element1.id}/Notification');

            _collectionRef1.add({
              'body': message.text,
              'head': topic.text,
              'isseen': false,
              'time': Timestamp.fromDate(DateTime.now())
            });
            user.add(element1.id);
            print(user.length);
          });
        }
      });
    });
  }

  TextEditingController topic = TextEditingController();
  TextEditingController message = TextEditingController();
  Future<void> totalsubs(int n) async {
    user = [];
    double sum = 0;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('/Users');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    querySnapshot.docs.forEach((element1) async {
      QuerySnapshot _collectionRefdoc = await FirebaseFirestore.instance
          .collection('/Users/${element1.id}/Subscription')
          .get();
      _collectionRefdoc.docs.forEach((element) {
        setState(() {
          CollectionReference _collectionRef1 = FirebaseFirestore.instance
              .collection('/Users/${element1.id}/Notification');

          _collectionRef1.add({
            'body': message.text,
            'head': topic.text,
            'isseen': false,
            'time': Timestamp.fromDate(DateTime.now())
          });
          user.add(element1.id);
          print(user);
        });
      });

      QuerySnapshot _collectionRefdoc1 = await FirebaseFirestore.instance
          .collection('/Users/${element1.id}/OtherActivities')
          .get();
      _collectionRefdoc1.docs.forEach((element) {
        setState(() {
          CollectionReference _collectionRef1 = FirebaseFirestore.instance
              .collection('/Users/${element1.id}/Notification');

          _collectionRef1.add({
            'body': message.text,
            'head': topic.text,
            'isseen': false,
            'time': Timestamp.fromDate(DateTime.now())
          });
          user.add(element1.id);
          print(user);
        });
      });
    });
  }

  Future<void> alluser(int n) async {
    user = [];
    double sum = 0;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('/Users');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    querySnapshot.docs.forEach((element1) async {
      CollectionReference _collectionRef1 = FirebaseFirestore.instance
          .collection('/Users/${element1.id}/Notification');

      _collectionRef1.add({
        'body': message.text,
        'head': topic.text,
        'isseen': false,
        'time': Timestamp.fromDate(DateTime.now())
      });
      user.add(element1.id);
    });
  }

  bool checkedValue = false;
  bool checkedValue1 = false;

  bool checkedValue2 = false;

  bool checkedValue3 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var heightfactor = screenSize.height * 0.0012;
    var widthfactor = screenSize.width * 0.0007;
    var sizefactor = screenSize.shortestSide * 0.0012;
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Send to",
                style: TextStyle(color: lightred, fontSize: 18),
              ),
              SizedBox(
                width: 150,
                height: 50,
                child: CheckboxListTile(
                  title: Text("All"),
                  value: checkedValue,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValue = newValue!;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
              ),
              SizedBox(
                width: 250,
                height: 50,
                child: CheckboxListTile(
                  title: Text("7 days ahead of expiry"),
                  value: checkedValue1,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValue1 = newValue!;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
              ),
              SizedBox(
                width: 250,
                height: 50,
                child: CheckboxListTile(
                  title: Text("1 days ahead of expiry"),
                  value: checkedValue2,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValue2 = newValue!;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
              ),
              SizedBox(
                width: 250,
                height: 50,
                child: CheckboxListTile(
                  title: Text("Only to Subscriber"),
                  value: checkedValue3,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValue3 = newValue!;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
              ),
            ],
          ),
          SizedBox(
            width: screenSize.width * 0.45,
            height: screenSize.height * 0.1,
            child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: TextFormField(
                            controller: topic,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Enter the Topic',
                            ))))),
          ),
          SizedBox(
            width: screenSize.width * 0.45,
            height: screenSize.height * 0.5,
            child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: TextFormField(
                            maxLines: 5,
                            controller: message,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText:
                                  'Enter the message you want to send to all',
                            ))))),
          ),
          SizedBox(
            height: 30,
          ),
          ButtonMethodWidget(() async {
            print(checkedValue3);
            if (checkedValue1) {
              await totalsubsintime(7)
                  // .then((value) {
                  //   for (int i = 0; i < user.length; i++) {
                  //     CollectionReference _collectionRef1 = FirebaseFirestore
                  //         .instance
                  //         .collection('/Users/${user[i]}/Notification');

                  //     _collectionRef1.add({
                  //       'body': message.text,
                  //       'head': topic.text,
                  //       'isseen': false,
                  //       'time': Timestamp.fromDate(DateTime.now())
                  //     });
                  //   }
                  // })
                  .then((value) => setState(() {
                        topic.text = "";
                        message.text = "";
                      }));
            }
            if (checkedValue2) {
              await totalsubsintime(1)
                  // .then((value) {
                  //   for (int i = 0; i < user.length; i++) {
                  //     CollectionReference _collectionRef1 = FirebaseFirestore
                  //         .instance
                  //         .collection('/Users/${user[i]}/Notification');

                  //     _collectionRef1.add({
                  //       'body': message.text,
                  //       'head': topic.text,
                  //       'isseen': false,
                  //       'time': Timestamp.fromDate(DateTime.now())
                  //     });
                  //   }
                  // })
                  .then((value) => setState(() {
                        topic.text = "";
                        message.text = "";
                      }));
            }
            if (checkedValue3) {
              await totalsubs(7)
                  // .then((value) {
                  //   print("sending notif1");
                  //   for (int i = 0; i < user.length; i++) {
                  //     print("sending notif");
                  //     CollectionReference _collectionRef1 = FirebaseFirestore
                  //         .instance
                  //         .collection('/Users/${user[i]}/Notification');

                  //     _collectionRef1.add({
                  //       'body': message.text,
                  //       'head': topic.text,
                  //       'isseen': false,
                  //       'time': Timestamp.fromDate(DateTime.now())
                  //     });
                  //   }
                  // }).
                  .then((value) => setState(() {
                        topic.text = "";
                        message.text = "";
                      }));
            }
            if (checkedValue) {
              await alluser(6)
                  // .then((value) {
                  //   for (int i = 0; i < user.length; i++) {
                  //     CollectionReference _collectionRef1 = FirebaseFirestore
                  //         .instance
                  //         .collection('/Users/${user[i]}/Notification');

                  //     _collectionRef1.add({
                  //       'body': message.text,
                  //       'head': topic.text,
                  //       'isseen': false,
                  //       'time': Timestamp.fromDate(DateTime.now())
                  //     });
                  //   }
                  // })
                  .then((value) => setState(() {
                        topic.text = "";
                        message.text = "";
                      }));
            }
          }, 50, 250, "Send Notification", 15)
        ],
      ),
    );
  }
}
