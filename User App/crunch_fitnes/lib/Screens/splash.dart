import 'package:crunch_fitnes/Screens/home_screen.dart';
import 'package:crunch_fitnes/Screens/landing_page.dart';
import 'package:crunch_fitnes/Screens/trainerattendance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  int a = 1;
  @override
  void initState() {
    FirebaseAuth auth = FirebaseAuth.instance;
    print(auth.currentUser);
    if (auth.currentUser != null) {
      a = 0;
    } else {
      a = 1;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return a == 0
        ? (GetStorage().read('user') == '1')
            ? HomePage(index: 0)
            : TrainerAttendance()
        : LandingPage();
  }
}
