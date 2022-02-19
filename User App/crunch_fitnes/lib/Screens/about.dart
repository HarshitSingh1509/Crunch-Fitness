import 'package:crunch_fitnes/Constants/colors.dart';
import 'package:crunch_fitnes/Widgets/buttonwidget.dart';
import 'package:email_launcher/email_launcher.dart';
import 'package:flutter/material.dart';
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
                  CircleAvatar()
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
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam eleifend ipsum sit amet tellus tristique, non fermentum justo consectetur. Nullam lacinia congue urna id bibendum. Ut quis nisl et arcu vulputate pharetra vel in quam. Donec porttitor risus id finibus interdum. Aenean turpis lacus, rhoncus vitae sem eu, volutpat dictum libero. Aenean nisi magna, mattis sit amet congue id, ullamcorper vel nisl. Aenean vel erat velit. Duis vel metus neque. Vivamus ac ultrices massa. Integer auctor molestie felis sit amet tempus. Donec venenatis mi in metus sagittis, ac euismod quam aliquet. Suspendisse aliquam magna consectetur magna euismod vulputate. Integer convallis."),
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
                "onec porttitor risus id finibus interdum. Aenean turpis lacus, rhoncus vitae sem eu, volutpat dictum libero. Aenean nisi magna, mattis sit amet congue id, ullamcorper vel nisl. Aenean vel erat velit. Duis vel metus neque. Vivamus ac ultrices massa. Integer auctor molestie felis sit amet tempus. Donec venenatis mi in metus sagittis, ac euismod quam aliquet. Suspendisse aliquam magna consectetur magna euismod vulputate. Integer convallis."),
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
            Text("onec porttitor risus id finibus interdum. A"),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Equipments",
          style: TextStyle(fontSize: 18, color: lightred),
        ),
        Text("Equiment1"),
        Text("Equiment1"),
        Text("Equiment1"),
        Text("Equiment1"),
        Text("Equiment1"),
        Text("Equiment1"),
        Text("Equiment1"),
        Text("Equiment1"),
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
