import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitness/Widgets/buttonwidget.dart';
import 'package:flutter/material.dart';

class AddNewPlan extends StatefulWidget {
  AddNewPlan({required this.path});
  String path;
  @override
  _AddNewPlanState createState() => _AddNewPlanState();
}

class _AddNewPlanState extends State<AddNewPlan> {
  String ddval = "6 month";
  int ddintval = 2;
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  // Future<void> loadsession() async {
  //   setState(() async {
  //     await FirebaseFirestore.instance.doc(widget.path).get().then((value) {
  //       setState(() {
  //         name = TextEditingController(text: value["name"]);
  //         price = TextEditingController(text: value["price"]);
  //       });
  //     });
  //   });
  // }
  //   @override
  // void initState() {
  //   loadsession();
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var heightfactor = screenSize.height * 0.0012;
    var widthfactor = screenSize.width * 0.0007;
    var sizefactor = screenSize.shortestSide * 0.0012;
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: EdgeInsets.all(40 * sizefactor),
      child: Center(
        child: SizedBox(
          width: 800 * widthfactor,
          height: 400 * heightfactor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 800 * widthfactor,
                height: 70 * heightfactor,
                child: Padding(
                    padding: EdgeInsets.only(
                        top: 5 * sizefactor, bottom: 5 * sizefactor),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(10.0 * sizefactor),
                        ),
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: 15 * sizefactor,
                                right: 15 * sizefactor,
                                top: 5 * sizefactor),
                            child: TextFormField(
                                maxLines: 10,
                                controller: name,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Enter Sub Topic Name',
                                    labelStyle: TextStyle(
                                        fontSize: 18 * sizefactor)))))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 350 * widthfactor,
                    height: 75 * heightfactor,
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: 5 * sizefactor, bottom: 5 * sizefactor),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  new BorderRadius.circular(10.0 * sizefactor),
                            ),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 15 * sizefactor,
                                    right: 15 * sizefactor,
                                    top: 5 * sizefactor),
                                child: TextFormField(
                                    controller: price,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Enter Price',
                                        labelStyle: TextStyle(
                                            fontSize: 18 * sizefactor)))))),
                  ),
                  SizedBox(
                    width: 350 * widthfactor,
                    height: 75 * heightfactor,
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: 10 * sizefactor, bottom: 10 * sizefactor),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  new BorderRadius.circular(10.0 * sizefactor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DropdownButton<String>(
                                  items: <String>[
                                    '1 month',
                                    '3 month',
                                    '6 month',
                                    '1 Yr'
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            fontSize: 18 * sizefactor),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      ddval = value!;
                                      if (value == "1 month") {
                                        ddintval = 0;
                                      }
                                      if (value == "3 month") {
                                        ddintval = 1;
                                      }
                                      if (value == "6 month") {
                                        ddintval = 2;
                                      }
                                      if (value == "1 Yr") {
                                        ddintval = 3;
                                      }
                                    });
                                  },
                                  hint: Text(ddval),
                                )
                              ],
                            ))),
                  ),
                ],
              ),
              ButtonMethodWidget(() async {
                await FirebaseFirestore.instance.collection(widget.path).add({
                  "name": name.text,
                  "duration": ddintval == 0
                      ? '1'
                      : ddintval == 1
                          ? '3'
                          : ddintval == 2
                              ? '6'
                              : '12',
                  "price": price.text
                }).then((value) => Navigator.pop(context));
              }, 50 * heightfactor, 200 * widthfactor, "Save", 15 * sizefactor)
            ],
          ),
        ),
      ),
    )));
  }
}
