import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'notification_service.dart';



class ThemePage extends StatefulWidget {
  final NotificationService notificationService; // Add this line

  const ThemePage({Key? key, required this.notificationService}) : super(key: key);

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  themeColor _themeChoice = themeColor.blue;
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _videoGamesController = TextEditingController();
  final TextEditingController _zodiacController = TextEditingController();
  final TextEditingController _lookingForController = TextEditingController();
  final TextEditingController _loveStyleController = TextEditingController();
  final TextEditingController _personalityTypeController = TextEditingController();
  final TextEditingController _petController = TextEditingController();
  final TextEditingController _drinkingController = TextEditingController();
  final TextEditingController _smokingController = TextEditingController();
  final TextEditingController _cannabisController = TextEditingController();
  final TextEditingController _workoutController = TextEditingController();
  final TextEditingController _sleepingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _nameController.dispose();
    _videoGamesController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        _ageController.text = userData['age'].toString() ?? '';
        _heightController.text = userData['height'].toString() ?? '';
        _nameController.text = userData['name'].toString() ?? '';
        _videoGamesController.text = userData['video_games'] ?? '';
        _zodiacController.text = userData['zodiac'] ?? '';
        _lookingForController.text = userData['looking_for'] ?? '';
        _loveStyleController.text = userData['love_style'] ?? '';
        _personalityTypeController.text = userData['personality_type'] ?? '';
        _petController.text = userData['pet'] ?? '';
        _drinkingController.text = userData['drinking'] ?? '';
        _smokingController.text = userData['smoking'] ?? '';
        _cannabisController.text = userData['cannabis'] ?? '';
        _workoutController.text = userData['workout'] ?? '';
        _sleepingController.text = userData['sleep'] ?? '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ExpansionTile(
            title: Text('Modify Themes', style: TextStyle(fontFamily: 'sfPro', fontWeight: FontWeight.bold)),
            initiallyExpanded: false,  // Start with the tile collapsed
            children: <Widget>[
              _buildThemeListTile('Blue', Colors.blue, themeColor.blue),
              _buildThemeListTile('Red', Colors.red, themeColor.red),
              _buildThemeListTile('Green', Colors.green, themeColor.green),
              _buildThemeListTile('Purple', Colors.purple, themeColor.purple),
              _buildThemeListTile('Pink', Colors.pink, themeColor.pink),
              _buildThemeListTile('Yellow', Colors.yellow, themeColor.yellow),
              _buildThemeListTile('Orange', Colors.orange, themeColor.orange),
              _buildThemeListTile('Brown', Colors.brown, themeColor.brown),
              _buildThemeListTile('Grey', Colors.grey, themeColor.grey),
            ],
          ),
          _editProfileField('Age', _ageController),
          _editProfileField('Height', _heightController),
          _editProfileField('Name', _nameController),
          _editProfileField('Video Games', _videoGamesController),
          _buildExpansionTile('Age', ['18', '19', '20', '21', '22','23','24','25','26','27'], _ageController),
          _buildExpansionTile('Zodiac', ['Taurus','Gemini','Cancer','Leo','Virgo','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces','Aries','Libra'],_zodiacController),
          _buildExpansionTile('Looking For', ['Monogamy','Not Sure', 'Short Term Fun'],_lookingForController),
          _buildExpansionTile('Love Style', ['Touch','Gifts','Thoughtful Gestures','Quality Time','Words of Affirmation'],_loveStyleController),
          _buildExpansionTile('Personality Type', [
            'ISTJ', 'ISFJ', 'INFJ', 'INTJ', // Introverted, Intuitive
            'ISTP', 'ISFP', 'INFP', 'INTP', // Introverted, Perceiving
            'ESTP', 'ESFP', 'ENFP', 'ENTP', // Extroverted, Perceiving
            'ESTJ', 'ESFJ', 'ENFJ', 'ENTJ'  // Extroverted, Judging
          ],_personalityTypeController),
          _buildExpansionTile('Pets', ['Dog','Cat','Lizard','Mouse','Fish','Dog','Reptile'],_petController),
          _buildExpansionTile('Drinking', ['Sober Curious','Often','On Weekends','Never'],_drinkingController),
          _buildExpansionTile('Smoking', ['Often','Sometimes','Never'],_smokingController),
          _buildExpansionTile('Cannabis',['Often','Sometimes','Never'],_cannabisController),
          _buildExpansionTile('Workout',['Often','Sometimes','Never'],_workoutController),
          _buildExpansionTile('Sleeping Habits', ['Early Bird','Normal','Night Owl'],_sleepingController),
          ListTile(
            title: const Center(child: Text('Update Profile', style: TextStyle(color: Colors.blue))),
            onTap: _updateUserProfile,
          ),
          ListTile(
            title: const Center(child: Text('Delete Account', style: TextStyle(color: Colors.red))),
            onTap: _confirmDeleteAccount,
          ),
          ListTile(
            title: const Center(child: Text('Sign Out', style: TextStyle(color: Colors.teal))),
            onTap: _signOut,
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile(String title, List<String> options, TextEditingController controller) {
    return ExpansionTile(
      title: Text(controller.text.isEmpty ? title : controller.text),
      children: options.map((String option) {
        return ListTile(
          title: Text(option),
          onTap: () {
            setState(() {
              controller.text = option; // Set the selected option to the controller
            });
          },
        );
      }).toList(),
    );
  }


  Widget _buildThemeListTile(String title, MaterialColor color, themeColor choice) {
    return ListTile(
      title: Text(title, style: TextStyle(color: color, fontFamily: 'sfPro')),
      trailing: Switch(
        value: _themeChoice == choice,
        onChanged: (bool newValue) {
          setState(() {
            _themeChoice = choice;  // Update the current theme choice
            theme = color[300]!;    // Update the global theme color variable
          });
          // Optionally, save the theme choice to persistent storage or user profile
          _updateUserThemeChoice(choice);
        },
      ),
    );
  }

  Future<void> _updateUserThemeChoice(themeColor choice) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'themeChoice': choice.toString(),
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Theme Updated Successfully')));
      } catch (e) {
        print('Failed to update theme choice: $e');
      }
    }
  }



  Widget _editProfileField(String label, TextEditingController controller) {
    return ListTile(
      title: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }

  Future<void> _updateUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'age': _ageController.text.trim(),
          'height': _heightController.text.trim(),
          'name': _nameController.text.trim(),
          'video_games': _videoGamesController.text.trim(),
          'zodiac':_zodiacController.text.trim(),
          'age_bounds': [],
          'looking_for': _lookingForController.text.trim(),
          'personality_type': _personalityTypeController.text.trim(),
          'love_style': _loveStyleController.text.trim(),
          'pets': _petController.text.trim(),
          'drinking': _drinkingController.text.trim(),
          'smoking': _smokingController.text.trim(),
          'video_games': _videoGamesController.text.trim(),
          'cannabis': _cannabisController.text.trim(),
          'workout': _workoutController.text.trim(),
          'sleeping_habits': _sleepingController.text.trim(),
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile Updated')));
      } catch (e) {
        _showErrorDialog('Failed to update profile: $e');
      }
    }
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Account"),
          content: Text("Are you sure you want to delete your account? This action cannot be undone."),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog first
                _deleteUserAccount();
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage(notificationService: widget.notificationService,)));
    } catch (e) {
      _showErrorDialog('Failed to sign out: $e');
    }
  }


  Future<void> _deleteUserAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
        await user.delete();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage(notificationService: widget.notificationService,)),
              (Route<dynamic> route) => false,
        );
      } catch (e) {
        _showErrorDialog('Failed to delete account: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx). pop();
            },
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }
}
