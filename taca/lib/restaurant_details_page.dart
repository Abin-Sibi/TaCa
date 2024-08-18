import 'package:flutter/material.dart';
import 'package:taca/post_review_page.dart';
import 'package:taca/utils/route_utils.dart';
import 'models/restaurants.dart';
import 'date_time_selection_page.dart';

class RestaurantDetailPage extends StatefulWidget {
  final Restaurant restaurant;

  RestaurantDetailPage({required this.restaurant});

  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  @override
  Widget build(BuildContext context) {
    final Gradient gradient = LinearGradient(
      colors: [Colors.deepOrange, Colors.orangeAccent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.restaurant.name,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white), // Arrow icon color
      ),
      body: Container(
        color: Colors.grey[900], // Light black background
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(
                    widget.restaurant.imageUrl,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.restaurant.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.restaurant.type,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = gradient
                              .createShader(Rect.fromLTWH(0, 0, 200, 70)),
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.location_pin,
                        color: Color.fromARGB(255, 254, 2, 2)),
                    const SizedBox(width: 8),
                    Text(
                      widget.restaurant.place,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color.fromARGB(255, 252, 251, 251),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < widget.restaurant.rating
                          ? Icons.star
                          : Icons.star_border,
                      size: 28,
                      color: Colors.orangeAccent,
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'About',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Experience a delightful meal at our restaurant, offering a variety of delicious cuisines in a cozy ambiance. Perfect for family gatherings, date nights, and special celebrations.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
  child: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.deepOrange, Colors.orangeAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: ElevatedButton.icon(
      onPressed: () {
        Navigator.of(context).push(createFadeRoute(
          DateTimeSelectionPage(
            restaurantName: widget.restaurant.name,
          ),
        ));
      },
      icon: Icon(Icons.calendar_today, color: Colors.black),
      label: Text(
        'Book a Table',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
            ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 14),
        backgroundColor: Colors.transparent, // Make background transparent
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0, // Remove the button's shadow
      ),
    ),
  ),
),

                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            createFadeRoute(
                              PostReviewPage(
                                restaurantName: widget.restaurant.name,
                              ),
                            ),
                          );
                        },
                        icon: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return gradient.createShader(bounds);
                          },
                          child: Icon(Icons.rate_review, color: Colors.white),
                        ),
                        label: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return gradient.createShader(bounds);
                          },
                          child: Text('Post Review',
                              style: TextStyle(color: Colors.white)),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.deepOrange),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Customer Reviews',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildReviewCard(
                      name: "John Doe",
                      comment:
                          "Amazing food and service! Will definitely come back.",
                      rating: 5,
                      date: "2024-08-01",
                      time: "14:30",
                    ),
                    const SizedBox(height: 16),
                    _buildReviewCard(
                      name: "Jane Smith",
                      comment:
                          "The ambiance was great, but the food could be better.",
                      rating: 3,
                      date: "2024-08-10",
                      time: "18:45",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard({
    required String name,
    required String comment,
    required int rating,
    required String date,
    required String time,
  }) {
    return Card(
      color: Colors.orangeAccent,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: Colors.deepOrangeAccent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              comment,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  size: 20,
                  color: Colors.black,
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(
              "$date at $time",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
