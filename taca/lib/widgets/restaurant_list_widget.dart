// lib/widgets/restaurant_list.dart
import 'package:flutter/material.dart';
import '../models/restaurants.dart';
import 'restaurant_card.dart';

class RestaurantListWidget extends StatelessWidget {
  final List<Restaurant> restaurants;
  final void Function(Restaurant) onTap; // Add onTap callback

  RestaurantListWidget({required this.restaurants, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: restaurants.map((restaurant) {
        return RestaurantCard(
          restaurant: restaurant,
          onTap: onTap, // Pass the onTap callback
        );
      }).toList(),
    );
  }
}
