import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crunch_fitnes/Constants/colors.dart';
import 'package:crunch_fitnes/Widgets/buttonwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:math';

class Payment extends StatefulWidget {
  Payment(
      {required this.amount,
      required this.duration,
      required this.name,
      required this.isotheractivity,
      required this.topicid});
  String topicid;
  String name;
  double amount;
  double duration;
  bool isotheractivity;

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  static const platform = const MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(
    double amt,
    String desc,
  ) async {
    var options = {
      'key': 'rzp_test_99Wm7wpKaliMOm',
      'amount': amt * 100,
      'name': 'Acme Corp.',
      'description': desc,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    successpayment(response.paymentId!);
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT);
  }

  Future<void> successpayment(String id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    print(uid);

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('/Users/$uid/Transaction');
    _collectionRef.doc(id).set({
      'amount': widget.amount,
      'name': widget.name,
      'topic': widget.topicid,
      'transactionate': Timestamp.fromDate(DateTime.now())
    });
    if (widget.isotheractivity) {
      CollectionReference _collectionRef1 =
          FirebaseFirestore.instance.collection('/Users/$uid/OtherActivities');
      dynamic data = _collectionRef1.doc(widget.topicid).get();
      _collectionRef1.doc(widget.topicid).set({
        'price': widget.amount,
        'name': widget.name,
        'startdate': Timestamp.fromDate(DateTime.now()),
        'enddate': Timestamp.fromDate(
            DateTime.now().add(Duration(days: (widget.duration * 30).round())))
      });
    } else {
      CollectionReference _collectionRef1 =
          FirebaseFirestore.instance.collection('/Users/$uid/Subscription');
      dynamic data = _collectionRef1.doc(widget.topicid).get();
      _collectionRef1.doc(widget.topicid).set({
        'price': widget.amount,
        'name': widget.name,
        'startdate': Timestamp.fromDate(DateTime.now()),
        'enddate': Timestamp.fromDate(
            DateTime.now().add(Duration(days: (widget.duration * 30).round())))
      });
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 10),
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
              "Payment Methods",
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
      Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          "Pay as yo want to",
          style: TextStyle(color: darkred, fontSize: 25),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "One Time Payment",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text("Pay all the fee at one go and enjoy"),
                      Text("All the benefits")
                    ],
                  ),
                  ButtonMethodWidget(() {
                    openCheckout(widget.amount, widget.name);
                  }, 35.0, 100.0, "Pay Now", 12.0)
                ],
              ),
            )),
      ),
      Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "No Cost EMI",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text("Pay in easy emis with Flexible Tenure"),
                      Text("Contact Us to avail the scheme")
                    ],
                  ),
                  ButtonMethodWidget(() {}, 35.0, 100.0, "Contact Us", 12.0)
                ],
              ),
            )),
      )
    ])));
  }
}
