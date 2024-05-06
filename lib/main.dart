import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'home_page.dart';
import 'login.dart';

bool signedIn = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  bool signedIn = FirebaseAuth.instance.currentUser != null;
  runApp(MyApp(signedIn: signedIn));
}

class MyApp extends StatelessWidget {
  final bool signedIn;

  const MyApp({Key? key, required this.signedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: signedIn ? HomePage() : LoginPage(),
    );
  }
}
