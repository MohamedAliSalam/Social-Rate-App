import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'showPhoto.dart';
import 'dart:io';
import 'dart:convert';

// Your API base URL
const String _baseURL = 'https://socialrankbysalam.000webhostapp.com';

// Retrieves logged-in user's email from SharedPreferences
Future<String> getLoggedUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedEmail = prefs.getString('loggedUserEmail') ?? '';
  return storedEmail;
}

// Fetches user data using the provided email
Future<Map<String, dynamic>> fetchUserData(String email) async {
  final url = '$_baseURL/userProfile.php';
  final response = await http.get(Uri.parse('$url?email=$email'));

  if (response.statusCode == 200) {
    return convert.jsonDecode(response.body);
  } else {
    throw Exception('Failed to load user data');
  }
}

// Stateful widget representing the user's profile page
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

// State class managing the profile page state
class _ProfilePageState extends State<ProfilePage> {
  List<String> photoUrls = [];
  late File uploadimage;
  String userEmail = '';
  String username = '';
  double rating = 0.0;
  int numRatings =0;

  // Function to view a full-sized photo
  void viewFullPhoto(String photoUrl) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullPhoto(photoUrl),
      ),
    );

    if (result != null && result is bool && result) {
      await _loadUserData();
      await _loadUserPhotos();
    }
  }

  // Function to choose and upload an image
  Future<void> chooseAndUploadImage(String userEmail) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? chosenImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (chosenImage != null) {
      File imageFile = File(chosenImage.path);

      try {
        List<int> imageBytes = imageFile.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);

        var response = await http.post(
          Uri.parse('$_baseURL/uploadPhoto.php'),
          body: {
            'image': base64Image,
            'email': userEmail,
          },
        );

        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);
          if (jsonData["success"]) {
            print("Image uploaded and stored successfully");
          } else {
            print("Failed to upload image. Server response: ${jsonData["message"]}");
          }
        } else {
          print("Error during connection to server: ${response.statusCode}");
        }
      } catch (e) {
        print("Error during image upload: $e");
      }
    }
    setState(() {
      _loadUserData();
      _loadUserPhotos();
    });
  }

  // Function to delete user account
  Future<void> deleteAccount(BuildContext context, String userEmail) async {
    try {
      var response = await http.post(
        Uri.parse('$_baseURL/deleteAccount.php'),
        body: {'email': userEmail},
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData["success"]) {
          print("Account deleted successfully");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('loggedUserEmail');
        } else {
          print("Failed to delete account. Server response: ${jsonData["message"]}");
        }
      } else {
        print("Error during connection to server: ${response.statusCode}");
      }
    } catch (e) {
      print("Error deleting account: $e");
    }
  }

  // Function to load user's photos
  Future<void> _loadUserPhotos() async {
    userEmail = await getLoggedUserEmail();
    try {
      final photoData = await fetchUserPhotos(userEmail);
      setState(() {
        if (photoData.isNotEmpty) {
          photoUrls = photoData;
        } else {
          photoUrls = [];
          print('No photos found for the provided email.');
        }
      });
    } catch (e) {
      print('Error fetching user photos: $e');
    }
  }

  // Function to fetch user's photos using provided email
  Future<List<String>> fetchUserPhotos(String userEmail) async {
    final url = '$_baseURL/showUserP.php';
    final response = await http.post(Uri.parse(url), body: {'email': userEmail});

    if (response.statusCode == 200) {
      dynamic data = convert.jsonDecode(response.body);

      if (data != null && data is List) {
        List<String> photoURLs = data.map((item) {
          return item.toString();
        }).toList();

        return photoURLs;
      } else if (data != null && data['message'] != null) {
        print('Invalid data format: ${data['message']}');
        return [];
      } else {
        print('Invalid data format: $data');
        throw Exception('Invalid data format');
      }
    } else {
      throw Exception('Failed to load user photos');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadUserPhotos();
  }

  // Function to load user data
  Future<void> _loadUserData() async {
    userEmail = await getLoggedUserEmail();
    if (userEmail.isNotEmpty) {
      try {
        final userData = await fetchUserData(userEmail);
        setState(() {
          username = userData['username'] ?? '';
          rating = userData['rating'] != null ? userData['rating'].toDouble() : 0.0;
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
        automaticallyImplyLeading: false,
        title: Text('$username'),
        actions: [
          // Delete Account Button
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Dialog to confirm account deletion
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Delete Account"),
                    content: Text("Are you sure you want to delete your account?"),
                    actions: [
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("Delete"),
                        onPressed: () {
                          deleteAccount(context, userEmail);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Account deleted successfully")),
                          );
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          // Add Photo Button
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              chooseAndUploadImage(userEmail);
            },
          ),
          // Logout Button
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('loggedUserEmail');
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
        ],
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
                // Display User's Rating
                Text(
                  'Rating: $rating',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '$numRatings rating',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          Divider(), // Add a divider between each photo for visual separation

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: photoUrls.isEmpty
                  ? Center(
                child: Text(
                  'No photos',
                  style: TextStyle(fontSize: 20),
                ),
              )
                  : GridView.builder(
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
                      loadingBuilder: (
                          BuildContext context,
                          Widget child,
                          ImageChunkEvent? loadingProgress,
                          ) {
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
