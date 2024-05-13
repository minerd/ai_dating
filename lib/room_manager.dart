import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Correctly imported for user authentication

class RoomManager {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, String> userRoomMap = {};  // Map of other user's IDs to room IDs

  Future<void> fetchUserRooms() async {
    // Ensure there's a logged-in user
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print("No user logged in.");
      return;  // Exit if no user is logged in
    }

    String userId = currentUser.uid;
    try {
      // Query rooms where the current user is a participant
      QuerySnapshot snapshot = await firestore.collection('rooms')
          .where('userIds', arrayContains: userId)
          .get();

      // Iterate over each document found
      for (var doc in snapshot.docs) {
        List<dynamic> userIds = doc['userIds'];  // Assume 'userIds' is a list of user IDs in the document
        // Find the other user's ID that isn't the current user's ID
        String otherUserId = userIds.firstWhere((id) => id != userId, orElse: () => ''); // Using an empty string for cases where no other user is found
        if (otherUserId.isNotEmpty) {
          userRoomMap[otherUserId] = doc.id;  // Map the other user's ID to the room ID
          print('Other User ID: $otherUserId, Room ID: ${doc.id}');  // Print each map entry
        }
      }

      // Optionally, print the entire map or the count of rooms fetched
      print("Fetched ${userRoomMap.length} rooms for user $userId.");
    } catch (error) {
      print("Failed to fetch rooms: $error");
    }
  }
}
