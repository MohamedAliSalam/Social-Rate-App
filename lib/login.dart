// Importing necessary packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';
import 'home.dart';
import 'dart:convert' as convert;

// Base URL for API requests
const String _baseURL = 'https://socialrankbysalam.000webhostapp.com';

// Stateful widget for the Login Page
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Global key for the login form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for email and password fields
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  // Boolean to manage loading state
  bool _loading = false;

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  // Function to display a Snackbar with a message
  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // UI elements for logo and input fields
                Text(
                  'Social',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Rate',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Email',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    controller: _controllerPassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Password',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // Login button
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () {
                    // Validate form and trigger login process
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _loading = true;
                      });
                      login(
                        context,
                        update,
                        _controllerEmail.text.toString(),
                        _controllerPassword.text.toString(),
                      );
                    }

                    // Clear input fields after login attempt
                    _controllerEmail.clear();
                    _controllerPassword.clear();
                  },
                  child: const Text('Login'),
                ),

                // Loading indicator
                Visibility(
                  visible: _loading,
                  child: const CircularProgressIndicator(),
                ),

                // Option to navigate to signup page
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  child: Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Function to handle the login process
void login(
    BuildContext context,
    Function(String text) update,
    String email,
    String password,
    ) async {
  try {
    // Hash the password before sending it for validation
    String hashedPassword = hashPassword(password);

    // Validate user credentials
    bool validation = await validateUser(email, hashedPassword);

    if (validation) {
      // If validated, update UI, save user data, and navigate to home page
      update("logged in");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('loggedUserEmail', email);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } else {
      // If validation fails, show error message
      update('wrong email or password');
    }
  } catch (e) {
    // Catch any exceptions and show a connection error message
    update('Connection error');
  }
}

// Function to validate user credentials on the server
Future<bool> validateUser(String email, String pass) async {
  try {
    // Send a POST request with user credentials to the server
    final response = await http.post(
      Uri.parse('$_baseURL/login.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': pass,
      }),
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      // Decode response and check if user exists
      Map<String, dynamic> data = convert.jsonDecode(response.body);
      bool exists = data['exists'] ?? false;
      return exists;
    }
  } catch (e) {
    // Catch any exceptions and return false for failure
  }
  return false;
}

// Function to hash the password using SHA-256
String hashPassword(String password) {
  var bytes = utf8.encode(password);
  var hash = sha256.convert(bytes);
  return hash.toString();
}
