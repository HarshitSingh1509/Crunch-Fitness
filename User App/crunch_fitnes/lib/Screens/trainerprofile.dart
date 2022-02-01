import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitnes/Constants/colors.dart';
import 'package:crunch_fitnes/Screens/landing_page.dart';
import 'package:crunch_fitnes/Screens/trainernotification.dart';
import 'package:crunch_fitnes/Widgets/buttonwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class TrainerProfile extends StatefulWidget {
  const TrainerProfile({Key? key}) : super(key: key);

  @override
  _TrainerProfileState createState() => _TrainerProfileState();
}

class _TrainerProfileState extends State<TrainerProfile> {
  String profileimg = profile;
  late dynamic data;

  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController email = TextEditingController();
  Future<String> uploadimage(String _image1) async {
    String s = "";
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage
        .ref()
        .child("Trainer/$uid/profile/image1" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(File(_image1));
    return uploadTask.then((res) async {
      s = await res.ref.getDownloadURL();
      print(s);
      setState(() {
        profileimg = s;
      });
      return s;
    });
  }

  Future<void> getuserdata() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    String path = "Trainer/${uid}";
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
    CollectionReference users =
        FirebaseFirestore.instance.collection('Trainer');
    return users
        .doc(auth.currentUser!.uid)
        .set({'name': name, 'email': email, 'number': number},
            SetOptions(merge: true))
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  void initState() {
    getuserdata();
    // TODO: implement initState
    super.initState();
  }

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
                Image(
                  image: AssetImage("assets/crunch_name.png"),
                  height: 35,
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
                            builder: (BuildContext context) =>
                                TrainerNotification(),
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
              child: Stack(fit: StackFit.loose, children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: 140.0,
                        height: 140.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
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
                    await uploadimage(image!.path).then((value) {
                      GetStorage().write('profileimg', value);
                      FirebaseAuth auth = FirebaseAuth.instance;
                      CollectionReference users =
                          FirebaseFirestore.instance.collection('/Trainer/');
                      print(users.doc(auth.currentUser!.uid).get());
                      users
                          .doc(auth.currentUser!.uid)
                          .set({'imageurl': value.toString()},
                              SetOptions(merge: true))
                          .then((value) => print("User Added"))
                          .catchError(
                              (error) => print("Failed to add user: $error"));
                    });
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
          ButtonMethodWidget(() {
            addUser(name.text, email.text, number.text);
          }, 50.0, 350.0, "Save", 15.0),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
              FirebaseAuth auth = await FirebaseAuth.instance;
              auth.signOut();
              GoogleSignIn().signOut();
              FacebookAuth.instance.logOut();
              print(auth.currentUser);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => const LandingPage()),
                ModalRoute.withName('/'),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Logout",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Click to Logout")
                    ],
                  )
                ],
              ),
            ),
          ),
        ])));
  }
}
