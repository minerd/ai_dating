import 'package:ai_dating/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ai_dating/verify_otp_page.dart';
import 'package:ai_dating/notification_service.dart';

class PhoneAuthController {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> sendOtp(BuildContext context, String phoneNumber, NotificationService notificationService) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
        verificationFailed: (FirebaseAuthException error) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  error.message ?? "Something Went Wrong when verifying Phone Number",
                ),
              ),
            );
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VerifyOtpPage(
              phoneNumber: phoneNumber,
              verificationId: verificationId,
              notificationService: notificationService,
            ),
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              error.message ?? "Something Went Wrong when verifying Phone Number",
            ),
          ),
        );
    } catch (e) {
      print(e);
    }
  }

  static Future<void> verifyOtp(
      BuildContext context, String verificationId, String smsCode, NotificationService notificationService) async {
    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      await _auth.signInWithCredential(credential);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => HomePage(notificationService: notificationService)),
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              error.message ?? "Something Went Wrong when verifying Phone Number",
            ),
          ),
        );
    }
  }
}
