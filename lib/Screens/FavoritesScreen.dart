import 'package:flutter/material.dart';
import 'package:petly/models/favouriteProvider.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  static const String id = 'favorites_screen';

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  Set<dynamic> favouritePets={};
  final List<PetData> petDataList = [
    PetData(
      name: 'Fluffy',
      image: 'images/onboarding1.png',
      age: '4 mon',
      isFavorite: true,
    ),
    PetData(
      name: 'Buddy',
      image: 'images/onboarding2.png',
      age: '2 yrs',
      isFavorite: true,
    ),
    PetData(
      name: 'Max',
      image: 'images/onboarding3.png',
      age: '9 mon',
      isFavorite: true,
    ),
    PetData(
      name: 'Daisy',
      image: 'images/puppyy.jpeg',
      age: '8 mon',
      isFavorite: true,
    ),
    // Add more pet data as needed
  ];

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    List<dynamic> favouritePets = favoriteProvider.favoritePets;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Favorites',
              style: TextStyle(
                fontSize: 30,
                color: Color(0XFF57419D),
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemCount: favouritePets.length,
                  itemBuilder: (context, index) {
                    return _buildPetContainer(favouritePets.toList()[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetContainer(dynamic pet) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    bool isFavorited = favoriteProvider.isFavorite(pet);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0XFF57419D),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.network(
                      pet.imageURL ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        pet.name,
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0XFF57419D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        pet.age ?? '', // Use null-aware operator and provide a default value
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isFavorited = !isFavorited;
                  });
                },
                child: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color:
                  isFavorited ? Colors.red.shade800 : Colors.black,
                ),
              ),
            ),
            if (isFavorited)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Remove from Favorites?',
                            style: TextStyle(
                              color: Color(0XFF57419D),
                            ),
                          ),
                          content: Text(
                              'Are you sure you want to remove ${pet.name} from your favorites?'),
                          actions: [
                            TextButton(
                              onPressed: () {

                                Navigator.of(context).pop(false); // No
                              },
                              child: Text(
                                'No',
                                style: TextStyle(
                                  color:Color(0XFF57419D),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  favoriteProvider.removePet(pet);
                                });
                                Navigator.of(context).pop(true); // Yes
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  color: Color(0XFF57419D),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PetData {
  final String name;
  final String? age; // Make age nullable
  final String image;
  bool isFavorite;

  PetData({
    required this.name,
    required this.image,
    this.age,
    this.isFavorite = true,
  });
}
