import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lists/MyPetList.dart';
import 'PetProfileScreen.dart'; // Import the screen you want to navigate to

class PetListingScreen extends StatefulWidget {
  static const String id = 'PetListingScreen';

  @override
  _PetListingScreenState createState() => _PetListingScreenState();
}

class _PetListingScreenState extends State<PetListingScreen> {
  late Future<List<MyPetListing>> petListingFuture;

  @override
  void initState() {
    super.initState();
    // Fetch current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userEmail = user.email ?? ''; // Get current user's email
      petListingFuture = fetchMyPetListing(
          userEmail); // Fetch pet listings using current user's email
    } else {
      // Handle case where user is not logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Your Pet Listing is Live!',
              style: TextStyle(
                fontSize: 30,
                color: Color(0XFF57419D),
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: FutureBuilder<List<MyPetListing>>(
                future: petListingFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<MyPetListing> petListings = snapshot.data ?? [];
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                      ),
                      itemCount: petListings.length,
                      itemBuilder: (context, index) {
                        return _buildPetContainer(petListings[index]);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetContainer(MyPetListing petData) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PetProfileScreen(
                health: petData.health,
                imageURL: petData.imageURL,
                color: petData.color,
                category: petData.category,
                name: petData.name,
                status: petData.status,
                weight: petData.weight,
                phoneNumber: petData.phoneNumber,
                userId: petData.userId,
                usernationality: petData.usernationality,
                age: petData.age,
                about: petData.about,
                sex: petData.sex,
                ticketNumber: petData.ticketNumber,
                username: petData.username,
                userfavorite: petData.userfavorite,
                useremail: petData.useremail,
                petuuid: petData.petuuid,
              ),
            ),
          );
        },
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
                        petData.imageURL ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          petData.name,
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0XFF57419D),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          petData.age ?? '',
                          // Use null-aware operator and provide a default value
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
            ],
          ),
        ),
      ),
    );
  }
}
