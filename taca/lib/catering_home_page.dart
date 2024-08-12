// lib/catering_home_page.dart
import 'package:flutter/material.dart';
import 'package:taca/caterer_details_page.dart';
import 'package:taca/utils/route_utils.dart';

class CateringHomePage extends StatefulWidget {
  @override
  _CateringHomePageState createState() => _CateringHomePageState();
}

class _CateringHomePageState extends State<CateringHomePage> {
  

  final List<Map<String, dynamic>> categories = [
    {'name': 'Corporate Events', 'icon': Icons.business},
    {'name': 'Weddings', 'icon': Icons.cake},
    {'name': 'Parties', 'icon': Icons.party_mode},
    {'name': 'Other Events', 'icon': Icons.event},
  ];

  final List<Map<String, dynamic>> caterers = [
    {'name': 'Gourmet Catering', 'rating': 4.5, 'image': 'assets/images/caterer1.jpeg'},
    {'name': 'Elite Cuisine', 'rating': 4.7, 'image': 'assets/images/caterer2.jpeg'},
    {'name': 'Banquet Delight', 'rating': 4.2, 'image': 'assets/images/caterer3.jpeg'},
    {'name': 'Savory Bites', 'rating': 4.8, 'image': 'assets/images/caterer1.jpeg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catering Services'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Selection
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle category selection
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(8), // Adjust padding to fit icons
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(category['icon'], color: Colors.white, size: 30), // Reduced icon size
                            SizedBox(height: 8),
                            Text(
                              category['name'],
                              style: TextStyle(color: Colors.white, fontSize: 12), // Reduced font size
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Available Caterers',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepOrange),
              ),
              SizedBox(height: 10),
              // Caterers Grid
              SizedBox(
                height: MediaQuery.of(context).size.height - 300, // Adjust height to fit the remaining screen space
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: caterers.length,
                  itemBuilder: (context, index) {
                    final caterer = caterers[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(createFadeRoute(CatererDetailPage(caterer: caterer)));
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.asset(
                                  caterer['image'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(child: Text('Image not available'));
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    caterer['name'],
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.amber, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        '${caterer['rating']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}
