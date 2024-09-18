import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PetProfileScreen extends StatefulWidget {
  static const String id = 'PetProfileScreen';
  final String ticketNumber;
  final String userId;
  final String usernationality;
  final String username;
  final String userfavorite;
  final String useremail;
  final String phoneNumber;
  final String weight;
  final String status;
  final String sex;
  final String name;
  final String about;
  final String age;
  final String category;
  final String color;
  final String? imageURL;
  final String health;
  final String petuuid;

  const PetProfileScreen({
    Key? key,
    required this.health,
    required this.imageURL,
    required this.color,
    required this.category,
    required this.age,
    required this.about,
    required this.name,
    required this.sex,
    required this.status,
    required this.weight,
    required this.phoneNumber,
    required this.ticketNumber,
    required this.userId,
    required this.usernationality,
    required this.username,
    required this.userfavorite,
    required this.useremail,
    required this.petuuid,
  }) : super(key: key);

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset(
                        "images/BackButton.png",
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Spacer with 10 pixels width
                  IconButton(
                    onPressed: () {
                      _launchPhone(widget.phoneNumber);
                    },
                    icon: Image.asset(
                      'images/phone.png',
                      width: 24, // Adjust width to a suitable size
                      height: 24, // Adjust height to a suitable size
                    ),
                  ),
                ],
              ),

            ),
            Container(
              width: 340,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.transparent,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child:   Image.network(
                  widget
                      .imageURL!,
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                ),
              ),
              // CircleAvatar(
              //   radius: 18,
              //   backgroundColor:
              //   Colors.transparent,
              //   child: booking.CUSTOMERrofileImageUrl !=
              //       null &&
              //       booking
              //           .CUSTOMERrofileImageUrl!
              //           .isNotEmpty
              //       ? ClipOval(
              //     child:
              //     Image.network(
              //       booking
              //           .CUSTOMERrofileImageUrl!,
              //       width: 36,
              //       height: 36,
              //       fit: BoxFit.cover,
              //     ),
              //   )
              //       : Image.asset(
              //     'images/blank_img.png',
              //     width: 36,
              //     height: 36,
              //     fit: BoxFit.cover,
              //   ),
              // ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28.0, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.name} ',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        '${widget.sex} ',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: Color(0XFFC9C9CB),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10, top: 10),
                              width: 145,
                              height: 165,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: const Color(0XFFE5E7EB),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/age.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Age',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${widget.weight} Month',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10, top: 10),
                              width: 145,
                              height: 165,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: const Color(0XFFE5E7EB),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/weight.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Weight',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${widget.weight} Kg',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10, top: 10),
                              width: 145,
                              height: 165,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: const Color(0XFFE5E7EB),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/vaccine.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    '${widget.health} ',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Yes',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'About ${widget.name} ',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${widget.about} ',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            color: Color(0XFFC9C9CB),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     SizedBox(
                      //       width: 284,
                      //       height: 55,
                      //       child: ElevatedButton(
                      //         style: ElevatedButton.styleFrom(
                      //           backgroundColor: const Color(0XFF57419D),
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(15),
                      //           ),
                      //         ),
                      //         onPressed: () {},
                      //         // child: Row(
                      //         //   mainAxisAlignment: MainAxisAlignment.center,
                      //         //   children: [
                      //         //     Image.asset(
                      //         //       'images/pawss.png',
                      //         //       width: 20,
                      //         //       height: 17,
                      //         //     ),
                      //         //     SizedBox(
                      //         //       width: 15,
                      //         //     ),
                      //         //     const Text(
                      //         //       'Adopt Me',
                      //         //       style: TextStyle(
                      //         //         fontFamily: 'poppins',
                      //         //         color: Colors.white,
                      //         //         fontSize: 14,
                      //         //       ),
                      //         //     ),
                      //         //   ],
                      //         // ),
                      //       ),
                      //     ),
                      //     // IconButton(
                      //     //   onPressed: () {
                      //     //     _launchPhone(widget.phoneNumber);
                      //     //   },
                      //     //   icon: Image.asset(
                      //     //     'images/phone.png',
                      //     //     width: 23,
                      //     //     height: 23,
                      //     //   ),
                      //     // ),
                      //   ],
                      // )

                    ],
                  ),

                ),
              ],

            )
          ],
        ),
      ),
    );
  }
  _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching phone: $e');
    }
  }
}
