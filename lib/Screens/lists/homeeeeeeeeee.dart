import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petly/Screens/AdoptMyPetScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/locationService.dart';
import '../../models/favouriteProvider.dart';
import '../NewestPetScreen.dart';
import '../FilterDialog.dart';
import '../PetProfileScreenHomeScreen.dart';
import '../navigationbarbottom.dart';
import 'AdoptMyPetCat.dart';
import 'AdoptMyPetDog.dart';
import 'NewestPetScreennew.dart';
final user = FirebaseAuth.instance.currentUser;
final uid = user?.uid;

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
late String global_lat;
late String global_long;
late String global_country;
late String global_adminArea;
late String global_postalcode;
late String global_adress;
late String global_district;
late String global_currentUser;
class homeeeeeeeeee extends StatefulWidget {
  static const String id = 'homeeeeeeeeee';
  List<dynamic>? filteredPets;
  String? category;
  homeeeeeeeeee({super.key, this.filteredPets,this.category});



  @override
  State<homeeeeeeeeee> createState() => _homeeeeeeeeeeState();
}

class _homeeeeeeeeeeState extends State<homeeeeeeeeee> {
  late final dynamic pet;
  String selectedCity = 'Istanbul';
  String? _country;
  String? _district;
  String? _adminArea;





  List<String> categories = ['Cats', 'Dogs'];
  late String category;

  Set<String> selectedColors = {};
  double selectedWeight = 25.0;
  double selectedAge = 25.0;
  String selectedBreed = '';
  List<dynamic> chosenPets=[];

  List<AdoptMyPetCat> cats = [];
  List<AdoptMyPetDog> dogs = [];

  @override
  void initState() {
    super.initState();
    category=widget.category?? 'Cats';
    loadSelectedColors();
    loadPets();
    _usersCollection = FirebaseFirestore.instance.collection('users');
    _fetchUserData();
    getLocation();

  }
  late CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> _fetchUserData() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      DocumentSnapshot userDoc = await _usersCollection.doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _adminArea = userData['adminArea']; // Store the country
          _district = userData['district']; // Store the country

          _country = userData['country']; // Store the country
        });
      }
    }
  }

  void getLocation() async {
    final service = LocationService();
    final locationData = await service.getLocation();
    if (locationData != null) {
      final placeMark = await service.getPlaceMark(locationData: locationData);
      setState(() {
        global_lat = locationData.latitude!.toStringAsFixed(2);
        global_long = locationData.longitude!.toStringAsFixed(2);
        global_country = placeMark?.country ?? ' could not get country';
        global_adminArea =
            placeMark?.administrativeArea ?? ' could not get admin area';
        global_district = placeMark?.subAdministrativeArea ?? 'no';
        global_adress = placeMark?.street ?? 'could not find street';
        global_postalcode =
            placeMark?.postalCode ?? 'could not get admin postal code ';
      });

      saveLocationDataToFirestore(uid); // Pass the UID
    }
  }
  void saveLocationDataToFirestore(String? uid) async {
    try {
      if (uid != null) {
        final userDocRef = _firestore.collection('users').doc(uid);

        // Check if the document exists
        final userDocSnapshot = await userDocRef.get();

        if (userDocSnapshot.exists) {
          // Update the existing document
          await userDocRef.update({
            'latitude': global_lat,
            'longitude': global_long,
            'country': global_country,
            'adminArea': global_adminArea,
            'district': global_district,
            'address': global_adress,
            'postalCode': global_postalcode,
            'timestamp': FieldValue.serverTimestamp(),
          });

          print('Location data updated in Firestore.');
        } else {
          print('Error: Document does not exist for UID: $uid');
        }
      } else {
        print('Error: UID is null');
      }
    } catch (e) {
      print('Error saving location data: $e');
    }
  }
  void loadSelectedColors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedColors = prefs.getStringList('selectedColors')?.toSet() ?? {};
    });
  }

  void saveSelectedColors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedColors', selectedColors.toList());
  }
  void loadPets() async {
    // Fetch the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Fetch pets based on the selected category
      if (category == 'Cats') {
        cats = await fetchAdoptMyPetCat(user.email!);
        AdoptMyPetCat.locallyStoredCats=cats;
      } else if (category == 'Dogs') {
        dogs = await fetchAdoptMyPetDog(user.email!);
        AdoptMyPetDog.locallyStoredDog=dogs;
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> petWidgets = [];

    if (widget.filteredPets == null) {
      // Use original pets list if filteredPets is not provided
      if (category == 'Dogs') {
        petWidgets.addAll(dogs.map((pet) => buildPetWidget(pet)));
        chosenPets = AdoptMyPetDog.locallyStoredDog;
      } else if (category == 'Cats') {
        petWidgets.addAll(cats.map((pet) => buildPetWidget(pet)));
        chosenPets = AdoptMyPetCat.locallyStoredCats;
      }
    } else {
      // Use filteredPets list if provided
      petWidgets.addAll(widget.filteredPets!.map((pet) => buildPetWidget(pet)));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$_country, $_adminArea, $_district' ??'',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 130,
                    width: MediaQuery.of(context).size.width,
                    color: const Color(0XFF57419D).withOpacity(0.6),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: -35,
                          right: -30,
                          width: 130,
                          height: 150,
                          child: Transform.rotate(
                            angle: 12,
                            child: Image.asset(
                              'images/1200px-Paw-print.svg.png',
                              color: const Color(0XFF7A67B1),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -20,
                          left: -10,
                          width: 130,
                          height: 120,
                          child: Transform.rotate(
                            angle: -12,
                            child: Image.asset(
                              'images/1200px-Paw-print.svg.png',
                              color: const Color(0XFF7A67B1),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -40,
                          left: 120,
                          width: 140,
                          height: 130,
                          child: Transform.rotate(
                            angle: -16,
                            child: Image.asset(
                              'images/1200px-Paw-print.svg.png',
                              color: const Color(0XFF7A67B1),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -25,
                          right: 15,
                          height: 160,
                          child: Image.asset('images/DogandCat.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Pet, Your Choice!',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Column(
                                children: [
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              NewestPetScreennew(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 15,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(35),
                                        color: const Color(0XFFFBB540),
                                      ),
                                      child: Text(
                                        'Adopt A pet',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AdoptMyPetScreen(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 15,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(35),
                                        color: const Color(0XFFFBB540),
                                      ),
                                      child: Text(
                                        'Adopt my pet',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'Categories',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0XFF57419D),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.tune_rounded),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return FilterOptionsDialog(category: category,pets:chosenPets);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      categories.length,
                          (index) => Padding(
                        padding: index == 0
                            ? const EdgeInsets.only(left: 50, right: 50)
                            : const EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              category = categories[index];

                              loadPets();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            width: 80,
                            height: 41,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: categories[index] == category
                                  ? const Color(0XFF57419D)
                                  : Colors.white,
                              boxShadow: [
                                categories[index] == category
                                    ? const BoxShadow(
                                  offset: Offset(0, 5),
                                  color: Color(0XFFFBB540),
                                  spreadRadius: -1,
                                  blurRadius: 10,
                                )
                                    : const BoxShadow(color: Colors.white),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                categories[index],
                                style: GoogleFonts.poppins(
                                  color: categories[index] == category
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'Newest Pets',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0XFF57419D),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: petWidgets,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildPetWidget(dynamic pet) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    bool isFavorited = favoriteProvider.isFavorite(pet);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PetProfileScreenHOME(
                health: pet.health,
                imageURL: pet.imageURL,
                color: pet.color,
                category: pet.category,
                name: pet.name,
                status: pet.status,
                weight: pet.weight,
                phoneNumber: pet.phoneNumber,
                userId: pet.userId,
                usernationality: pet.usernationality,
                age: pet.age,
                about: pet.about,
                sex: pet.sex,
                ticketNumber: pet.ticketNumber,
                username: pet.username,
                userfavorite: pet.userfavorite,
                useremail: pet.useremail,
                petuuid: pet.petuuid,
              ),
            ),
          );
        },        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.black,
              border: Border.all(
                color: const Color(0XFF57419D),
                width: 2.0,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                color: Colors.white,
                height: 130,
                width: 352,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Positioned(
                      top: 20,
                      left: 140,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pet.name,
                            style: GoogleFonts.poppins(
                              fontSize: 25,
                              color: const Color(0XFF57419D),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            pet.health,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            pet.color,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 5,
                      left: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[200],
                        ),
                        height: 120,
                        width: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            pet.imageURL ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            favoriteProvider.toggleFavorite(pet);
                          });
                        },
                        child: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_outline_outlined,
                          color:  isFavorited ? Colors.red.shade800 : Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
