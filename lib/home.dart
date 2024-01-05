import 'package:flutter/material.dart';
import 'searchPage.dart'; // Import your search page file
import 'userProfile.dart'; // Import your userProfile file
import 'feed.dart'; // Import your feed file


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perception', // Title of the app
      theme: ThemeData(
        primarySwatch: Colors.blue, // Set primary color theme
      ),
      home: MyHomePage(), // Set MyHomePage as the initial route
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // Index for the selected bottom navigation bar item

  // List of widgets for different pages to display
  static List<Widget> _widgetOptions = <Widget>[
    FeedPage(), // Widget for the feed page
    SearchPage(), // Widget for the search page
    ProfilePage(), // Widget for the profile page
  ];

  // Function to handle bottom navigation item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Perception'),
      ),

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex), // Display selected page
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(


        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home), // Icon for Home
              label: 'Home', // Label for Home
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search), // Icon for Search
              label: 'Search', // Label for Search
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person), // Icon for Profile
              label: 'Profile', // Label for Profile
            ),
          ],
          currentIndex: _selectedIndex, // Current selected index
          selectedItemColor: Colors.black87, // Color for the selected item
          unselectedItemColor: Colors.grey[700], // Color for unselected items
          backgroundColor: Colors.grey[200], // Transparent background
          onTap: _onItemTapped, // Function call on item tap
          elevation: 0, // No elevation
        ),
      ),

    );
  }
}
