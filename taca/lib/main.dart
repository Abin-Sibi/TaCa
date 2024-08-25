import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:taca/controllers/auth_controller.dart'; // Import the UserController
import 'package:taca/home_content.dart';
import 'package:taca/landing_page.dart';
import 'login_page.dart';

void main() {
  // Initialize the UserController
  Get.put(AuthController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Use GetMaterialApp instead of MaterialApp
      title: 'Restaurant Table Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(), 
      initialRoute: '/',
      routes: {
        '/landing': (context) => LandingPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomeContent(),
        // '/home': (context) => HomePage(),
      },
    );
  }
}
