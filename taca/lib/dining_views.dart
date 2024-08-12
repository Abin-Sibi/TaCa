import 'package:flutter/material.dart';
import 'package:taca/utils/route_utils.dart';
import 'restaurant_list.dart'; // Import RestaurantList

class DiningViews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> restaurantTypes = [
      {'title': 'Hill View', 'image': 'assets/images/hill.jpeg'},
      {'title': 'Beach Side', 'image': 'assets/images/beach.jpeg'},
      {'title': 'Lake Side', 'image': 'assets/images/lake.jpeg'},
      {'title': 'Forest View', 'image': 'assets/images/forest.jpeg'},
      {'title': 'Village Side', 'image': 'assets/images/village1.jpeg'},
      {'title': 'City Side', 'image': 'assets/images/city1.jpeg'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Dining Views'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Your Destination',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Find the perfect dining experience based on your preference. Select from the options below to explore restaurants with the desired ambiance.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: restaurantTypes.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 4,
                    child: InkWell(
                      onTap: () {
                        // Handle navigation to RestaurantList or relevant page
                        Navigator.of(context).push(createFadeRoute(RestaurantList(title: restaurantTypes[index]['title']!)));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                              child: Image.asset(
                                restaurantTypes[index]['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              restaurantTypes[index]['title']!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
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
    );
  }
}
