import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'settings.dart';
import 'chat_page.dart';
import 'login.dart';
import 'likes_page.dart';
import 'camera_screen.dart';
import 'notification_service.dart';
import 'notification_state.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  final NotificationService notificationService;

  const HomePage({Key? key, required this.notificationService}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;  // Current index for the bottom navigation bar

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.notificationService.setContext(context);
      if (shouldNavigateToCameraScreen) {
        shouldNavigateToCameraScreen = false;
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CameraScreen()));
      }
    });
  }

  void _showTestNotification() {
    widget.notificationService.flutterLocalNotificationsPlugin.show(
      10,
      'Test Notification',
      'This is a test notification',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: 'camera_screen',
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List of widgets to call from the bottom navigation bar
    final List<Widget> _widgetOptions = [
      Text('Home Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, fontFamily: 'Ranga')),
      LikedMePage(),
      ChatPage(),
      ThemePage(notificationService: widget.notificationService),
      CameraScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Dating', style: TextStyle(fontFamily: 'Ranga', fontSize: 23)),
        surfaceTintColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.notification_important),
            onPressed: _showTestNotification,
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),  // Display the selected page
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.star), //fix to normal heart
              label: 'Likes Me'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Camera')
        ],
        unselectedItemColor: Colors.amber[800],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
