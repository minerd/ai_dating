import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'camera_screen.dart';

class ReviewPicturesScreen extends StatelessWidget {
  final String frontImagePath;
  final String backImagePath;

  const ReviewPicturesScreen({
    required this.frontImagePath,
    required this.backImagePath,
  });

  Future<void> _uploadPictures() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      await docRef.update({
        'images': FieldValue.arrayUnion([frontImagePath, backImagePath]),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Review Pictures')),
      body: Column(
        children: [
          Expanded(
            child: Image.file(File(frontImagePath)),
          ),
          Expanded(
            child: Image.file(File(backImagePath)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CameraScreen(isRetake: true, isRetakeFront: false),
                  ));
                },
                child: Text('Retake Front'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CameraScreen(isRetake: true, isRetakeFront: true),
                  ));
                },
                child: Text('Retake Back'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _uploadPictures();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Pictures uploaded successfully!'),
                  ));
                },
                child: Text('Upload'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
