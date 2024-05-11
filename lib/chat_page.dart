import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'chat_room_page.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _users = <types.User>[];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    final userStream = FirebaseChatCore.instance.users(); // This should be a stream
    userStream.listen((users) {
      setState(() {
        _users.clear();
        _users.addAll(users);
      });
    }).onError((error) {
      print("Error loading users: $error");
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_users[index].firstName ?? 'No name'),
            onTap: () => _createRoom(_users[index]),
          );
        },
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
