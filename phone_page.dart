import 'package:ai_dating/phone_auth_controller.dart';
import 'package:ai_dating/verify_otp_page.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class phonePage extends StatefulWidget {
  const phonePage({Key? key});

  @override
  State<phonePage> createState() => _phonePageState();
}

class _phonePageState extends State<phonePage> {
  bool enableOtpBtn = true; // Always true

  String phoneNumber = '';
  getOtp(){
    PhoneAuthController.sendOtp(context, phoneNumber);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Your Phone Number"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text("BeReal Dating Needs to verify your phone number. Carrier Charges May Apply."),
              SizedBox(height: 30),

              InternationalPhoneNumberInput(
                onInputValidated: (value){
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
                selectorConfig:const SelectorConfig(
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
                child: FilledButton(
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
