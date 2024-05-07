import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'add_data.dart'; // Make sure this import is correct
import 'register_screen_2.dart';

class RegisterScreen1 extends StatefulWidget {
  const RegisterScreen1({super.key});

  @override
  State<RegisterScreen1> createState() => _RegisterScreen1State();
}

class _RegisterScreen1State extends State<RegisterScreen1> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _image;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BeReal Dating'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image != null)
              Image.memory(_image!, height: 300),
            if (_isUploading)
              const CircularProgressIndicator(),
            ElevatedButton(
              onPressed: () => pickImage(),
              child: const Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: _image != null ? () => uploadImage() : null,
              child: const Text('Upload and Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();
        setState(() {
          _image = imageBytes;
        });
      }
    } catch (e) {
      print("Failed to pick image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }


  Future<void> uploadImage() async {
    setState(() {
      _isUploading = true;
    });
    StoreData storeData = StoreData();
    String response = await storeData.saveData(file:_image!);
    if (response == 'success') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const RegisterPage2()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $response')),
      );
    }
    setState(() {
      _isUploading = false;
    });
  }
}


