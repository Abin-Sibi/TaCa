import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Gradient gradient = LinearGradient(
      colors: [Colors.deepOrange, Colors.orangeAccent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: gradient,
                ),
                child: Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(seconds: 2),
                    builder: (context, value, child) => Transform.scale(
                      scale: value,
                      child: Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Success',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()..shader = gradient.createShader(Rect.fromLTWH(0, 0, 200, 70)),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Your table is reserved',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(250, 249, 248, 248),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'NOTE: Reservation is only for 1 hour',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 252, 252, 252),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: Text(
                  'Go to Home',
                  style: TextStyle(fontSize: 18,color: Colors.white),
                  
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.deepOrange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
