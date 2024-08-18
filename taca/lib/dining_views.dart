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
  leading: ShaderMask(
    shaderCallback: (bounds) => LinearGradient(
      colors: [const Color.fromARGB(255, 250, 249, 249), const Color.fromARGB(255, 249, 248, 248)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(bounds),
    child: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop();
      },
      color: Colors.white, // This color is ignored but required for ShaderMask
    ),
  ),
  title: ShaderMask(
    shaderCallback: (bounds) => LinearGradient(
      colors: [const Color.fromARGB(255, 255, 254, 254), Color.fromARGB(255, 255, 255, 255)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(bounds),
    child: Text(
      'Dining Views',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white, // This color is ignored but required for ShaderMask
      ),
    ),
  ),
  backgroundColor: Colors.black,
),


      backgroundColor: Color(0xFF2C2C2C), // Light black/dark gray background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [ Colors.deepOrange, Colors.orangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                'Choose Your Destination',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Find the perfect dining experience based on your preference. Select from the options below to explore restaurants with the desired ambiance.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
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
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // Shadow position
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
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
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [Colors.deepOrange, Colors.orangeAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds),
                                child: Text(
                                  restaurantTypes[index]['title']!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
