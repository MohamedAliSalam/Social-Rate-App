import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'login.dart';

// Base URL for the API
const String _baseURL = 'https://socialrankbysalam.000webhostapp.com';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Global key for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for text input fields
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  // Loading state tracker
  bool _loading = false;

  @override
  void dispose() {
    // Dispose of controllers when the state is disposed
    _controllerName.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  // Function to show a SnackBar and update loading state
  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    setState(() {
      _loading = false;
    });

    // Navigate to login page if account is successfully created
    if (text == 'Account Created') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build method for the UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // UI elements for the sign-up form
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
                    controller: _controllerName,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Name',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
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
                      bool emailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
                      if (!emailValid) {
                        return 'Please enter a valid email';
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
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _loading = true;
                      });
                      saveCategory(
                        update,
                        _controllerName.text.toString(),
                        _controllerEmail.text.toString(),
                        _controllerPassword.text.toString(),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: _loading,
                  child: const CircularProgressIndicator(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Function to hash the password using SHA-256
String hashPassword(String password) {
  var bytes = utf8.encode(password);
  var hash = sha256.convert(bytes);
  return hash.toString();
}

// Function to save user information to the server
void saveCategory(
    Function(String text) update,
    String username,
    String email,
    String password,
    ) async {
  try {
    // Hash the password
    String hashedPassword = hashPassword(password);

    // Check if the email already exists in the database
    bool emailExists = await checkEmailExists(email);

    if (emailExists) {
      update("Email already exists");
      return;
    }

    // Send a POST request to the server to sign up the user
    final response = await http.post(
      Uri.parse('$_baseURL/signup.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': hashedPassword, // Send the hashed password to the server
      }),
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      update(response.body); // Update UI based on server response
    }
  } catch (e) {
    update("connection error"); // Handle connection errors
  }
}

// Function to check if an email already exists in the database
Future<bool> checkEmailExists(String email) async {
  try {
    // Send a POST request to check email existence
    final response = await http.post(
      Uri.parse('$_baseURL/check_email.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, String>{
        'email': email,
      }),
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      // Parse the response to check if the email exists
      Map<String, dynamic> data = convert.jsonDecode(response.body);
      bool exists = data['exists'] ?? false;
      return exists;
    }
  } catch (e) {
    // Handle exceptions or errors related to checking email existence
  }
  return false; // Default return value if there's an error
}
