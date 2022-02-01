import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitnes/Constants/colors.dart';
import 'package:crunch_fitnes/Methods/authentication.dart';
import 'package:crunch_fitnes/Screens/home_screen.dart';
import 'package:crunch_fitnes/Screens/loginwithotp.dart';
import 'package:crunch_fitnes/Screens/trainerattendance.dart';
import 'package:crunch_fitnes/Widgets/buttonwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Register extends StatefulWidget {
  Register({required this.n});
  int n;
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String img =
      "https://firebasestorage.googleapis.com/v0/b/crunch-fitness-efeba.appspot.com/o/istockphoto-1073597286-612x612.jpg?alt=media&token=89506e09-33b1-43c2-a235-78fa962e4138";
  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController phnumber = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  Future<String> uploadimage(String _image1) async {
    String s = "";

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(
        "${widget.n == 1 ? 'Users' : 'Trainer'}/aadhar/image1" +
            DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(File(_image1));
    return uploadTask.then((res) async {
      s = await res.ref.getDownloadURL();
      setState(() {
        img = s;
      });
      return s;
    });
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

// String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
//     length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  Future<void> addUser(String name, String email, String number) {
    // Call the user's CollectionReference to add a new user
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    return users.doc(auth.currentUser!.uid).set({
      'name': name,
      'email': email,
      'number': number,
      'invite': generateRandomString(15),
      'joindate': Timestamp.fromDate(DateTime.now()),
      'isactive': true,
      'aadharurl': img
    }).then((value) {
      CollectionReference _collectionRef1 =
          FirebaseFirestore.instance.collection('/Users/$uid/Notification');

      _collectionRef1.add({
        'body': "Welcome to Crunch Fitness Studio",
        'head': "welcom",
        'isseen': false,
        'time': Timestamp.fromDate(DateTime.now())
      });
    }).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addTrainer(String name, String email, String number) {
    // Call the user's CollectionReference to add a new user
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    CollectionReference users =
        FirebaseFirestore.instance.collection('Trainer');
    return users.doc(auth.currentUser!.uid).set({
      'name': name,
      'email': email,
      'number': number,
      //   'invite': generateRandomString(15),
      'joindate': Timestamp.fromDate(DateTime.now()),
      'isactive': true
    }).then((value) {
      CollectionReference _collectionRef1 =
          FirebaseFirestore.instance.collection('/Trainer/$uid/Notification');

      _collectionRef1.add({
        'body': "Welcome to Crunch Fitness Studio",
        'head': "welcom",
        'isseen': false,
        'time': Timestamp.fromDate(DateTime.now())
      });
    }).catchError((error) => print("Failed to add user: $error"));
  }

  // final picker = ImagePicker();
  // late File img;
  // // Future pickImage() async {
  // //   final pickedFile = await picker.getImage(source: ImageSource.camera);

  // //   setState(() {
  // //     _imageFile = File(pickedFile!.path);
  // //   });
  // // }
  // late XFile? image;
  // Future<void> pickingimage() async {
  //   XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     img = image as File;
  //   });
  // }

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Image(
              image: AssetImage("assets/Layer 1@2x.png"),
              width: 170,
              height: 170,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Where fitness is life",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Welcome to cities most desired",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "fitness studio",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(
                  width: 100,
                )
              ],
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
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'UserName',
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
                          padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                          child: TextFormField(
                              controller: email,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Email',
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
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(
                              image: NetworkImage(img),
                              width: 70,
                            ),
                            ButtonMethodWidget(() async {
                              final ImagePicker _picker = ImagePicker();
                              // Pick an image
                              final XFile? image = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              String s = await uploadimage(image!.path);
                              FirebaseAuth auth = FirebaseAuth.instance;
                              CollectionReference users =
                                  FirebaseFirestore.instance.collection(
                                      widget.n == 1 ? 'Users' : 'Trainer');
                              users
                                  .doc(auth.currentUser!.uid)
                                  .update({'imageurl': s.toString()})
                                  .then((value) => print("User Added"))
                                  .catchError((error) =>
                                      print("Failed to add user: $error"));
                            }, 40.0, 100.0, "upload", 15.0)
                          ],
                        ),
                      ))),
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
                              controller: phnumber,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Mobile Number',
                              ))))),
            ),
            Form(
              key: formKey,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,

                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v!.length < 3) {
                        return "Enter 6 digit OTP";
                      } else {
                        return null;
                      }
                    },
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        selectedColor: Colors.grey[500],
                        activeColor: Colors.grey[300],
                        inactiveFillColor: Colors.grey[300],
                        selectedFillColor: Colors.grey[300],
                        errorBorderColor: Colors.grey[300],
                        inactiveColor: Colors.grey[300]),
                    cursorColor: Colors.black,
                    animationDuration: Duration(milliseconds: 300),
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    boxShadows: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                    onCompleted: (v) async {
                      bool isverified = await loginwithotp(v);

                      print(isverified);
                      if (isverified) {
                        if (widget.n == 1) {
                          await addUser(name.text, email.text, phnumber.text);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    HomePage(index: 0),
                              ));
                        } else {
                          await addTrainer(
                              name.text, email.text, phnumber.text);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    HomePage(index: 0),
                              ));
                        }
                      }
                    },
                    // onTap: () {
                    //   print("Pressed");
                    // },
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                hasError ? "*Please fill up all the cells properly" : "",
                style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () async {
                      print(phnumber.text);
                      verifyphone(phnumber.text);
                    },
                    child: Text(
                      "SEND OTP",
                      style: TextStyle(
                          color: darkred,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
            // SizedBox(
            //   width: 350,
            //   height: 75,
            //   child: Padding(
            //       padding: EdgeInsets.only(top: 10, bottom: 10),
            //       child: Container(
            //           decoration: BoxDecoration(
            //             color: Colors.grey[300],
            //             borderRadius: new BorderRadius.circular(10.0),
            //           ),
            //           child: Padding(
            //               padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            //               child: TextFormField(
            //                   decoration: InputDecoration(
            //                 border: InputBorder.none,
            //                 labelText: 'Password',
            //               ))))),
            // ),
            SizedBox(
              height: 30,
            ),
            ButtonMethodWidget(funct1, 50.0, 350.0, 'Continue', 20.0),
            SizedBox(
              height: 15,
            ),
            Text(
              "or",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (widget.n == 1) {
                      UserCredential user = await signInWithFacebook();
                      print(user);
                      await addUser(
                          user.user!.displayName ?? name.text,
                          user.user!.email ?? email.text,
                          user.user!.phoneNumber ?? phnumber.text);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                HomePage(index: 0),
                          ));
                    } else {
                      UserCredential user = await signInWithFacebook();
                      print(user);
                      await addTrainer(
                          user.user!.displayName ?? name.text,
                          user.user!.email ?? email.text,
                          user.user!.phoneNumber ?? phnumber.text);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const TrainerAttendance(),
                          ));
                    }
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Image(
                          width: 30,
                          height: 30,
                          image: AssetImage("assets/facebook-2@2x.png")),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (widget.n == 1) {
                      UserCredential user = await signInWithGoogle();
                      print(user);
                      await addUser(
                          user.user!.displayName ?? name.text,
                          user.additionalUserInfo!.profile!["email"] ??
                              email.text,
                          user.user!.phoneNumber ?? phnumber.text);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                HomePage(index: 0),
                          ));
                    } else {
                      UserCredential user = await signInWithGoogle();
                      print(user);
                      await addTrainer(
                          user.user!.displayName ?? name.text,
                          user.additionalUserInfo!.profile!["email"] ??
                              email.text,
                          user.user!.phoneNumber ?? phnumber.text);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const TrainerAttendance(),
                          ));
                    }
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Image(
                          width: 30,
                          height: 30,
                          image: AssetImage("assets/search-2@2x.png")),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Already Have an account?"),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            LoginWithOtp(n: widget.n),
                      ),
                    );
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.red),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  funct1() {}
}
