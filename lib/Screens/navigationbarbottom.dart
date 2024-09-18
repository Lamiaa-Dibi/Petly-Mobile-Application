import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:petly/Screens/FavoritesScreen.dart';
import 'package:petly/Screens/Home_Screen.dart';
import 'package:petly/Screens/PetListingScreen.dart';
import 'package:petly/Screens/SettingsScreen.dart';

import 'lists/homeeeeeeeeee.dart';


class Navigation_Bar extends StatefulWidget {
  const Navigation_Bar({Key? key, this.initialIndex = 0}) : super(key: key);
  static const String id = 'Navigation_Bar';
  final int initialIndex;

  @override
  State<Navigation_Bar> createState() => _Navigation_BarState();
}

class _Navigation_BarState extends State<Navigation_Bar> {
  late int _index;
  final List<Widget> _screens = [
    homeeeeeeeeee(),
    FavoritesScreen(),
    PetListingScreen(),
    Settings_Screen(),
  ];

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _screens[_index],
        bottomNavigationBar: NavigationBarBottom(
          currentIndex: _index,
          onTap: (int newIndex) {
            _navigateToScreen(newIndex);
          },
        ),
      ),
    );
  }

  void _navigateToScreen(int newIndex) {
    setState(() {
      _index = newIndex;
    });
  }
}

class NavigationBarBottom extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  NavigationBarBottom({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  _NavigationBarBottomState createState() => _NavigationBarBottomState();
}

class _NavigationBarBottomState extends State<NavigationBarBottom> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar(
      icons: [
        widget.currentIndex == 0 ? Icons.home : Icons.home_outlined,
        widget.currentIndex == 1 ? Icons.favorite : Icons.favorite_outline_outlined,
        widget.currentIndex == 2 ? Icons.list_alt : Icons.list_alt_outlined,
        widget.currentIndex == 3 ? Icons.settings : Icons.settings_outlined,
      ],
      activeIndex: widget.currentIndex,
      gapLocation: GapLocation.none,
      notchSmoothness: NotchSmoothness.softEdge,
      onTap: widget.onTap,
      activeColor: Color(0XFF57419D), // Set the active icon color
      inactiveColor: Color(0XFF57419D), // Set the inactive icon color
    );
  }
}
