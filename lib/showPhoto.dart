import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Base URL for API requests
const String _baseURL = 'https://socialrankbysalam.000webhostapp.com';

// Widget for displaying a full-sized photo with delete functionality
class FullPhoto extends StatelessWidget {
  final String photoUrl; // URL of the photo to display

  FullPhoto(this.photoUrl); // Constructor to initialize with a photo URL

  // Function to delete the current photo
  Future<void> deletePhoto(BuildContext context) async {
    // Endpoint URL to delete a photo
    final url = Uri.parse('$_baseURL/deletePhoto.php');

    try {
      // Sending a POST request to delete the photo
      final response = await http.post(url, body: {
        'photoUrl': photoUrl, // Sending the URL of the photo to be deleted
      });

      // Checking the response status code
      if (response.statusCode == 200) {
        // If successful response, print the response body and navigate back
        print(response.body);
        Navigator.pop(context, true); // Pop the page with a 'true' flag to indicate successful deletion
      } else {
        // Handle other status codes if necessary
      }
    } catch (error) {
      // Catching and handling errors that might occur during the HTTP request
      print("Error deleting photo: $error");
      // Further error handling can be added as needed for the app
    }
  }

  // Building the UI for the FullPhoto widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Photo'), // Title for the app bar
        actions: [
          // Delete button in the app bar
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Calling the deletePhoto function when the delete button is pressed
              deletePhoto(context); // Pass the context to deletePhoto
            },
          ),
        ],
      ),
      body: Center(
        child: Image.network(
          photoUrl, // Displaying the image using its URL
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            // Handling the loading of the image with a progress indicator
            if (loadingProgress == null) {
              return child; // If image loaded, display the image
            } else {
              return CircularProgressIndicator(); // Show a loading indicator while the image is loading
            }
          },
        ),
      ),
    );
  }
}
