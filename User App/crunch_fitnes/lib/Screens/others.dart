import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitnes/Constants/colors.dart';
import 'package:crunch_fitnes/Screens/about.dart';
import 'package:crunch_fitnes/Screens/landing_page.dart';
import 'package:crunch_fitnes/Screens/notification.dart';
import 'package:crunch_fitnes/Widgets/buttonwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/services.dart';

class Others extends StatefulWidget {
  const Others({Key? key}) : super(key: key);

  @override
  _OthersState createState() => _OthersState();
}

class _OthersState extends State<Others> {
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController message = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late dynamic data;
  String ref = "";
  @override
  void initState() {
    getrefferal();
    // TODO: implement initState
    super.initState();
  }

  Future<void> getrefferal() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

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
    // Get data from docs and convert map to List
    setState(() {
      ref = data["invite"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  "Others",
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
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              // showModalBottomSheet(
              //     //   isScrollControlled: true,
              //     //  enableDrag: true,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(15.0),
              //     ),
              //     context: context,
              //     builder: (context) => helpandsupportwidget());
              showModalBottomSheet<void>(
                // isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return helpsupportsheet(context);
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: lightred.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: AssetImage('assets/headphone@2x.png'),
                          scale: 1.3),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Help & Support",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Create a ticket and we will contact you")
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Divider(
              thickness: 2,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: lightred.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: AssetImage('assets/privacy@2x.png'),
                          scale: 1.3),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Privacy Policy",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Click to download the document")
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Divider(
              thickness: 2,
            ),
          ),
          GestureDetector(
            onTap: () {
              showMaterialModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  context: context,
                  builder: (context) => SizedBox(
                        height: 200,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Rate Us",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      child: Center(
                                          child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      )),
                                      height: 30,
                                      width: 30,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xFFD84040),
                                              Color(0xFF940001)
                                            ],
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ButtonMethodWidget(() {}, 50.0, 350.0, "Save", 15.0)
                          ],
                        ),
                      ));
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: lightred.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: AssetImage('assets/rate us@2x.png'),
                          scale: 1.3),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rate Us",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Tell us what you think")
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Divider(
              thickness: 2,
            ),
          ),
          GestureDetector(
            onTap: () {
              showMaterialModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  context: context,
                  builder: (context) => SizedBox(
                        height: 500,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Invite Friends",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      child: Center(
                                          child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      )),
                                      height: 30,
                                      width: 30,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xFFD84040),
                                              Color(0xFF940001)
                                            ],
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Image(
                                height: 200,
                                image: AssetImage("assets/invite-2@2x.png")),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                "Invite your friends to join. Here is your code",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(ref),
                                    GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(
                                            ClipboardData(text: ref));
                                      },
                                      child: Container(
                                        child: Center(
                                            child: Icon(
                                          Icons.copy,
                                          color: Colors.white,
                                        )),
                                        height: 30,
                                        width: 30,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0xFFD84040),
                                                Color(0xFF940001)
                                              ],
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              height: 50,
                              width: 350,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ButtonMethodWidget(() async {
                              await FlutterShare.share(
                                title: 'Invite Link',
                                text: ref,
                              );
                            }, 50.0, 350.0, "Share", 15.0)
                          ],
                        ),
                      ));
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: lightred.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: AssetImage('assets/invite@2x.png'),
                          scale: 1.3),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Invite Friends",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Earn more by Inviting Friends")
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Divider(
              thickness: 2,
            ),
          ),
          // Padding(
          //   padding:
          //       const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          //   child: Row(
          //     children: [
          //       Container(
          //         width: 50,
          //         height: 50,
          //         decoration: BoxDecoration(
          //           color: lightred.withOpacity(0.4),
          //           borderRadius: BorderRadius.circular(10),
          //           image: DecorationImage(
          //               image: AssetImage('assets/key-4@2x.png'), scale: 1.3),
          //         ),
          //       ),
          //       SizedBox(
          //         width: 20,
          //       ),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             "Change Password",
          //             style: TextStyle(fontWeight: FontWeight.bold),
          //           ),
          //           SizedBox(
          //             height: 10,
          //           ),
          //           Text("Click to logout")
          //         ],
          //       )
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 25, right: 25),
          //   child: Divider(
          //     thickness: 2,
          //   ),
          // ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: lightred.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: AssetImage('assets/vuesax-linear-note-4@2x.png'),
                        scale: 1.3),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Terms & Conditions",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Click to download the document")
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Divider(
              thickness: 2,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => About(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: lightred.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: AssetImage('assets/about@2x.png'), scale: 1.3),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About Crunch the Fitness Studio",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Click to see all details about us")
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Divider(
              thickness: 2,
            ),
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
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: lightred.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: AssetImage('assets/logout@2x.png'),
                          scale: 1.3),
                    ),
                  ),
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
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Divider(
              thickness: 2,
            ),
          )
        ])));
  }

  Form helpsupportsheet(BuildContext context) {
    return Form(
      //key: key,
      child: SingleChildScrollView(
        child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Help and Support",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              child: Center(
                                  child: Icon(
                                Icons.close,
                                color: Colors.white,
                              )),
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFD84040),
                                      Color(0xFF940001)
                                    ],
                                  )),
                            ),
                          )
                        ],
                      ),
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
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 5),
                                  child: TextFormField(
                                      controller: name,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Enter Your Name',
                                      ))))),
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
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 5),
                                  child: TextFormField(
                                      controller: email,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Enter Email Id',
                                      ))))),
                    ),
                    SizedBox(
                      width: 350,
                      height: 150,
                      child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 5),
                                  child: TextFormField(
                                      controller: message,
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Enter Message',
                                      ))))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ButtonMethodWidget(() {
                      print("inside this");
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        FirebaseAuth auth = FirebaseAuth.instance;
                        CollectionReference helpandsupport = FirebaseFirestore
                            .instance
                            .collection('AppData/HelpandSupport/allmessages');
                        helpandsupport.add({
                          'email': email.text,
                          'name': name.text,
                          'message': message.text,
                          'uid': auth.currentUser!.uid
                        }).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Message sent, We will reach you soon!!!')),
                          );
                          Navigator.pop(context);
                        }).catchError(
                            (error) => print("Failed to add user: $error"));
                        ;
                      }
                    }, 50.0, 350.0, "Save", 15.0)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
