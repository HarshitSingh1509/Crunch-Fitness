import 'package:crunch_fitness/Widgets/buttonwidget.dart';
import 'package:flutter/material.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var heightfactor = screenSize.height * 0.0012;
    var widthfactor = screenSize.width * 0.0007;
    var sizefactor = screenSize.shortestSide * 0.0012;
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: screenSize.width * 0.45,
            height: screenSize.height * 0.5,
            child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: TextFormField(
                            maxLines: 5,
                            //   controller: name,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Enter the description of app',
                            ))))),
          ),
          SizedBox(
            height: 30,
          ),
          ButtonMethodWidget(() {}, 50, 250, "Save", 15)
        ],
      ),
    );
  }
}
