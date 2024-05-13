import 'dart:typed_data';
import 'package:ai_dating/home_page.dart';
import 'package:ai_dating/main.dart';
import 'package:ai_dating/add_data.dart';
import 'package:ai_dating/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ai_dating/text_field.dart';
import 'package:ai_dating/button.dart';
import 'package:ai_dating/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'tos.dart';
import 'register_screen_1.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;


class RegisterPage extends StatefulWidget {

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  List<String> registeredClasses= ['UConn Chat'];
  bool isLoading = false;
  late String imageUrl = '';
  Uint8List? _image;
  final _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadImageToStorage(String childName,Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }



  Future<Uint8List?> compressImage(Uint8List fileBytes) async {
    try {
      final Uint8List? result = await FlutterImageCompress.compressWithList(
        fileBytes,
        minWidth: 1080, // Adjust the settings as needed
        minHeight: 720,
        quality: 50, // Adjust the quality
      );
      return result;
    } catch (e) {
      print("Error compressing image: $e");
      return null;
    }
  }

  Future<String> saveData({
    required Uint8List file,
  }) async {
    String resp = "Some Error Occurred";
    try {
      // Compress the image first
      Uint8List? compressedFile = await compressImage(file);
      if (compressedFile != null) {
        String imageUrl = await uploadImageToStorage(FirebaseAuth.instance.currentUser!.uid, compressedFile);
        await _firestore.collection(emailTextController.text.toLowerCase()).add({
          'imageLink': imageUrl,
        });
        resp = 'success';
      } else {
        resp = "Image compression failed";
      }
    } catch (err) {
      resp = err.toString();
    }
    print(resp);
    return resp;
  }



  /*Future<String> saveData({
    required Uint8List file,
  }) async {
    String resp = " Some Error Occurred";
    try{
      String imageUrl = await uploadImageToStorage(emailTextController.text, file);
      await _firestore.collection(emailTextController.text).add({
        'imageLink': imageUrl,
      });

      resp = 'success';
      print(resp);
    }
    catch(err){
      resp =err.toString();
    }
    print (resp);
    return resp;
  }*/


  Future<void> getImageUrl () async {
    setState(() {
      isLoading = true;
    });
    try {
      final ref = _storage.ref().child(emailTextController.text);
      final url = await ref.getDownloadURL();
      setState(() {
        imageUrl = url;
        isLoading = false; // End loading
      });
    } catch (e) {
      print("Error fetching image URL: $e");
      setState(() {
        isLoading = false; // End loading even if there's an error
      });
    }
    print(imageUrl) ;
  }

  Future<Uint8List> convertImageToUint8List(String assetPath) async {
    // Create a File instance from the given file path
    // Load the image as byte data from the asset bundle
    ByteData data = await rootBundle.load(assetPath);

    // Convert the byte data to Uint8List
    return data.buffer.asUint8List();
  }


  void saveProfile() async {
    print('saving profile');
    //save profile
    setState(() {
      isLoading = true;
    });
    Uint8List? _image = await convertImageToUint8List('images/owl2.png');
    String resp = await saveData(
        file: _image
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
  }

  void signUp() async {
    // Show loading indicator
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Check if passwords match
    if (passwordTextController.text != confirmPasswordTextController.text) {
      Navigator.pop(context); // Dismiss loading indicator
      displayMessage("Passwords don't match");
      return;
    }

    // Show Terms of Service dialog
    bool? termsAgreed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Terms of Service"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(tos),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Disagree'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Agree'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (termsAgreed ?? false) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text,
        );

        // Add user data including terms_agreed
        saveProfile();

        await FirebaseChatCore.instance.createUserInFirestore(
          types.User(
            firstName: 'John',
            id: FirebaseAuth.instance.currentUser!.uid.toString(), // UID from Firebase Authentication
            imageUrl: '',
            lastName: 'Doe',
            createdAt: DateTime.now().millisecondsSinceEpoch.toInt(), // Current time in milliseconds
          ),
        );
        saveProfile();
        FirebaseFirestore.instance.collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'id': userCredential.user!.uid.toString(),
          'images': [],
          'age': '',
          'height': '',
          'location':'',
          'zodiac':'',
          'age_bounds': [],
          'distance bounds': '',
          'looking_for': '',
          'open_to': '',
          'family_plans': '',
          'personality_type': '',
          'communication_style': '',
          'love_style': '',
          'pets': '',
          'drinking': '',
          'smoking': '',
          'video_games': '',
          'cannabis': '',
          'workout': '',
          'Dietary Preference': '',
          'social_media': '',
          'sleeping_habits': '',
          'name': '',
          'likes': [],
          'likes_me': [],
          'terms_agreed': true, // Add terms_agreed field set to true

        },SetOptions(merge: true));

        if (context.mounted) {
          Navigator.pop(context); // Dismiss loading indicator
          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen1(),),);
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context); // Dismiss loading indicator
        displayMessage(e.code);
      }
    } else {
      Navigator.pop(context); // Dismiss loading indicator
      displayMessage("You must agree to the Terms of Service to use this app.");
    }
  }

  void displayMessage(String message){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  void goToSignInPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/owl2.png',
                    width: 200,
                    height: 200,
                  ),
                  Text("Let's create an Account for you!"),
                  const SizedBox(height: 25,),

                  MyTextField(controller: emailTextController, hintText: 'Email', obscureText: false,),

                  const SizedBox(height: 10,),

                  MyTextField(controller: passwordTextController, hintText: 'Password', obscureText: true),

                  const SizedBox(height: 10,),

                  MyTextField(controller: confirmPasswordTextController, hintText: 'Confirm Password', obscureText: true),

                  const SizedBox(height: 25,),
                  //sign in button
                  MyButton(onTap: signUp, text: 'Sign up',),

                  const SizedBox(height: 25,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?", style: TextStyle(fontFamily: 'sfPro', fontSize: 15),),
                      const SizedBox(width: 4,),
                      GestureDetector(
                        onTap: goToSignInPage,
                        child: const Text(
                          'Log in!',
                          style: TextStyle(
                            fontFamily: 'sfProBold',
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  )
                ],

              ),
            ),
          ),
        ),
      ),
    );
  }
}
