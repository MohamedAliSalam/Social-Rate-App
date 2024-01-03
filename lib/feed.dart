import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profiles.dart';

// Base URL for API requests
const String _baseURL = 'https://socialrankbysalam.000webhostapp.com';

// Function to retrieve the logged-in user's email from SharedPreferences
Future<String> getLoggedUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedEmail = prefs.getString('loggedUserEmail') ?? '';
  return storedEmail;
}

// Class to represent photo data
class PhotoData {
  final String imageUrl;
  final String userEmail;
  final String username;
  final String date; // New field for the date

  PhotoData({
    required this.imageUrl,
    required this.userEmail,
    required this.username,
    required this.date,
  });

  // Factory method to create PhotoData objects from JSON data
  factory PhotoData.fromJson(Map<String, dynamic> json) {
    return PhotoData(
      imageUrl: json['image'], // Extracting image URL from JSON
      userEmail: json['email'], // Extracting user's email from JSON
      username: json['username'], // Extracting username from JSON
      date: json['date'], // Extracting date from JSON
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FeedPage(),
    );
  }
}

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<PhotoData> _photos = [];

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  // Function to load photos
  Future<void> _loadPhotos() async {
    try {
      final photoData = await _fetchPhotos();
      setState(() {
        _photos = photoData;
      });
    } catch (e) {
      print('Error fetching user photos: $e');
      // Handle error: Show a snackbar or display an error message.
    }
  }

  // Function to fetch photos from the API
  Future<List<PhotoData>> _fetchPhotos() async {
    final url = '$_baseURL/homePhoto.php';

    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> responseData = convert.jsonDecode(response.body);

        // Get the logged user's email
        String loggedUserEmail = await getLoggedUserEmail();

        // Process response data to create PhotoData objects
        List<PhotoData> photoData = responseData
            .map((data) => PhotoData.fromJson(data)) // Convert JSON to PhotoData objects
            .where((photo) => photo.userEmail != loggedUserEmail) // Filter out photos of the logged user
            .toList();

        return photoData;
      } else {
        throw Exception('Failed to load user photos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load user photos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _photos.length,
        itemBuilder: (context, index) {
          // Format the date for display
          String formattedDate = DateFormat.yMMMd().format(DateTime.parse(_photos[index].date));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display username and date
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_photos[index].username}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$formattedDate',
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // Display the photo with GestureDetector for navigation
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profiles(userEmail: _photos[index].userEmail),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width, // Make it full width
                    height: MediaQuery.of(context).size.width, // Set height to match width for a square
                    child: Image.network(
                      _photos[index].imageUrl,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Center(child: Icon(Icons.error));
                      },
                    ),
                  ),
                ),
              ),
              Divider(), // Add a divider between each photo for visual separation
            ],
          );
        },
      ),
    );
  }
}
