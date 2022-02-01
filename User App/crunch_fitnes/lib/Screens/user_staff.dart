import 'package:crunch_fitnes/Screens/loginwithotp.dart';
import 'package:crunch_fitnes/Screens/register.dart';
import 'package:crunch_fitnes/Widgets/buttonwidget.dart';
import 'package:crunch_fitnes/Widgets/simplebuttonwidget.dart';
import 'package:flutter/material.dart';

class UserStaff extends StatefulWidget {
  int n;
  UserStaff({required this.n});

  @override
  _UserStaffState createState() => _UserStaffState();
}

class _UserStaffState extends State<UserStaff> {
  double h = 50;
  double w = 350;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                height: 70,
              ),
              Image(
                image: AssetImage("assets/Layer 1@2x.png"),
                width: 170,
                height: 170,
              ),
              Image(
                image: AssetImage("assets/Personal Trainer-amico@2x.png"),
                width: 300,
                height: 300,
              ),
              SizedBox(
                height: 20,
              ),
              ButtonMethodWidget(func1, h, w, "Continue as User/Member", 20.0),
              SizedBox(
                height: 20,
              ),
              SimpleButtonMethodWidget(func2, h, w, "Staff/ Trainer", 20.0)
            ],
          ),
        ],
      ),
    );
  }

  func1() {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                widget.n == 1 ? Register(n: 1) : LoginWithOtp(n: 1)));
  }

  func2() {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              widget.n == 1 ? Register(n: 2) : LoginWithOtp(n: 2),
        ));
  }
}
