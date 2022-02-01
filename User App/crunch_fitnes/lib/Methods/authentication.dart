import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

String verificationid = '';
void verifyphone(String number) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: '+91 ' + number,
    verificationCompleted: (PhoneAuthCredential credential) async {
      // ANDROID ONLY!

      // Sign the user in (or link) with the auto-generated credential
      await auth.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {},
    codeSent: (String verificationId, int? resendToken) {
      verificationid = verificationId;
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}

Future<bool> loginwithotp(String v) async {
  bool ans = await FirebaseAuth.instance
      .signInWithCredential(PhoneAuthProvider.credential(
          verificationId: verificationid, smsCode: v))
      .then((value) async {
    if (value.user != null) {
      return true;
      // setPassword(value.user!.uid);
    } else {
      (SnackBar(content: Text('invalid OTP')));
      return false;
    }
  });
  return true;
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  print(googleUser);
  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
  print(googleAuth);
  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );
  print(credential);
  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<UserCredential> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final OAuthCredential facebookAuthCredential =
      FacebookAuthProvider.credential(loginResult.accessToken!.token);

  // Once signed in, return the UserCredential
  return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
}
