import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LikedMePage extends StatefulWidget {
  @override
  _LikedMePageState createState() => _LikedMePageState();
}

class _LikedMePageState extends State<LikedMePage> {
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadLikedUsers();
  }

  Future<void> _loadLikedUsers() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    var docSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
    if (!docSnapshot.exists) return;

    var likedMeIds = List.from(docSnapshot.data()!['liked_me'] ?? []);
    for (var userId in likedMeIds) {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data()!;
        _users.add({
          'name': userData['name'],
          'imageUrl': (userData['images'] as List).isNotEmpty ? userData['images'][0] : null
        });
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 10, // Horizontal space between cards
          mainAxisSpacing: 10, // Vertical space between cards
          childAspectRatio: 0.8, // Aspect ratio of the cards
        ),
        itemCount: _users.length,
        itemBuilder: (context, index) {
          return Card(
            clipBehavior: Clip.antiAlias, // Adds a subtle curve to the card corners
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch the items to fit the card width
              children: [
                Expanded(
                  child: _users[index]['imageUrl'] != null
                      ? Image.network(_users[index]['imageUrl'], fit: BoxFit.cover) // Make the image cover the area of the widget
                      : Container(color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _users[index]['name'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
