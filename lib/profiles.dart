import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';


Future<String> getLoggedUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedEmail = prefs.getString('loggedUserEmail') ?? '';
  return storedEmail;
}

const String _baseURL = 'https://socialrankbysalam.000webhostapp.com';

Future<Map<String, dynamic>> fetchUserData(String email) async {
  final url = '$_baseURL/userProfile.php';
  final response = await http.get(Uri.parse('$url?email=$email'));

  if (response.statusCode == 200) {
    return convert.jsonDecode(response.body);
  } else {
    throw Exception('Failed to load user data');
  }
}


class Profiles extends StatefulWidget {
  final String userEmail;

  Profiles({required this.userEmail});

  @override
  _ProfilesState createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  List<String> photoUrls = [];
  late File uploadimage;
  String userEmail = '';
  String username = '';
  double userrating = 0.0;
  double _currentRating = 5.0;
  int numRatings = 0 ;

  void viewFullPhoto(String photoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullPhoto(photoUrl),
      ),
    );
  }



  Future<void> _loadUserPhotos() async {
    userEmail = widget.userEmail;
    try {
      final photoData = await fetchUserPhotos(userEmail);
      setState(() {
        photoUrls = photoData;
      });
    } catch (e) {
      print('Error fetching user photos: $e');
    }
  }

  Future<List<String>> fetchUserPhotos(String userEmail) async {
    final url = '$_baseURL/showUserP.php';
    final response = await http.post(Uri.parse(url), body: {'email': userEmail});

    if (response.statusCode == 200) {
      dynamic data = convert.jsonDecode(response.body);

      if (data != null && data is List) {
        List<String> photoURLs = data.map((item) {
          return item.toString(); // Assuming the direct URLs are returned
        }).toList();

        return photoURLs;
      } else {
        throw Exception('Invalid data format');
      }
    } else {
      throw Exception('Failed to load user photos');
    }
  }



  Future<void> updateRating(String ratingUserEmail, String ratedUserEmail, double newRating) async {
    final url = '$_baseURL/rating.php'; // Replace with your actual rating.php endpoint
    try {
      final response = await http.post(Uri.parse(url), body: {
        'rating_user_email': ratingUserEmail,
        'rated_user_email': ratedUserEmail,
        'rating': newRating.toString(),
      });

      if (response.statusCode == 200) {
        // Handle success, maybe update the local rating value too
        await _loadUserData();
      } else {
        // Handle error
        print('Failed to update rating');
      }
    } catch (e) {
      // Handle error
      print('Error updating rating: $e');
    }
  }


  @override
  void initState() {
    super.initState();
    userEmail = widget.userEmail;
    _loadUserData();
    _loadUserPhotos();
  }

  Future<void> _loadUserData() async {
    userEmail = widget.userEmail;
    if (userEmail.isNotEmpty) {
      try {
        final userData = await fetchUserData(userEmail);
        setState(() {
          username = userData['username'] ?? '';
          // Handle null rating scenario
          userrating = userData['rating'] != null ? userData['rating'].toDouble() ?? 0.0 : 0.0;
          numRatings = userData['num_ratings'] ?? 0;
        });
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$username'),

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  'Rating: $userrating',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  ' $numRatings rating',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          Slider(
            value: _currentRating,
            min: 1,
            max: 10,
            divisions: 18, // (10 - 1) * 2 to accommodate 0.5 increments
            label: _currentRating.toStringAsFixed(1),
            onChanged: (double value) {
              setState(() {
                _currentRating = (value * 2).round() / 2; // Ensure the value is in increments of 0.5
              });
            },
            onChangeEnd: (double value) async {
              String ratingUserEmail = await getLoggedUserEmail();
              updateRating(ratingUserEmail, userEmail, _currentRating); // Send the updated rating when the slider interaction ends

            },
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: photoUrls.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      viewFullPhoto(photoUrls[index]);
                    },
                    child: Image.network(
                      photoUrls[index],
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class FullPhoto extends StatelessWidget {
  final String photoUrl;

  FullPhoto(this.photoUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.network(photoUrl),
      ),
    );
  }
}



