// lib/widgets/restaurant_card.dart
import 'package:flutter/material.dart';
import '../models/restaurants.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final void Function(Restaurant) onTap; // Add onTap callback

  RestaurantCard({required this.restaurant, required this.onTap}); // Update constructor

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: SizedBox(
          width: 50,
          height: 50,
          child: Image.asset(
            restaurant.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          restaurant.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(restaurant.cuisineType),
            Text(restaurant.location),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < restaurant.rating ? Icons.star : Icons.star_border,
                  size: 16,
                  color: Colors.orange,
                );
              }),
            ),
          ],
        ),
        onTap: () {
          onTap(restaurant); // Call the onTap callback
        },
      ),
    );
  }
}
