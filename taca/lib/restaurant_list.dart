import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:taca/restaurant_details_page.dart';
import 'package:taca/utils/route_utils.dart';
import 'models/restaurants.dart'; // Ensure you have this model
import 'widgets/restaurant_list_widget.dart'; // Import your existing RestaurantList widget

class RestaurantList extends StatelessWidget {
  final String title;

  RestaurantList({required this.title});

  final List<Restaurant> _restaurants = [
    Restaurant(
      name: 'Restaurant 1',
      imageUrl: 'assets/images/beach2.jpeg',
      rating: 4,
      cuisineType: 'Italian',
      location: 'New York',
    ),
    Restaurant(
      name: 'Restaurant 2',
      imageUrl: 'assets/images/lake2.jpeg',
      rating: 5,
      cuisineType: 'Chinese',
      location: 'Los Angeles',
    ),
    // Add more restaurants as needed...
  ];

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Cuisine Type',
                ),
                items: <String>[
                  'Italian',
                  'Chinese',
                  'Indian',
                  'Mexican',
                  'Thai',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {},
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Category',
                ),
                items: <String>[
                  'Vegetarian',
                  'Non-Vegetarian',
                  'Vegan',
                  'Gluten-Free',
                  'Halal',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {},
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Geography',
                ),
                items: <String>[
                  'North',
                  'South',
                  'East',
                  'West',
                  'Central',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {},
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Apply'),
              onPressed: () {
                // Apply filter logic
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
              items: [
                'assets/images/hill2.jpeg',
                'assets/images/hill3.jpeg',
                'assets/images/lake2.jpeg'
              ].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                      ),
                      child: Image.asset(
                        i,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Search for restaurants',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                  IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
                ],
              ),
            ),
            RestaurantListWidget(
              restaurants: _restaurants,
              onTap: (Restaurant restaurant) {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => RestaurantDetailPage(restaurant: restaurant),
                //   ),
                // );
                Navigator.of(context).push(createFadeRoute(RestaurantDetailPage(restaurant: restaurant)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
