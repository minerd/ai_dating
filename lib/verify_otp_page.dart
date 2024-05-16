import 'package:ai_dating/phone_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pinput/pinput.dart';
import 'notification_service.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({Key? key, required this.phoneNumber, required this.verificationId, required this.notificationService}) : super(key: key);

  final String verificationId;
  final String phoneNumber;
  final NotificationService notificationService;

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.phoneNumber),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Column(
            children: [
              Text(
                  "To complete your number verification, please enter the 6-digit code sent to your phone below."
              ),
              SizedBox(height: 20),
              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                onCompleted: (value) {
                  PhoneAuthController.verifyOtp(
                    context,
                    widget.verificationId,
                    value,
                    widget.notificationService, // Pass the notificationService here
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
