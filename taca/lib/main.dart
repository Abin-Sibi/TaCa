import 'package:flutter/material.dart';
import 'package:taca/home_content.dart';
import 'package:taca/home_page.dart';
import 'package:taca/landing_page.dart';
import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      },// Set LoginPage as the initial route
    );
    
  }
}
