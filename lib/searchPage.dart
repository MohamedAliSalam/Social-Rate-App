import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'profiles.dart'; // Importing a local 'profiles.dart' file

const String _baseURL = 'https://socialrankbysalam.000webhostapp.com'; // Base URL for API

// Function to retrieve the logged-in user's email from SharedPreferences
Future<String> getLoggedUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedEmail = prefs.getString('loggedUserEmail') ?? ''; // Fetching 'loggedUserEmail' or assigning an empty string
  return storedEmail;
}

// StatefulWidget for the search page
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

// State class for the SearchPage
class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> _searchResults = []; // List to store search results

  // Function to perform a search based on the query
  void _search(String query) async {
    final loggedUserEmail = await getLoggedUserEmail(); // Fetch logged-in user's email
    final results = await fetchSearchResults(query, loggedUserEmail); // Fetch search results
    setState(() {
      _searchResults = results; // Update search results in the state
    });
  }

  // Function to fetch search results from the API
  Future<List<Map<String, dynamic>>> fetchSearchResults(String query, String excludeEmail) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseURL/search.php'), // Endpoint for search
        body: {'query': query, 'excludeEmail': excludeEmail}, // Request parameters
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body); // Decode response data
        List<Map<String, dynamic>> results = [];

        for (var data in responseData) {
          results.add({
            'name': data['username'], // Storing username
            'email': data['email'], // Storing email
            'photo': data['image'], // Storing image URL
          });
        }
        return results; // Return formatted search results
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      throw Exception('Error fetching search results: $e'); // Throw an exception in case of an error
    }
  }

  // Building the UI for the search page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Search'), // AppBar title
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _search, // Call search function when text changes
              decoration: InputDecoration(
                hintText: 'Search...', // Placeholder text for search
                prefixIcon: Icon(Icons.search), // Search icon
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: _searchResults.isEmpty
                ? Center(
              child: Text('No results'), // Display message for no results
            )
                : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(_searchResults[index]['photo']), // Display user image
                  ),
                  title: Text(_searchResults[index]['name']), // Display user name
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profiles(userEmail: _searchResults[index]['email']), // Navigate to profile page on tap
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
