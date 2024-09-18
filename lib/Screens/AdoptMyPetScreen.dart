import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:petly/Screens/Home_Screen.dart';
import 'package:uuid/uuid.dart';

import 'navigationbarbottom.dart';


class AdoptMyPetScreen extends StatefulWidget {
  static const String id = 'AdoptMyPetScreen';

  @override
  State<AdoptMyPetScreen> createState() => _AdoptMyPetScreenState();
}

class _AdoptMyPetScreenState extends State<AdoptMyPetScreen> {
  @override
  void initState() {
    super.initState();
    _colorController = TextEditingController();
    _categoryController = TextEditingController();
    _ageController = TextEditingController();
    _weightController = TextEditingController();
    _nameController = TextEditingController();
    _healthController = TextEditingController();
    _aboutController = TextEditingController();
    _sexEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _colorController.dispose();
    _categoryController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _nameController.dispose();
    _healthController.dispose();
    _aboutController.dispose();
    _sexEditingController.dispose();
    super.dispose();
  }

  String? _uploadedImage;
  TextEditingController _colorController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _healthController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();
  TextEditingController _sexEditingController = TextEditingController();

  String? _selectedColor;


  List<String> colors = [
    'Black',
    'Brown',
    'Grey',
    'Gold',
    'White',
    'Mix Grey White',
    'Light Brown',
  ];

  List<String> ageOptions = [
    '0-11 mos',
    '1-5 yrs',
    '6 yrs +',
  ];

  Widget _buildEditableTextField(String label,
      TextEditingController controller, {
        int? maxLines,
        TextInputType keyboardType = TextInputType.text,
        Color? color,
      }) {
    if (label == 'Color') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0XFF57419D),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: colors.map((String value) {
              bool isSelected = _selectedColor == value;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = value;
                    controller.text=value;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: _getGradientFromName(value),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                  ),
                  child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      );
    } else if (label == 'Category') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0XFF57419D),
            ),
          ),
          Row(
            children: [
              Radio<String>(
                value: 'Dog',
                groupValue: controller.text,
                onChanged: (value) {
                  setState(() {
                    controller.text = value!;
                  });
                },
              ),
              Text('Dog'),
              Radio<String>(
                value: 'Cat',
                groupValue: controller.text,
                onChanged: (value) {
                  setState(() {
                    controller.text = value!;
                  });
                },
              ),
              Text('Cat'),

            ],
          ),
        ],
      );
    } else if (label == 'Sex' || label == 'Age') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF57419D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (label == 'Sex')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Male',
                                groupValue: _sexEditingController.text,
                                onChanged: (value) {
                                  setState(() {
                                    controller.text = value!;
                                  });
                                },
                              ),
                              Text('Male'),
                            ],
                          ),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Female',
                                groupValue: _sexEditingController.text,
                                onChanged: (value) {
                                  setState(() {
                                    controller.text = value!;
                                  });
                                },
                              ),
                              Text('Female'),
                            ],
                          ),
                        ],
                      )
                    else
                      Column(
                        children: ageOptions.map((option) {
                          return Row(
                            children: [
                              Radio<String>(
                                value: option,
                                groupValue: controller.text,
                                onChanged: (value) {
                                  setState(() {
                                    controller.text = value!;
                                  });
                                },
                              ),
                              Text(option),
                            ],
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    } else if (label == 'Health') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0XFF57419D),
            ),
          ),
          Row(
            children: [
              Radio<String>(
                value: 'Vaccinated',
                groupValue: controller.text,
                onChanged: (value) {
                  setState(() {
                    controller.text = value!;
                  });
                },
              ),
              Text('Vaccinated'),
              Radio<String>(
                value: 'Not Vaccinated',
                groupValue: controller.text,
                onChanged: (value) {
                  setState(() {
                    controller.text = value!;
                  });
                },
              ),
              Text('Not Vaccinated'),
            ],
          ),
        ],
      );
    } else if (label == 'Weight') {
      double weightValue = 0.0;
      if (controller.text.isNotEmpty) {
        weightValue = double.parse(controller.text);
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0XFF57419D),
            ),
          ),
          Slider(
            value: weightValue,
            min: 0,
            max: 10,
            divisions: 100,
            onChanged: (newValue) {
              setState(() {
                controller.text = newValue.toStringAsFixed(1);
              });
            },
          ),
          Text(
            '${controller.text} kg',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      );
    } else if (label == 'About') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0XFF57419D),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: 'Important: Dog/Cat Breed,\nMy dog should have a night walk, \nat least once a day',
              hintStyle: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w400),
              border: OutlineInputBorder(),
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0XFF57419D),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: 'Enter $label',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      );
    }
  }

  Gradient? _getGradientFromName(String name) {
    switch (name) {
      case 'Black':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.black, Colors.black87],
        );
      case 'Brown':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.brown, Colors.brown[700]!],
        );
      case 'Grey':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [Colors.grey, Colors.grey],
        );
      case 'Gold':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xffad9c00), Color(0xFFFFB90F)],
        );
      case 'White':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey[200]!],
        );
      case 'Mix Grey White':
        return LinearGradient(
          colors: [Colors.grey[800]!, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        );
      case 'Light Brown':
        return LinearGradient(
          colors: [Colors.brown[400]!, Colors.brown[100]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        );
      default:
        return null;
    }
  }


  void _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        // Upload the image to Firebase Storage
        Reference storageReference = FirebaseStorage.instance.ref().child('pet_images').child('${DateTime.now().millisecondsSinceEpoch}');
        await storageReference.putFile(File(pickedFile.path));

        // Get the download URL for the uploaded image
        String downloadURL = await storageReference.getDownloadURL();

        setState(() {
          _uploadedImage = downloadURL;
        });
      } catch (error) {
        print('Failed to upload image: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image')),
        );
      }
    }
  }

  void _adoptPet() async {
    // Validate form data before submission
    if (_sexEditingController.text.isEmpty ||
        _colorController.text.isEmpty ||
        _categoryController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _healthController.text.isEmpty ||
        _aboutController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not authenticated')),
      );
      return;
    }

    final maxSerialNumberRef = FirebaseFirestore.instance
        .collection('max_serial_number')
        .doc('max_serial_number');

    // Get the current maximum serial number
    final maxSerialNumberDoc = await maxSerialNumberRef.get();
    int maxSerialNumber =
    maxSerialNumberDoc.exists ? maxSerialNumberDoc.data()!['value'] : 0;

    // Increment the max serial number and update it in the database
    maxSerialNumber++;
    await maxSerialNumberRef.set({'value': maxSerialNumber});

    // Get the reference to the document containing the current ticket number
    final currentTicketNumberRef = FirebaseFirestore.instance
        .collection('current_ticket_number')
        .doc('current_ticket_number');

    // Get the current ticket number
    final currentTicketNumberDoc = await currentTicketNumberRef.get();
    int currentTicketNumber = currentTicketNumberDoc.exists
        ? currentTicketNumberDoc.data()!['value']
        : 0;

    // Update the current ticket number in the database
    currentTicketNumber++;
    await currentTicketNumberRef.set({'value': currentTicketNumber});
    String petuuid = Uuid().v4();

    final userDocSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    // Check if the user document exists
    if (userDocSnapshot.exists) {
      // Extract user details from the document
      String username = userDocSnapshot.get('username');
      String useremail = userDocSnapshot.get('useremail');
      String phoneNumber = userDocSnapshot.get('phoneNumber');
      String nationality = userDocSnapshot.get('nationality');

      try {
        // Add Firestore document with pet details
        await FirebaseFirestore.instance
            .collection('adopt_my_pet')
            .doc(petuuid) // Set the document ID to the generated UUID
            .set({
          'userId': user.uid,
          'animal-sex': _sexEditingController.text,
          'animal-color': _selectedColor,
          'animal-category': _categoryController.text,
          'animal-age': _ageController.text,
          'animal-weight': _weightController.text,
          'animal-name': _nameController.text,
          'animal-health': _healthController.text,
          'animal-about': _aboutController.text,
          'animal-imageURL': _uploadedImage,
          'animal-petuuid': petuuid,
          'animal-status': 'waiting',
          'ticketNumber': currentTicketNumber,
          'serialNumber': maxSerialNumber,
          'username': username,
          'useremail': useremail,
          'phoneNumber': phoneNumber,
          'usernationality': nationality,
          'userfavorite': nationality,


        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pet adoption request submitted successfully')),
        );

        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Navigation_Bar(),
          ),
        );
      } catch (error) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit pet adoption request')),
        );
        print(error);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adopt My Pet',
          style:GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 19,
              color: Color(0XFF57419D),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _uploadImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: _uploadedImage != null
                    ? Image.network(
                  _uploadedImage!,
                  fit: BoxFit.cover,
                )
                    : Center(
                  child: Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildEditableTextField('Name', _nameController),
            SizedBox(height: 20),
            _buildEditableTextField('Category', _categoryController),
            SizedBox(height: 20),
            _buildEditableTextField('Color', _colorController),
            SizedBox(height: 20),
            _buildEditableTextField('Age', _ageController),
            SizedBox(height: 20),
            _buildEditableTextField('Sex', _sexEditingController),
            SizedBox(height: 20),
            _buildEditableTextField('Weight', _weightController),
            SizedBox(height: 20),
            _buildEditableTextField('Health', _healthController),
            SizedBox(height: 20),
            _buildEditableTextField('About', _aboutController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                _adoptPet();
              },
              child: Text(
                'Adopt My Pet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0XFF57419D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                minimumSize: Size(double.infinity, 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
