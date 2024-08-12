import 'package:flutter/material.dart';
import 'package:taca/utils/route_utils.dart';
import 'dining_views.dart'; // Import DiningViews
import 'catering_home_page.dart'; // Import CateringService

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Dark Overlay
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/home_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.4), // Dark overlay
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'TaCa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your ultimate dining experience',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 40),
                // Dining Views Button
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(createFadeRoute(DiningViews()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.7), // Transparent background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16), // Round corners
                      ),
                      padding: EdgeInsets.all(8),
                      elevation: 0, // No shadow
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.restaurant_menu, color: Colors.white, size: 40), // Icon
                        SizedBox(height: 8),
                        Text(
                          'Dining Views',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.white), // Adjust font size
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Catering Service Button
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(createFadeRoute(CateringHomePage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.7), // Transparent background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16), // Round corners
                      ),
                      padding: EdgeInsets.all(8),
                      elevation: 0, // No shadow
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.local_dining, color: Colors.white, size: 40), // Icon
                        SizedBox(height: 8),
                        Text(
                          'Catering Service',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.white), // Adjust font size
                        ),
                      ],
                    ),
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
