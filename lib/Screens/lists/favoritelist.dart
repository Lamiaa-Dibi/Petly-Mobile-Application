import 'package:cloud_firestore/cloud_firestore.dart';

class Favoritelist {
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

  Favoritelist({
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

  });
}

// Assuming you have fetched initial booking data and stored it in a list called 'initialBookingsData'
Future<List<Favoritelist>> fetchFavoritelist(String userEmail) async {
  List<Favoritelist> initialBookings = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('adopt_my_pet')
        .where('animal-status', isEqualTo: 'waiting')

        .get();

    if (querySnapshot.docs.isNotEmpty) {
      initialBookings = querySnapshot.docs.map((doc) {
        return Favoritelist(
          ticketNumber: doc['ticketNumber'].toString(),
          imageURL: doc['animal-imageURL'] ?? '',
          health: doc['animal-health'],
          color: doc['animal-color'],
          category: doc['animal-category'],
          age: doc['animal-age'],
          about: doc['animal-about'],
          name: doc['animal-name'],
          sex: doc['animal-sex'],
          status: doc['animal-status'],
          weight: doc['animal-weight'],
          phoneNumber: doc['phoneNumber'],
          userId: doc['userId'],
          usernationality:doc['usernationality'],
          username: doc['username'],
          userfavorite: doc['userfavorite'],
          useremail: doc['useremail'],
          petuuid: doc['animal-petuuid'],

        );
      }).toList();
    }
  } catch (e) {
    print('Error fetching initial bookings: $e');
  }

  return initialBookings;
}
