import 'package:ai_dating/phone_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'notification_service.dart';

class PhonePage extends StatefulWidget {
  final NotificationService notificationService;

  const PhonePage({Key? key, required this.notificationService}) : super(key: key);

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  bool enableOtpBtn = true; // Always true

  String phoneNumber = '';

  void getOtp() {
    PhoneAuthController.sendOtp(context, phoneNumber, widget.notificationService);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Your Phone Number"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text("BeReal Dating Needs to verify your phone number. Carrier Charges May Apply."),
              const SizedBox(height: 30),

              InternationalPhoneNumberInput(
                onInputValidated: (value) {
                  setState(() {
                    // No need to update enableOtpBtn since it's always true
                  });
                },
                onInputChanged: (value) {
                  setState(() {
                    phoneNumber = value.phoneNumber!;
                  });
                },
                formatInput: true,
                autoFocus: true,
                keyboardType: TextInputType.phone,
                selectorConfig: const SelectorConfig(
                  useEmoji: true,
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
                inputDecoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(  // Changed to ElevatedButton to match Flutter's updated button styling
                  onPressed: enableOtpBtn ? getOtp : null, // Always enabled since enableOtpBtn is always true
                  child: const Text('Get OTP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
