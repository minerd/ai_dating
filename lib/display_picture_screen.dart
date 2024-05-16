import 'dart:io';
import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final bool isRearCamera;
  final VoidCallback retakePicture;
  final VoidCallback nextPicture;

  const DisplayPictureScreen({
    required this.imagePath,
    required this.isRearCamera,
    required this.retakePicture,
    required this.nextPicture,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display Picture')),
      body: Column(
        children: [
          Expanded(child: Image.file(File(imagePath))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: retakePicture,
                child: Text('Retake'),
              ),
              ElevatedButton(
                onPressed: nextPicture,
                child: Text(isRearCamera ? 'Next' : 'Finish'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
