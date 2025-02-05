import 'package:ai_dating/home_page.dart';
import 'package:ai_dating/register.dart';
import 'package:ai_dating/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ai_dating/text_field.dart';
import 'package:ai_dating/phone_page.dart'; // Corrected import statement
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_dating/constants.dart';
import 'chat_page.dart';
import 'notification_service.dart';  // Corrected import statement

bool isClassRegistered = true;
final _firestore = FirebaseFirestore.instance;

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  final NotificationService notificationService;  // Added this line

  const LoginPage({Key? key, this.onTap, required this.notificationService}) : super(key: key);  // Added this line

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void register() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage(notificationService: widget.notificationService,)));
  }

  void noSignIn() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(notificationService: widget.notificationService)));
  }

  void navigateToPhonePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PhonePage(notificationService: widget.notificationService)));
  }

  // User sign in
  void signIn() async {
    // Show progress
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(notificationService: widget.notificationService),
        ),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }

  // Display dialog message
  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/owl2.png',
                  width: 200,
                  height: 200,
                ),
                const Text("Welcome!", style: TextStyle(fontSize: 17)),
                const SizedBox(height: 25),
                MyTextField(controller: emailTextController, hintText: 'Email', obscureText: false),
                const SizedBox(height: 10),
                MyTextField(controller: passwordTextController, hintText: 'Password', obscureText: true),
                const SizedBox(height: 25),
                MyButton(onTap: signIn, text: 'Sign in'),
                const SizedBox(height: 25),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Not a member?", style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: register,
                          child: const Text(
                            'Register Now!',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(' | '),
                        GestureDetector(
                          onTap: noSignIn,
                          child: const Text(
                            "Continue anyways!",
                            style: TextStyle(
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(' | '),
                        GestureDetector(
                          onTap: () {},  // TestSwipeable,
                          child: const Text(
                            "Test Swipeable",
                            style: TextStyle(
                              color: Colors.red,  // Choose your desired color for the button text
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: navigateToPhonePage,
                      child: const Text(
                        "Sign In with Phone",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
