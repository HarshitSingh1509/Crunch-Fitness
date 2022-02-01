import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitnes/Constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notifications> {
  String uid = "";
  List<dynamic> notification = [];
  @override
  void initState() {
    getnotification();
    // TODO: implement initState
    super.initState();
  }

  Future<void> getnotification() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    uid = auth.currentUser!.uid;
    print(uid);

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('/Users/$uid/Notification');
    QuerySnapshot querySnapshot = await _collectionRef
        .where('time', isLessThan: Timestamp(24 * 30 * 60 * 60 * 1000, 0))
        .orderBy('time', descending: true)
        .get();

    // Get data from docs and convert map to List
    setState(() {
      notification = querySnapshot.docs.map((doc) {
        print(doc["time"]);
        return doc;
      }).toList();
    });
    // ignore: avoid_print
    print("****");
    print(Timestamp.fromDate(DateTime(2022, 2, 1)));
    //FirebaseFirestore.instance.collection('/Users/$uid/random');
    // .add({'data': 1}).then((value) => print(value));
    print(notification);
    print(notification);
  }

  Future<void> clearall() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    uid = auth.currentUser!.uid;
    print(uid);

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('/Users/$uid/Notification');
    QuerySnapshot querySnapshot = await _collectionRef
        .where('time', isLessThan: Timestamp(24 * 30 * 60 * 60 * 1000, 0))
        .get();

    // Get data from docs and convert map to List
    querySnapshot.docs.forEach((element) {
      _collectionRef.doc(element.id).set(
        {'isseen': true},
        SetOptions(merge: true),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 8, right: 8, bottom: 10),
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
                              "Notification",
                              style: TextStyle(fontSize: 25),
                            ),
                            Row(
                              children: [
                                Image(
                                  image: AssetImage(
                                      "assets/notification-5@2x.png"),
                                  height: 25,
                                  width: 25,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      GetStorage().read('profileimg') ?? ""),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Today"),
                          GestureDetector(
                            onTap: () {
                              clearall();
                            },
                            child: Text(
                              "clear all",
                              style: TextStyle(
                                  color: lightred,
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        ],
                      ),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: notification.length,
                          itemBuilder: (BuildContext context, int index) {
                            return notification[index]["isseen"]
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, bottom: 15),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 15,
                                            bottom: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              notification[index]["body"]
                                                  .toString(),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            Text(
                                                DateFormat.Hm().format(
                                                    (notification[index]["time"]
                                                        .toDate())),
                                                style: TextStyle(fontSize: 12))
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                          }),
                    ]))));
  }
}
