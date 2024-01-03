import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App title
      title: 'Social Rank',
      theme: ThemeData(
        // Set primary color theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[200], // Make app bar transparent
        ),
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Initial route when the app starts
      initialRoute: '/login',
      // Define routes and their corresponding pages
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
      },
    );
  }
}
