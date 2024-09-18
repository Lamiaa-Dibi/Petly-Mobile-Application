import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petly/Screens/AdoptMyPetScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/Login_Screen.dart';
import 'Screens/NewestPetScreen.dart';
import 'Screens/PetProfileScreen.dart';
import 'Screens/SignUp_Screen.dart';
import 'package:petly/Screens/onBoard_Screen.dart';
import 'Screens/navigationbarbottom.dart';
import 'Screens/lists/NewestPetScreennew.dart';
import 'Screens/UserProfileScreen.dart';
import 'Screens/Splash_Screen.dart';
import 'Screens/lists/homeeeeeeeeee.dart';
import 'Screens/newSignup.dart';
import 'models/favouriteProvider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  bool isLoggedIn = await checkLoginStatus();

  String initialRoute = isLoggedIn ? Navigation_Bar.id : LoginScreen.id;

  runApp(ChangeNotifierProvider(
      create: (context) => FavoriteProvider(),
      child:
      Petly(initialRoute: initialRoute)
  ));
}

Future<bool> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  return isLoggedIn;
}

class Petly extends StatelessWidget {
  final String initialRoute;

  const Petly({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Splash_Screen.id,
      routes: {
        Navigation_Bar.id: (context) => Navigation_Bar(),
        onBoard_Screen.id: (context) => onBoard_Screen(),
        Splash_Screen.id: (context) => Splash_Screen(initialRoute: 'onBoard_Screen'),
        NewestPetScreen.id: (context) => NewestPetScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        UserProfileScreen.id: (context) => UserProfileScreen(email: 'email'),
        // PetProfileScreen.id: (context) => PetProfileScreen(),
        New_Signup.id: (context) => New_Signup(),
        NewestPetScreennew.id: (context) => NewestPetScreennew(),
        homeeeeeeeeee.id: (context) => homeeeeeeeeee(),
      },
    );
  }
}
