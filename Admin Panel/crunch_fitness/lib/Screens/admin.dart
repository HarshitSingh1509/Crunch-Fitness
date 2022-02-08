import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitness/Widgets/buttonwidget.dart';
import 'package:crunch_fitness/Widgets/iconbuttonwidget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

class AdminPage extends StatefulWidget {
  AdminPage({required this.img, required this.name});
  String name;
  String img;
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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

  String img = "";
  String name = "";
  @override
  void initState() {
    img = widget.img;
    name = widget.name;
    // TODO: implement initState
    super.initState();
  }

  TextEditingController name1 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var heightfactor = screenSize.height * 0.0012;
    var widthfactor = screenSize.width * 0.0007;
    var sizefactor = screenSize.shortestSide * 0.0012;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            GestureDetector(
              onTap: () async {
                Uint8List? bytesFromPicker =
                    await ImagePickerWeb.getImageAsBytes();
                String s = await uploadimage(bytesFromPicker!);
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(img),
                  ),
                  Positioned(
                    child: icobbuttonWidget(
                        () {},
                        25,
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                        )),
                    right: 0,
                    bottom: 20,
                  )
                ],
              ),
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
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 15 * sizefactor,
                              right: 15 * sizefactor,
                              top: 5 * sizefactor),
                          child: TextFormField(
                              controller: name1,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: '${widget.name}',
                                  labelStyle:
                                      TextStyle(fontSize: 18 * sizefactor)))))),
            ),
            SizedBox(
              height: 50,
            ),
            ButtonMethodWidget(() async {
              var doc = await FirebaseFirestore.instance
                  .doc("/AppData/Admin")
                  .set({"imageurl": img, "name": name1.text},
                      SetOptions(merge: true));
            }, 50, 150, "Save", 15)
          ],
        ),
      ),
    );
  }
}
