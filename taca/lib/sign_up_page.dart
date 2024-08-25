import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:taca/config/api_config.dart';
import 'dart:convert';
import 'login_page.dart';
import 'utils/route_utils.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _errorMessage;

  Future<void> _signup() async {
    setState(() {
      _errorMessage = null; // Clear previous error message
    });

    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() {
          _errorMessage = "Passwords do not match";
        });
        return;
      }

      try {
        final response = await http.post(
          Uri.parse('${APIConfig.baseURL}/auth/register'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'name': _nameController.text,
            'email': _emailController.text,
            'phone': _phoneController.text,
            'password': _passwordController.text,
          }),
        );

        final responseBody = jsonDecode(response.body);

        if (response.statusCode == 201) {
          Navigator.of(context).push(createFadeRoute(LoginPage()));
        } else {
          setState(() {
            _errorMessage = responseBody['message'] ?? "Signup failed";
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = "An error occurred. Please try again later.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with a gradient overlay
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/land3.jpg'), // Replace with your image asset path
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          // Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 80), // Adjust height as per your requirement
                // Welcome Text in the Center of the Image
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Join Us at',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Restaurant Name',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Experience the best dining',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50), // Adjust the height as per your design
                // Signup Form in Black Background
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (_errorMessage != null) ...[
                          Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                        // Name Field
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Name',
                            hintStyle: TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        // Phone Field
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly, // Allow only numeric input
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (value.length != 10) {
                              return 'Phone number must be exactly 10 digits';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 4) {
                              return 'Password must be at least 4 characters long';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        // Confirm Password Field
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            hintStyle: TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        // Signup Button with Gradient
                        SizedBox(
                          width: double.infinity,
                          child: InkWell(
                            onTap: _signup,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orangeAccent.shade200,
                                    Colors.orangeAccent.shade700,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Signup',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Login Redirect Link
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(createFadeRoute(LoginPage()));
                  },
                  child: Text(
                    'Already have an account? Login',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
