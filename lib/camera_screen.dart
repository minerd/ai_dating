import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'display_picture_screen.dart';
import 'review_picture_screen.dart';

class CameraScreen extends StatefulWidget {
  final bool isRetake;
  final bool isRetakeFront;

  const CameraScreen({this.isRetake = false, this.isRetakeFront = true});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription>? cameras;
  CameraController? controller;
  Future<void>? _initializeControllerFuture;
  bool isRearCamera = true;
  String? frontImagePath;
  String? backImagePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (widget.isRetake) {
      // Set the camera based on whether we're retaking the front or back image
      isRearCamera = !widget.isRetakeFront;
    }
    _setCamera(isRearCamera ? cameras!.first : cameras!.last);
  }

  void _setCamera(CameraDescription camera) {
    controller = CameraController(camera, ResolutionPreset.high);
    setState(() {
      _initializeControllerFuture = controller!.initialize();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      final directory = await getApplicationDocumentsDirectory();
      final imagePath = join(directory.path, '${DateTime.now()}.png');

      XFile picture = await controller!.takePicture();
      await File(picture.path).copy(imagePath); // Save the image to the desired path

      if (isRearCamera) {
        backImagePath = imagePath;
        isRearCamera = false;
      } else {
        frontImagePath = imagePath;
        isRearCamera = true;
      }

      if (widget.isRetake) {
        // Navigate back to the review screen with updated images
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ReviewPicturesScreen(
            frontImagePath: frontImagePath!,
            backImagePath: backImagePath!,
          ),
        ));
      } else {
        if (frontImagePath != null && backImagePath != null) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ReviewPicturesScreen(
              frontImagePath: frontImagePath!,
              backImagePath: backImagePath!,
            ),
          ));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DisplayPictureScreen(
              imagePath: imagePath,
              isRearCamera: isRearCamera,
              retakePicture: _retakePicture,
              nextPicture: _nextPicture,
            ),
          ));
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void _retakePicture() {
    Navigator.of(context).pop();
    _takePicture();
  }

  void _nextPicture() {
    Navigator.of(context).pop();
    _setCamera(isRearCamera ? cameras!.first : cameras!.last);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Positioned.fill(
                  child: CameraPreview(controller!),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: FloatingActionButton(
                    onPressed: _takePicture,
                    child: Icon(Icons.camera),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
