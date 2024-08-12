// lib/models/restaurant.dart
class Restaurant {
  final String name;
  final String imageUrl;
  final double rating;
  final String cuisineType;
  final String location;

  Restaurant({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.cuisineType,
    required this.location,
  });
}
