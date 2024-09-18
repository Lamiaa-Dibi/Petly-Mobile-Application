import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'navigationbarbottom.dart';

class EditUserProfileScreen extends StatefulWidget {
  static const String id = 'UserProfileScreen';
  final String email;

  const EditUserProfileScreen({super.key, required this.email});

  @override
  _EditUserProfileScreenState createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  late SharedPreferences _prefs;
  late TextEditingController _phoneNumberController;
  late TextEditingController _nationalityController;
  late TextEditingController _usernameController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File? _profileImage;
  String _username = "";
  String _userNumber = "";
  String _nationality = "";
  String? _imageUrl; // Add this to store the image URL from Firestore
  bool _isEditing = false;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    _usersCollection = FirebaseFirestore.instance.collection('users');
    _initializeControllers();
    _initializePreferences();
    _fetchUserData(); // Fetch the user data when initializing
    _isEditing = true;
  }

  void _initializeControllers() {
    _usernameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _nationalityController = TextEditingController();
  }

  Future<void> _fetchUserData() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      DocumentSnapshot userDoc = await _usersCollection.doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _username = userData['username'] ?? '';
          _userNumber = userData['phoneNumber'] ?? '';
          _nationality = userData['nationality'] ?? '';
          _usernameController.text = _username;
          _phoneNumberController.text = _userNumber;
          _nationalityController.text = _nationality;
          _imageUrl = userData['profileImageUrl']; // Store the image URL
        });
      }
    }
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

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = _prefs.getString('username') ?? '';
      _userNumber = _prefs.getString('userNumber') ?? '';
      _nationality = _prefs.getString('nationality') ?? '';
      _phoneNumberController.text = _userNumber;
      _nationalityController.text = _nationality;
      _usernameController.text = _username;
    });
  }

  Future<void> _saveUserData() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      String? downloadUrl;
      if (_profileImage != null) {
        try {
          final storageRef = firebase_storage.FirebaseStorage.instance.ref().child('profile_images').child('$userId.jpg');
          await storageRef.putFile(_profileImage!);
          downloadUrl = await storageRef.getDownloadURL();
        } catch (error) {
          print('Error uploading image: $error');
        }
      }

      await _usersCollection.doc(userId).set({
        'username': _usernameController.text,
        'phoneNumber': _phoneNumberController.text,
        'nationality': _nationalityController.text,
        'profileImageUrl': downloadUrl ?? _imageUrl, // Use existing URL if new image not uploaded
        'useremail': widget.email,
      });

      _prefs.setString('username', _usernameController.text);
      _prefs.setString('phoneNumber', _phoneNumberController.text);
      _prefs.setString('nationality', _nationalityController.text);
    } else {
      print('Error: User ID is null.');
    }
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
      Navigator.push(
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
    return _username.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _nationalityController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: Color(0XFF808083),
                      fontFamily: 'poppins',
                      fontSize: 16,
                    ),
                  ),
                ),
                const Spacer(),
                // const Text(
                //   'Edit Profile',
                //   style: TextStyle(
                //     color: Colors.black,
                //     fontFamily: 'Archivoblack',
                //     fontSize: 18,
                //   ),
                // ),
                const Spacer(),
                // TextButton(
                //   onPressed: () {
                //     saveUserData();
                //
                //   },
                //   child: const Text(
                //     'Save',
                //     style: TextStyle(
                //       color: Color(0XFF248DFE),
                //       fontFamily: 'poppins',
                //       fontSize: 16,
                //     ),
                //   ),
                // ),
              ],
            ),
            const Text(
              'Edit Your Profile!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Color(0XFF57419D),
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
                        : _imageUrl != null
                        ? NetworkImage(_imageUrl!)
                        : AssetImage('assets/default_profile.png') as ImageProvider, // Provide a default image
                  ),
                  if (_profileImage == null && _imageUrl == null)
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
              _username = value;
            }),
            SizedBox(height: 20),
            _buildTextField("Phone Number", _phoneNumberController, (value) {
              _userNumber = value;
            }),
            SizedBox(height: 20),
            _buildTextField("Nationality", _nationalityController, (value) {
              _nationality = value;
            }),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: ElevatedButton(
                onPressed: _nextButtonPressed,
                child: Text('Next', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0XFF57419D),
                ),
              ),
            ),
          ],
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
          keyboardType: TextInputType.text,
          textDirection: TextDirection.ltr,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
