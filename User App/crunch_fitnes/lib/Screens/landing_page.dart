import 'package:crunch_fitnes/Screens/user_staff.dart';
import 'package:crunch_fitnes/Widgets/buttonwidget.dart';
import 'package:crunch_fitnes/Widgets/simplebuttonwidget.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
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
                image: AssetImage("assets/Workout-amico@2x.png"),
                width: 300,
                height: 300,
              ),
              SizedBox(
                height: 80,
              ),
              ButtonMethodWidget(func1, h, w, "Register", 20.0),
              SizedBox(
                height: 20,
              ),
              SimpleButtonMethodWidget(func2, h, w, "Login", 20.0)
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
          builder: (BuildContext context) => UserStaff(
            n: 1,
          ),
        ));
  }

  func2() {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => UserStaff(n: 2),
        ));
  }
}
