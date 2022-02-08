import 'package:crunch_fitness/Constants/colors.dart';
import 'package:crunch_fitness/Screens/home.dart';
import 'package:crunch_fitness/Screens/home_screen.dart';
import 'package:crunch_fitness/Screens/members.dart';
import 'package:crunch_fitness/Screens/trainer.dart';
import 'package:crunch_fitness/Widgets/buttonwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAae9N4SJwIDXOeZFjPi-X7rFSrak6a5Yw",
          authDomain: "crunch-fitness-efeba.firebaseapp.com",
          projectId: "crunch-fitness-efeba",
          storageBucket: "crunch-fitness-efeba.appspot.com",
          messagingSenderId: "153156118451",
          appId: "1:153156118451:web:bdfd6f3c2fd3930ca58dc6",
          measurementId: "G-G7R4V6FLQV"));

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: // HomeScreen()
            const MyHomePage(
          title: "Crunch Fitness",
        ),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Future<void> signin(String email, String password) async {
  //   try {
  //     await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: email, password: password)
  //         .then((value) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute<void>(
  //           builder: (BuildContext context) => HomeScreen(),
  //         ),
  //       );
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       print('No user found for that email.');
  //     } else if (e.code == 'wrong-password') {
  //       print('Wrong password provided for that user.');
  //     }
  //   }
  // }

  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(
            image: AssetImage("assets/Layer 1@2x.png"),
            height: screenSize.width * 0.15,
            width: screenSize.width * 0.15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome Admin!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30 * screenSize.shortestSide * 0.002)),
              SizedBox(
                height: 15,
              ),
              Text("Lets see what's going on in your app",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: lightred)),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: screenSize.width * 0.25,
                height: screenSize.height * 0.1,
                child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 5),
                            child: TextFormField(
                                controller: name,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'UserName',
                                ))))),
              ),
              SizedBox(
                width: screenSize.width * 0.25,
                height: screenSize.height * 0.1,
                child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 5),
                            child: TextFormField(
                                controller: password,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Password',
                                ))))),
              ),
              SizedBox(
                height: 20,
              ),
              ButtonMethodWidget(() {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => HomeScreen()));
                //signin(name.text, password.text);
              }, screenSize.height * 0.08, screenSize.width * 0.25, "Login",
                  15 * (screenSize.shortestSide * 0.002))
            ],
          )
        ],
      )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
