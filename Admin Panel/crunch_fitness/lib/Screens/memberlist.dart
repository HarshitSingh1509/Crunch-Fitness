import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitness/Constants/colors.dart';
import 'package:crunch_fitness/Screens/members.dart';
import 'package:crunch_fitness/Screens/trainer.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class MemberList extends StatefulWidget {
  const MemberList({Key? key}) : super(key: key);

  @override
  _MemberListState createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  int selectedindex = 0;
  List<dynamic> users = [];
  List<String> userid = [];
  List<String> staffid = [];
  Future<void> getalluser() async {
    print("hello");
    users = [];
    userid = [];
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('/Users');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    querySnapshot.docs.forEach((element1) async {
      setState(() {
        users.add(element1.data());
        userid.add(element1.id);
      });
    });
  }

  List<dynamic> usersearch = [];
  List<dynamic> trainersearch = [];
  bool issearch = false;
  List<dynamic> staff = [];
  Future<void> getallstaff() async {
    print("hello");
    staff = [];
    staffid = [];
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('/Trainer');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    querySnapshot.docs.forEach((element1) async {
      print(element1);
      setState(() {
        staff.add(element1.data());
        staffid.add(element1.id);
      });
    });
  }

  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    getalluser();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var heightfactor = screenSize.height * 0.0012;
    var widthfactor = screenSize.width * 0.0007;
    var sizefactor = screenSize.shortestSide * 0.0012;
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedindex = 0;
                    getalluser();
                  });
                },
                child: Column(
                  children: [
                    Text("User/Member"),
                    Container(
                      width: 70,
                      height: 7,
                      color: selectedindex == 0 ? darkred : null,
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedindex = 1;
                  });
                  getallstaff();
                },
                child: Column(
                  children: [
                    Text("Staff/Trainer"),
                    Container(
                      width: 70,
                      height: 7,
                      color: selectedindex == 1 ? darkred : null,
                    ),
                  ],
                ),
              ),
              SizedBox(
                  width: 400,
                  height: 50,
                  child: Card(
                    child: selectedindex == 0
                        ? TextFormField(
                            decoration:
                                InputDecoration(hintText: "Search for User"),
                            onTap: (() {
                              usersearch = users;
                              issearch = !issearch;
                              print(issearch);
                            }),
                            onChanged: ((value) {
                              setState(() {
                                users = usersearch
                                    .where((element) => element["name"]
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                              });
                            }),
                          )
                        : TextFormField(
                            decoration:
                                InputDecoration(hintText: "Search for Trainer"),
                            onTap: (() {
                              trainersearch = staff;
                              issearch = !issearch;
                              print(issearch);
                            }),
                            onChanged: ((value) {
                              setState(() {
                                staff = trainersearch
                                    .where((element) => element["name"]
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                              });
                            }),
                          ),
                  )),
              GestureDetector(
                onTap: () {
                  showMonthPicker(
                    context: context,
                    firstDate: DateTime(DateTime.now().year - 1, 5),
                    lastDate: DateTime(DateTime.now().year + 1, 9),
                    initialDate: selectedDate,
                    locale: Locale("en"),
                  ).then((date) {
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(months[DateTime.now().month - 1].toString() +
                        ',' +
                        DateTime.now().year.toString()),
                    // ImageIcon(
                    //   AssetImage(
                    //       "assets/vuesax-linear-note-6@2x.png"),
                    //   size: 20,
                    // )
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: SizedBox(
            height: 600 * heightfactor,
            child: GridView.builder(
                //  physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 250 * widthfactor,
                  mainAxisSpacing: 40 * heightfactor,
                  mainAxisExtent: 130 * heightfactor,
                ),
                itemCount: (selectedindex == 0) ? users.length : staff.length,
                itemBuilder: (BuildContext ctx, index) {
                  return SizedBox(
                    height: 115,
                    width: 300,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  (selectedindex == 0)
                                      ? Members(
                                          id: userid[index],
                                          data: users[index],
                                        )
                                      : TrainerProfile(
                                          id: staffid[index],
                                          data: staff[index])),
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(selectedindex ==
                                            0
                                        ? users[index]["imageurl"] ??
                                            "https://firebasestorage.googleapis.com/v0/b/crunch-fitness-efeba.appspot.com/o/blank-profile-picture-973460_1280.png?alt=media&token=3442a53d-a890-4f36-9b59-0d90352544e7"
                                        : staff[index]["imageurl"] ??
                                            "https://firebasestorage.googleapis.com/v0/b/crunch-fitness-efeba.appspot.com/o/blank-profile-picture-973460_1280.png?alt=media&token=3442a53d-a890-4f36-9b59-0d90352544e7"),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedindex == 0
                                            ? users[index]["name"]
                                            : staff[index]["name"],
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("India"),
                                      Text(
                                          "Mobile: ${selectedindex == 0 ? users[index]["number"] : staff[index]["number"]}")
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Container(
                                width: 200,
                                height: 2,
                                color: Colors.grey[200],
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [Text("View All")],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
