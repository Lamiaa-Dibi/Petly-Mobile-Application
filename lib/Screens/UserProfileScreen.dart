import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';

import 'navigationbarbottom.dart';

class UserProfileScreen extends StatefulWidget {
  static const String id = 'UserProfileScreen';
  final String email;

  const UserProfileScreen({Key? key, required this.email}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late SharedPreferences _prefs;
  late TextEditingController _phoneNumberController;
  late TextEditingController _nationalityController;
  late TextEditingController _usernameController;
  File? _profileImage;
  bool _isEditing = true;
  late CollectionReference _usersCollection;

  @override
  void initState() {
    super.initState();
    _usersCollection = FirebaseFirestore.instance.collection('users');
    _initializeControllers();
    _initializePreferences();
  }

  void _initializeControllers() {
    _usernameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _nationalityController = TextEditingController();
  }

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = _prefs.getString('username') ?? '';
      _phoneNumberController.text = _prefs.getString('userNumber') ?? '';
      _nationalityController.text = _prefs.getString('nationality') ?? '';
    });
  }

  Future<String?> uploadImageToFirebase(File imageFile, String userId) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$userId.jpg');

      await ref.putFile(imageFile);
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return null;
    }
  }

  Future<void> _saveUserData() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      if (_profileImage != null) {
        try {
          final storageRef = firebase_storage.FirebaseStorage.instance
              .ref()
              .child('profile_images')
              .child('$userId.jpg');

          await storageRef.putFile(_profileImage!);
          final downloadUrl = await storageRef.getDownloadURL();

          await _usersCollection.doc(userId).set({
            'username': _usernameController.text,
            'phoneNumber': _phoneNumberController.text,
            'nationality': _nationalityController.text,
            'profileImageUrl': downloadUrl,
            'useremail': widget.email,
          });
        } catch (error) {
          print('Error uploading image: $error');
        }
      } else {
        print('No profile image selected.');
      }
    } else {
      print('Error: User ID is null.');
    }

    _prefs.setString('username', _usernameController.text);
    _prefs.setString('userNumber', _phoneNumberController.text);
    _prefs.setString('nationality', _nationalityController.text);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _profileImage = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _nextButtonPressed() {
    if (_areFieldsFilled()) {
      _saveUserData();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Navigation_Bar(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all the fields.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool _areFieldsFilled() {
    return _usernameController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _nationalityController.text.isNotEmpty &&
        _profileImage != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Set Up Your Profile!',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color(0XFF57419D),
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.transparent,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                    ),
                    if (_profileImage == null)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.grey.withOpacity(0.7),
                          ),
                          Text(
                            'Upload your picture',
                            style: TextStyle(
                              color: Colors.grey.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              _buildTextField("Name", _usernameController, (value) {
                setState(() {
                  _usernameController.text = value;
                });
              }),
              SizedBox(height: 20),
              _buildTextField("Phone Number", _phoneNumberController, (value) {
                setState(() {
                  _phoneNumberController.text = value;
                });
              }),
              SizedBox(height: 20),
              _buildTextField("Nationality", _nationalityController, (value) {
                setState(() {
                  _nationalityController.text = value;
                });
              }),
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: ElevatedButton(
                  onPressed: _nextButtonPressed,
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFF57419D),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, Function(String) onChanged) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Color(0XFF57419D),
          width: 2,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          enabled: _isEditing,
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          keyboardType: label == "Phone Number" ? TextInputType.number : TextInputType.text,
          inputFormatters: label == "Phone Number"
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
