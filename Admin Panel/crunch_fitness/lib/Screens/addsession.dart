import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitness/Widgets/buttonwidget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

class AddSession extends StatefulWidget {
  const AddSession({Key? key}) : super(key: key);

  @override
  _AddSessionState createState() => _AddSessionState();
}

class _AddSessionState extends State<AddSession> {
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
    TextEditingController name = TextEditingController();
    TextEditingController details = TextEditingController();

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
                                    controller: name,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Enter Session Name',
                                        labelStyle: TextStyle(
                                            fontSize: 18 * sizefactor)))))),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      width: 200 * widthfactor,
                      height: 60 * heightfactor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0 * sizefactor),
                            child: Text(
                              "Bannner1",
                              style: TextStyle(fontSize: 18 * sizefactor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ButtonMethodWidget(() async {
                              Uint8List? bytesFromPicker =
                                  await ImagePickerWeb.getImageAsBytes();
                              String s = await uploadimage(bytesFromPicker!);
                            }, 50 * heightfactor, 100 * widthfactor, "upload",
                                15 * sizefactor),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 800 * widthfactor,
                height: 250 * heightfactor,
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
                                maxLines: 10,
                                controller: details,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Enter Session Name',
                                    labelStyle: TextStyle(
                                        fontSize: 18 * sizefactor)))))),
              ),
              ButtonMethodWidget(() async {
                await FirebaseFirestore.instance
                    .collection('/AppData/Sessions/SessionData/')
                    .add({
                  "name": name.text,
                  "details": details.text,
                  "imageurl": img
                }).then((value) => Navigator.pop(context));
              }, 50 * heightfactor, 200 * widthfactor, "Save", 15 * sizefactor)
            ],
          ),
        ),
      ),
    )));
  }
}
