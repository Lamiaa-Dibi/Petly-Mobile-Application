import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'favoritelist.dart';

class NewestPetScreennew extends StatefulWidget {
  static const String id = 'NewestPetScreennew';

  @override
  State<NewestPetScreennew> createState() => _NewestPetScreennewState();
}

class _NewestPetScreennewState extends State<NewestPetScreennew> {
  String selectedCity = 'Istanbul';
  String? selectedSex;
  late final dynamic pet;

  int _currentIndex = 0;
  List<String> categories = ['Cats', 'Dogs'];
  String category = 'Cats';
  Set<String> selectedColors = {};
  double selectedWeight = 25.0;
  double selectedAge = 25.0;
  String selectedBreed = '';

  List<Favoritelist> cats = [];
  List<Favoritelist> dogs = [];
  List<Favoritelist> favoritePets = [];

  @override
  void initState() {
    super.initState();
    loadSelectedColors();
    loadPets();
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
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      cats = await fetchFavoritelist(user.email!);
      dogs = await fetchFavoritelist(user.email!);

      setState(() {});
    }
  }

  void handleFavoriteChange(Favoritelist pet, bool isFavorited) {
    setState(() {
      if (isFavorited) {
        favoritePets.add(pet);
      } else {
        favoritePets.remove(pet);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Favoritelist> selectedCategoryPets = category == 'Cats' ? cats : dogs;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'Newest Pets',
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Color(0XFF57419D),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                children: selectedCategoryPets.map((pet) => PetWidget(
                  pet: pet,
                  onFavoriteChanged: handleFavoriteChange,
                )).toList(),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class PetWidget extends StatefulWidget {
  final Favoritelist pet;
  final Function(Favoritelist, bool) onFavoriteChanged;

  PetWidget({required this.pet, required this.onFavoriteChanged});

  @override
  _PetWidgetState createState() => _PetWidgetState();
}

class _PetWidgetState extends State<PetWidget> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(

            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.black,
                  border: Border.all(
                    color: Color(0XFF57419D),
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
                                widget.pet.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                widget.pet.health,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text(
                                widget.pet.color,
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
                                widget.pet.imageURL ?? '',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isFavorited = !isFavorited;
                                widget.onFavoriteChanged(widget.pet, isFavorited);
                              });
                            },
                            child: Icon(
                              isFavorited ? Icons.favorite : Icons.favorite_outline_outlined,
                              color: isFavorited ? Colors.red.shade800 : Colors.black,
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
        ],
      ),
    );
  }
}
