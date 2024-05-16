import 'package:ai_dating/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'home_page.dart';
import 'login.dart';
import 'notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotificationService().showNotification(
    id: 0,
    title: message.notification?.title ?? 'Background Message Title',
    body: message.notification?.body ?? 'Background Message Body',
    payload: 'camera_screen',
  );
}
String poop = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService notificationService = NotificationService();
  await notificationService.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  bool signedIn = FirebaseAuth.instance.currentUser != null;
  runApp(MyApp(signedIn: signedIn, notificationService: notificationService));
}

class MyApp extends StatelessWidget {
  final NotificationService notificationService;
  final bool signedIn;

  const MyApp({Key? key, required this.signedIn, required this.notificationService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Ranga',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(notificationService: notificationService),);
  }
}
