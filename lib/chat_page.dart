import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'chat_room_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _users = <types.User>[];
  List<Map<String, dynamic>> _matches = [];

  Future<void> _loadMatches() async {
    var currentUser = FirebaseChatCore.instance.firebaseUser;
    if (currentUser == null) return;

    var docSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
    if (!docSnapshot.exists) return;

    var matchIds = List.from(docSnapshot.data()!['matches'] ?? []);
    for (var userId in matchIds) {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data()!;
        _matches.add({
          'name': userData['name'],
          'imageUrl': (userData['images'] as List).isNotEmpty ? userData['images'][0] : null
        });
      }
    }

    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    _loadUsers();
    _loadMatches();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await FirebaseChatCore.instance.users().first; // Assuming it's a stream and taking the first snapshot of data.
      setState(() {
        _users.clear();
        _users.addAll(users);
      });
    } catch (e) {
      print("Error loading users: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 4,  // 1/4th of the screen height
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _matches.length,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width / 3,  // Each card takes up 1/3 of the screen width
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Expanded(
                          child: _matches[index]['imageUrl'] != null
                              ? Image.network(_matches[index]['imageUrl'], fit: BoxFit.cover)
                              : Container(color: Colors.grey, alignment: Alignment.center, child: Text('No Image')),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            _matches[index]['name'] ?? 'Anonymous',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_users[index].firstName ?? 'No name'),
                  onTap: () => _createRoom(_users[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  void _createRoom(types.User user) {
    final currentUser = FirebaseChatCore.instance.firebaseUser;
    final otherUser = user;

    if (currentUser != null) {
      FirebaseChatCore.instance.createRoom(otherUser).then((room) {
        // Navigate to the chat room page
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatRoomPage(room: room),
        ));
        print('Room created: ${room.id}');
      }).catchError((error) {
        print("Failed to create room: $error");
      });
    }
  }
}
