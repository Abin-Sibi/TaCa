import 'package:flutter/material.dart';
import 'package:taca/sign_up_page.dart';
import 'package:taca/utils/route_utils.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
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
                image: AssetImage('assets/images/landingbanner.jpg'), // Replace with your image asset path
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
                        'Welcome to',
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
                        'Enjoy the best dining experience',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 150), // Adjust the height as per your design
                // Login Form in Black Background
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // Email Field
                      TextField(
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
                      ),
                      SizedBox(height: 16),
                      // Password Field
                      TextField(
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
                      ),
                      SizedBox(height: 24),
                      // Login Button with Gradient
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage()),
                            );
                          },
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
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Signup Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(createFadeRoute(SignupPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
