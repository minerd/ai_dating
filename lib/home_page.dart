import 'package:ai_dating/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'settings.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Sign out method
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Optionally push the user to the login screen or just exit the app
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));  // This will return to the previous screen. Adjust according to your app's flow.
    } catch (e) {
      // If there is an error signing out, you might want to handle it in some way,
      // e.g., showing an error message.
      print('Error signing out: $e');
    }
  }

  Future<void> _settingsPage() async {
      // Optionally push the user to the login screen or just exit the app
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ThemePage()));  // This will return to the previous screen. Adjust according to your app's flow.
  }

  Future<void> _chatPage() async {
    // Optionally push the user to the login screen or just exit the app
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage()));  // This will return to the previous screen. Adjust according to your app's flow.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BeReal Dating'),
      ),
      body: Row(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: InkWell(
              onTap: _signOut,  // Call the sign out method when the text is tapped
              child: Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: InkWell(
              onTap: _settingsPage,  // Call the sign out method when the text is tapped
              child: Text(
                'Settings Page',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: InkWell(
              onTap: _chatPage,  // Call the sign out method when the text is tapped
              child: Text(
                'Chat Page',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
