// ignore_for_file: unnecessary_new

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitnes/Constants/colors.dart';
import 'package:crunch_fitnes/Screens/notification.dart';
import 'package:crunch_fitnes/Screens/payment.dart';
import 'package:crunch_fitnes/Widgets/buttonwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
// late  String name1 ;
//   String email1 = "";
//   String phone1 = "";
  String profileimg = profile;
  late dynamic data;
  final f = new DateFormat('dd/MM/yyyy');
  @override
  void initState() {
    getuserdata();
    gettopicid();
    loadactivities();
    // TODO: implement initState
    super.initState();
  }

  bool loading = true;
  List<String> topicid = [];
  List<dynamic> topicdata = [];
  List<dynamic> activitydata = [];
  List<String> activityid = [];
  Future<void> gettopicid() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('/Users/$uid/Subscription');
    await _collectionRef.get().then((value) async {
      setState(() {
        topicid = value.docs.map((doc) => doc.id).toList();
        topicdata = value.docs.map((doc) => doc).toList();
      });
    });

    // Get data from docs and convert map to List

    print(topicdata);
  }

  Future<void> loadactivities() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('/Users/$uid/OtherActivities');
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List

    setState(() {
      activitydata = querySnapshot.docs.map((doc) => doc.data()).toList();
      activityid = querySnapshot.docs.map((doc) => doc.id).toList();
    });
    print(activitydata[0].toString());
  }

  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController email = TextEditingController();
  Future<void> getuserdata() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    String path = "Users/${uid}";
    DocumentSnapshot _collectionRef =
        await FirebaseFirestore.instance.doc(path).get();
    setState(() {
      if (_collectionRef.exists) {
        data = _collectionRef.data();
      }
    });
    setState(() {
      name.text = data["name"];
      email.text = data["email"];
      number.text = data["number"];

      profileimg = data["imageurl"] ?? profile;
    });
  }

  Future<void> addUser(String name, String email, String number) {
    // Call the user's CollectionReference to add a new user
    FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    return users
        .doc(auth.currentUser!.uid)
        .update({'name': name, 'email': email, 'number': number})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<String> uploadimage(String _image1) async {
    String s = "";
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage
        .ref()
        .child("Users/$uid/profile/image1" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(File(_image1));
    return uploadTask.then((res) async {
      s = await res.ref.getDownloadURL();
      setState(() {
        profileimg = s;
      });
      return profileimg;
    });
  }

  FirebaseStorage _storage = FirebaseStorage.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  "Profile",
                  style: TextStyle(fontSize: 25),
                ),
                Row(
                  children: [
                    IconButton(
                      icon:
                          ImageIcon(AssetImage("assets/notification-6@2x.png")),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => Notifications(),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(GetStorage().read('profileimg') ?? ""),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: new Stack(fit: StackFit.loose, children: <Widget>[
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                        width: 140.0,
                        height: 140.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            image: NetworkImage(profileimg),
                            fit: BoxFit.cover,
                          ),
                        )),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    final ImagePicker _picker = ImagePicker();
                    // Pick an image
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    String s = await uploadimage(image!.path);
                    FirebaseAuth auth = FirebaseAuth.instance;
                    CollectionReference users =
                        FirebaseFirestore.instance.collection('Users');
                    users
                        .doc(auth.currentUser!.uid)
                        .update({'imageurl': s.toString()})
                        .then((value) => print("User Added"))
                        .catchError(
                            (error) => print("Failed to add user: $error"));
                  },
                  child: Padding(
                      padding: EdgeInsets.only(top: 90.0, left: 100),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new CircleAvatar(
                            backgroundColor: darkred,
                            radius: 25.0,
                            child: new Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          )
                        ],
                      )),
                ),
              ])),
          SizedBox(
            height: 40,
          ),
          SizedBox(
            width: 350,
            height: 75,
            child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: TextFormField(
                            controller: name,
                            //        initialValue: data["name"],
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                //  labelText: 'UserName',
                                labelText: "Name"))))),
          ),
          SizedBox(
            width: 350,
            height: 75,
            child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: TextFormField(
                            controller: email,
                            //     initialValue: data["email"],
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Email"))))),
          ),
          SizedBox(
            width: 350,
            height: 75,
            child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: TextFormField(
                            controller: number,
                            //    initialValue: data["number"],
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Phone Number"
                                //    hintText: data["number"]
                                ))))),
          ),
          SizedBox(
            height: 20,
          ),
          ButtonMethodWidget(() {}, 50.0, 350.0, "Save", 15.0),
          SizedBox(
            height: 15,
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: topicid.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 5, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Subscribed to ${topicid[index]}",
                        style: TextStyle(fontSize: 15, color: darkred),
                      ),
                      Text(
                        "Expiry date of subscription ${f.format((topicdata[index]["enddate"].toDate()))}",
                        style: TextStyle(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, left: 15, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        topicdata[index]["name"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("Rs ${topicdata[index]["price"]}/-")
                                    ],
                                  ),
                                  ButtonMethodWidget(() {
                                    print(topicdata[0].data());
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            Payment(
                                          amount: double.parse(topicdata[index]
                                                  ["price"]
                                              .toString()),
                                          duration: DateTime.parse(
                                                      topicdata[index]
                                                              ["startdate"]
                                                          .toDate()
                                                          .toString())
                                                  .difference(DateTime.parse(
                                                      topicdata[index]
                                                              ["enddate"]
                                                          .toDate()
                                                          .toString()))
                                                  .inDays /
                                              30,
                                          name: topicdata[index]["name"],
                                          topicid: topicid[index],
                                          isotheractivity: false,
                                        ),
                                      ),
                                    );
                                  }, 35.0, 100.0, "Subscribe Again", 12.0)
                                ],
                              ),
                            )),
                      )
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Expiry date of subscription ${f.format((activitydata[i]["enddate"].toDate()))}",
                          style: TextStyle(),
                        ),
                        Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 8, left: 15, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            Payment(
                                          amount: double.parse(activitydata[i]
                                                  ["price"]
                                              .toString()),
                                          duration: double.parse(activitydata[i]
                                                  ["duration"]
                                              .toString()),
                                          name: activitydata[i]["name"],
                                          topicid: activityid[i],
                                          isotheractivity: true,
                                        ),
                                      ),
                                    );
                                  }, 35.0, 100.0, "Subscribe Again", 12.0)
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  );
                }),
          )
        ])));
  }
}
