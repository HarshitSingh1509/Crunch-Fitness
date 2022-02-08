import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../Widgets/buttonwidget.dart';

class EditActivity extends StatefulWidget {
  EditActivity({required this.path});
  String path;
  @override
  _EditActivityState createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {
  String ddval = "6 month";
  int ddintval = 2;
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  Future<void> loadsession() async {
    setState(() async {
      await FirebaseFirestore.instance.doc(widget.path).get().then((value) {
        setState(() {
          name = TextEditingController(text: value["name"]);
          price = TextEditingController(text: value["price"]);
        });
      });
    });
  }

  TextEditingController details = TextEditingController();
  late DocumentSnapshot qu;
  @override
  void initState() {
    loadsession();
    // TODO: implement initState
    super.initState();
  }

  String img = "";
  Future<String> uploadimage(Uint8List _image1) async {
    String s = "";

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("Session/" + DateTime.now().toString());
    UploadTask uploadTask = ref.putData(_image1);
    return uploadTask.then((res) async {
      s = await res.ref.getDownloadURL();
      setState(() {
        img = s;
      });
      return s;
    });
  }

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
                                maxLines: 1,
                                controller: name,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Enter Name',
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
                            top: 10 * sizefactor, bottom: 10 * sizefactor),
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
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 15 * sizefactor),
                                    child: DropdownButton<String>(
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
                                    )),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 18 * sizefactor,
                                )
                              ],
                            ))),
                  ),
                ],
              ),
              ButtonMethodWidget(() async {
                await FirebaseFirestore.instance.doc(widget.path).set({
                  "name": name.text,
                  "duration": ddintval == 0
                      ? '1'
                      : ddintval == 1
                          ? '3'
                          : ddintval == 2
                              ? '6'
                              : '12',
                  "price": price.text
                }, SetOptions(merge: true)).then(
                    (value) => Navigator.pop(context));
              }, 50 * heightfactor, 200 * widthfactor, "Save", 15 * sizefactor)
            ],
          ),
        ),
      ),
    )));
  }
}
