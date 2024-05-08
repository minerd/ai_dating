import 'dart:convert';
import 'dart:math';  // Ensure this import is present

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

class ChatRoomPage extends StatefulWidget {
  final types.Room room;

  const ChatRoomPage({Key? key, required this.room}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late types.User _user;

  @override
  void initState() {
    super.initState();
    _setCurrentUser();
  }

  void _setCurrentUser() {
    final firebaseUser = FirebaseChatCore.instance.firebaseUser;
    if (firebaseUser != null) {
      _user = types.User(id: firebaseUser.uid, firstName: 'john',lastName: 'doe', imageUrl: '');
    }
  }

  // Helper function to generate a random string ID for messages
  String randomString() {
    final random = Random.secure();
    final buffer = StringBuffer();
    for (int i = 0; i < 16; i++) {
      buffer.write(random.nextInt(256).toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.room.name ?? 'Chat Room')),
      body: StreamBuilder<List<types.Message>>(
        stream: FirebaseChatCore.instance.messages(widget.room),
        initialData: const [],
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
            return Chat(
              messages: snapshot.data ?? [],
              onSendPressed: _handleSendPressed,
              user: _user,
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading messages: ${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) {
    print(widget.room.id);
    print(message.text);
    FirebaseChatCore.instance.sendMessage(message, widget.room.id);
  }
}
