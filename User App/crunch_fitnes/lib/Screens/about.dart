import 'package:crunch_fitnes/Constants/colors.dart';
import 'package:crunch_fitnes/Widgets/buttonwidget.dart';
import 'package:email_launcher/email_launcher.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  bool _hasCallSupport = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
              ),
              Text(
                "Others",
                style: TextStyle(fontSize: 25),
              ),
              Row(
                children: [
                  Icon(Icons.notifications_none_outlined),
                  SizedBox(
                    width: 15,
                  ),
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(GetStorage().read('profileimg') ?? ""),
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "About Crunch The Fitness Studio",
          style: TextStyle(fontSize: 18, color: lightred),
        ),
        SizedBox(
          height: 10,
        ),
        Wrap(
          children: [
            Text(
                "Get ready to tear down obstacles of the mind and body. We at Crunch The Fitness Studio believe that getting yourself back to work means setting your own pace. So start your journey with us today. "),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Location",
          style: TextStyle(fontSize: 18, color: lightred),
        ),
        SizedBox(
          height: 10,
        ),
        Wrap(
          children: [
            Text(
                "Sukanta Sarani, Ward no-5, \n Krishnanagar, Nadia,  West Bengal - 741101"),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        ButtonMethodWidget(() {
          _launchInBrowser("https://goo.gl/maps/JRvuPR4bZ2K7hEUb9");
        }, 40.0, 200.0, "Get Direction", 18.0),
        SizedBox(
          height: 20,
        ),
        Text(
          "Hours",
          style: TextStyle(fontSize: 18, color: lightred),
        ),
        SizedBox(
          height: 10,
        ),
        Wrap(
          children: [
            Text("Monday to Saturday \n 6am to 10pm"),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Equipments",
          style: TextStyle(fontSize: 18, color: lightred),
        ),
        Text("Battle Ropes & Pulleys"),
        Text("TRX"),
        Text("Barbells & Bumper Plates"),
        Text("Free Weights"),
        Text("Weight Training Arena"),
        Text("Step Benches"),
        Text("Treadmills & Cross Trainers"),
        Text("Spin Bikes"),
        Text("Air Rower & Air Bike"),
        Text("Yoga Arena"),
        Text("Studio Tire & Kettlebells"),
        Text("Custom CrossFit Course"),
        Text("Lockers"),
        Text("Changing Rooms"),
        Text("Lounge"),
        Text("Zumba Arena"),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  _makePhoneCall("+91-7872707877");
                },
                icon: Icon(
                  Icons.phone,
                  size: 30,
                )),
            Text("+91-7872707877"),
          ],
        ),
        GestureDetector(
          onTap: () async {
            Email email = Email(
                to: ['support@crunchthefitnessstudio'],
                subject: 'subject',
                body: 'body');
            await EmailLauncher.launch(email);
          },
          child: Row(
            children: [
              IconButton(
                  onPressed: () async {
                    Email email = Email(
                        to: ['support@crunchthefitnessstudio'],
                        subject: 'subject',
                        body: 'body');
                    await EmailLauncher.launch(email);
                  },
                  icon: Icon(
                    Icons.email,
                    size: 30,
                  )),
              Text("support@crunchthefitnessstudio"),
            ],
          ),
        ),
        GestureDetector(
          onTap: () async {
            Email email = Email(
                to: ['info@crunchthefitnessstudio'],
                subject: 'subject',
                body: 'body');
            await EmailLauncher.launch(email);
          },
          child: Row(
            children: [
              IconButton(
                  onPressed: () async {
                    Email email = Email(
                        to: ['info@crunchthefitnessstudio'],
                        subject: 'subject',
                        body: 'body');
                    await EmailLauncher.launch(email);
                  },
                  icon: Icon(
                    Icons.email,
                    size: 30,
                  )),
              Text("info@crunchthefitnessstudio"),
            ],
          ),
        )
      ]),
    )));
  }
}
