import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petly/Screens/Login_Screen.dart';
import 'package:petly/Screens/SignUp_Screen.dart';

import 'newSignup.dart';

class onBoard_Screen extends StatefulWidget {
  static const String id = 'onBoard_Screen';

  @override
  State<onBoard_Screen> createState() => _onBoard_ScreenState();
}

class _onBoard_ScreenState extends State<onBoard_Screen> {
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _pages = [
    {
      'color': '#57419D',
      'title': 'Adopt, do not shop',
      'image': 'images/img_3.png',
      'description': "Get Ready for Petastic Fun!",
      'skip': true
    },
    {
      'color': '#57419D',
      'title': 'Discover Pet Happiness Here!',
      'image': 'images/img_5.png',
      'description': 'Precious Paws, Priceless Love',
      'skip': true
    },
    {
      'color': '#57419D',
      'title': 'Let’s find you your Petly friend!',
      'image': 'images/esp3.jpg',
      'description': 'Match with a great pet that matches your charming personality',
      'skip': false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            itemBuilder: (BuildContext context, int index) {
              final page = _pages[index];
              return Container(
                color: hexToColor(page['color']),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      page['image'],
                      height: MediaQuery.of(context).size.height * 0.5 ,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                    SizedBox(height: 20),
                    Text(
                      page['title'],
                      style:GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        page['description'],
                        style:GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            top: 20,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, New_Signup.id);
              },
              child: Text(
                'Skip',
                style:GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_pageController.page!.toInt() == _pages.length - 1) {
                    Navigator.pushNamed(context, New_Signup.id);
                  } else {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  }
                },
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    color: Color(0XFF57419D),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color hexToColor(String hex) {
    assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex));
    return Color(int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xFF000000 : 0x00000000));
  }
}
