import 'package:ai_dating/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'chat_room_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'room_manager.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  RoomManager roomManager = RoomManager();
  types.User otherUserObject = types.User(id: 'id');
  final _users = <types.User>[];
  final _matchUsers = <types.User>[];
  final _conversationUsers = <types.User>[];
  List<Map<String, dynamic>> _matches = [];

  Future<void> _loadMatches() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    print(currentUser!.uid);
    if (currentUser == null) return;

    var docSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
    if (!docSnapshot.exists) return;

    var matchIds = List.from(docSnapshot.data()!['matches'] ?? []);
    print(matchIds);
    if (matchIds.isEmpty) {
      setState(() {});  // Ensure UI updates even if there are no matches
      return;
    }

    var matchesSnapshots = await FirebaseFirestore.instance.collection('users').where(FieldPath.documentId, whereIn: matchIds).get();

    _matches.clear();  // Clear existing matches to avoid duplicates
    for (var doc in matchesSnapshots.docs) {
      var userData = doc.data();
      // Here we handle the createdAt field
      var createdAtTimestamp = userData['createdAt'] as Timestamp;  // Get the Timestamp
      var createdAtMillis = createdAtTimestamp.millisecondsSinceEpoch;  // Convert to milliseconds since epoch

      // Now you can use createdAtMillis as an integer
      print('Created At (ms): $createdAtMillis');  // Optional: just for demonstration

      _matches.add({
        'userId': doc.id,  // Capture the document ID, which is the userId
        'name': userData['firstName'],
        'imageUrl': (userData['images'] as List).isNotEmpty ? userData['images'][0] : null,
        'createdAt': createdAtMillis  // Store the integer milliseconds in your matches array
      });
    }
    print(_matches);

    setState(() {});
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

  Future<void> _loadUsersWithConversations() async {
    var currentUser = FirebaseChatCore.instance.firebaseUser;
    if (currentUser == null) return;

    // Fetching rooms to find conversations
    final roomsSnapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .where('userIds', arrayContains: currentUser.uid)
        .get();

    final userIds = <String>{};

    // Collecting user IDs from rooms
    for (var doc in roomsSnapshot.docs) {
      List<dynamic> participants = doc.data()['userIds'];
      for (var userId in participants) {
        if (userId != currentUser.uid) {
          userIds.add(userId);
        }
      }
    }

    // Use the `whereIn` query only if there are IDs to avoid errors with empty lists
    if (userIds.isNotEmpty) {
      var userDocs = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: userIds.toList())
          .get();

      setState(() {
        _users.clear();
        print('hello');
        for (var doc in userDocs.docs) {
          var userData = doc.data();
          //print("Before conversion: $userData");

          // Dynamically convert all Timestamps to milliseconds since epoch
          userData.keys.forEach((key) {
            if (userData[key] is Timestamp) {
              userData[key] = (userData[key] as Timestamp).millisecondsSinceEpoch;
            }
          });

          //print("After conversion: $userData david");

          _conversationUsers.add(types.User.fromJson(userData as Map<String, dynamic>));
          print(_users);
        }
      });
    }
  }

  Future<types.User> fetchUserObject(String userId) async{
    final users = await FirebaseChatCore.instance.users().first;
    setState(() {
      _users.clear();
      _users.addAll(users);
    });
    for(var x in _users){
      if(userId == x.id) {
        otherUserObject = x;
      }
    }
    return otherUserObject;
  }

  void fetchUserIds() async {
    await _loadMatches();
      // Retrieve all user objects as a list
      try {
        final users = await FirebaseChatCore.instance.users().first; // Assuming it's a stream and taking the first snapshot of data.
        setState(() {
          _users.clear();
          _users.addAll(users);
          print(_users);
        });
      } catch (e) {
        print("Error loading users: $e");
      }

      for(var x in _users){
        if(_matches.first['userId'].toString() == x.id) {
          _matchUsers.add(x);
        }
      }
      print(_matchUsers);
  }


  void _createRoomFromMatch(String userId) async {
    final Users = await FirebaseChatCore.instance.users().toList();
    print("Current map entries: ${roomManager.userRoomMap.entries}");
    // Fetch the roomId using the userId from the map
    String? roomId = roomManager.userRoomMap[userId];
    if (roomId != null && roomId.isNotEmpty) {
      print('Room ID is not empty: $roomId');
      // Room exists, fetch the room object using roomId

      _createRoom(await fetchUserObject(userId));
    } else {
      print("No room found with user ID $userId, attempting to create one.");
      FirebaseFirestore.instance.collection('users').doc(userId).get().then((userDoc) {
        if (userDoc.exists) {
          var userData = userDoc.data()!;
          print("Before conversion: $userData"); // Log data before conversion

          // Convert all Timestamps to milliseconds since epoch correctly
          userData['createdAt'] = userData['createdAt'] is Timestamp ? (userData['createdAt'] as Timestamp).millisecondsSinceEpoch : DateTime.now().millisecondsSinceEpoch;
          userData['updatedAt'] = userData['updatedAt'] is Timestamp ? (userData['updatedAt'] as Timestamp).millisecondsSinceEpoch : DateTime.now().millisecondsSinceEpoch;
          userData['lastSeen'] = userData['lastSeen'] is Timestamp ? (userData['lastSeen'] as Timestamp).millisecondsSinceEpoch : DateTime.now().millisecondsSinceEpoch;

          print("After conversion: $userData"); // Log data after conversion

          try {
            final user = types.User.fromJson(userData);
            FirebaseChatCore.instance.createRoom(user).then((room) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChatRoomPage(room: room),
              ));
            }).catchError((error) {
              print("Failed to create room: $error");
            });
          } catch (e) {
            print("Error creating user from data: $e");
          }
        } else {
          print("No user found for ID: $userId"); // Log if no user document found
        }
      }).catchError((error) {
        print("Error fetching user document: $error");
      });
    }
  }





  @override
  void initState() {
    super.initState();
    _loadMatches();
    roomManager.fetchUserRooms();
    _loadUsersWithConversations();
    fetchUserIds();
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
            height: MediaQuery
                .of(context)
                .size
                .height / 6, // 1/4th of the screen height
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _matches.length,
              itemBuilder: (context, index) {
                final matchId = _matches[index]['userId']; // Ensure you store userId in _loadMatches
                return GestureDetector(
                  onTap: () async { _createRoom(await fetchUserObject(matchId));},
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 3,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Expanded(
                            child: _matches[index]['imageUrl'] != null
                                ? Image.network(
                                _matches[index]['imageUrl'], fit: BoxFit.cover)
                                : Container(color: Colors.grey,
                                alignment: Alignment.center,
                                child: Text('No Image')),
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
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _conversationUsers.length,
                itemBuilder: (context, index) {
                  final userId = _conversationUsers[index].firstName;
                  return ListTile(
                      title: Text(userId!),
                      onTap: () async{
                        // Handle tap event if needed
                        _createRoom(await fetchUserObject(_conversationUsers[index].id));
                      });}),
          ),
        ],
      ),
    );
  }}


