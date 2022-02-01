// ignore_for_file: file_names

import 'dart:async';

import 'package:crunch_fitnes/Constants/colors.dart';
import 'package:crunch_fitnes/Methods/authentication.dart';
import 'package:crunch_fitnes/Screens/home_screen.dart';
import 'package:crunch_fitnes/Screens/register.dart';
import 'package:crunch_fitnes/Screens/trainerattendance.dart';
import 'package:crunch_fitnes/Widgets/buttonwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginWithOtp extends StatefulWidget {
  LoginWithOtp({required this.n});
  int n;

  @override
  _LoginWithOtpState createState() => _LoginWithOtpState();
}

class _LoginWithOtpState extends State<LoginWithOtp> {
  TextEditingController phnumber = TextEditingController();
  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

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
            SizedBox(
              height: 20,
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
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => HomePage(
                                  index: 0,
                                ),
                              ));
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const TrainerAttendance(),
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
                      // FirebaseAuth auth = await FirebaseAuth.instance;
                      // auth.signOut();
                      // print(auth.currentUser);
                      verifyphone(phnumber.text);
                    },
                    child: Text(
                      "SEND OTP",
                      style: TextStyle(
                          color: lightred,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
            SizedBox(
              height: 30,
            ),
            ButtonMethodWidget(funct1, 50.0, 350.0, 'Login', 20.0),
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Card(
                //   elevation: 3,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.all(Radius.circular(10)),
                //   ),
                //   child: Padding(
                //     padding: EdgeInsets.all(10.0),
                //     child: Image(
                //         width: 30,
                //         height: 30,
                //         image: AssetImage("assets/insta@2x.png")),
                //   ),
                // ),
                GestureDetector(
                  onTap: () async {
                    if (widget.n == 1) {
                      UserCredential user = await signInWithFacebook();
                      print(user);
                      // await addUser(user.user!.displayName ?? "",
                      //     user.user!.email ?? "", user.user!.phoneNumber ?? "");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                HomePage(index: 0),
                          ));
                    } else {
                      UserCredential user = await signInWithFacebook();
                      print(user);
                      // await addTrainer(
                      //     user.user!.displayName ?? "",
                      //     user.additionalUserInfo!.profile!["email"] ?? "",
                      //     user.user!.phoneNumber ?? "");
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
                      // await addUser(
                      //     user.user!.displayName ?? "",
                      //     user.additionalUserInfo!.profile!["email"] ?? "",
                      //     user.user!.phoneNumber ?? "");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                HomePage(index: 0),
                          ));
                    } else {
                      UserCredential user = await signInWithGoogle();
                      print(user);
                      // await addTrainer(
                      //     user.user!.displayName ?? "",
                      //     user.additionalUserInfo!.profile!["email"] ?? "",
                      //     user.user!.phoneNumber ?? "");
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
                Text("Don't Have an account?"),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            Register(n: widget.n),
                      ),
                    );
                  },
                  child: Text(
                    "Registe",
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

  funct1() {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => HomePage(index: 0),
        ));
  }
}
