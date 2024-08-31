import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taca/config/api_config.dart';
import 'package:taca/menu_list.dart';
import 'package:taca/post_review_page.dart';
import 'package:taca/utils/route_utils.dart';
import 'models/restaurants.dart';
import 'date_time_selection_page.dart';

// Define the Review class here
class Review {
  final String name;
  final String comment;
  final int rating;
  final int badges;
  final int verified;
  final String date;
  final String time;
  

  Review({
    required this.name,
    required this.comment,
    required this.rating,
    required this.badges,
    required this.verified,
    required this.date,
    required this.time,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      name: json['userName'],
      comment: json['reviewText'],
      rating: json['rating'],
      badges:json['badges'],
      verified: json['verified'],
      date: json['createdAt'].split('T')[0], // Splits date from ISO format
      time: json['createdAt'].split('T')[1].substring(0, 5), // Extracts time
    );
  }
}

// Then, your RestaurantDetailPage and its state class follow
class RestaurantDetailPage extends StatefulWidget {
  final Restaurant restaurant;

  RestaurantDetailPage(
      {required this.restaurant, required String restaurantId});

  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  List<Review> _reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    String restaurantId = widget.restaurant.id;
    print('id::${restaurantId} hello : ${widget.restaurant}');
    String apiUrl = '${APIConfig.baseURL}/reviews/$restaurantId';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        print('object: ${response.body}');
        setState(() {
          _reviews = data.map((json) => Review.fromJson(json)).toList();
          _isLoading = false;
        });
        print("jaslj ${_reviews[1].verified}");
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

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
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.grey[900],
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
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Aligns children at opposite ends
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_pin,
                            color: Color.fromARGB(255, 254, 2, 2)),
                        const SizedBox(width: 8),
                        Text(
                          widget.restaurant.place,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: const Color.fromARGB(255, 252, 251, 251),
                              ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color.fromARGB(255, 247, 76, 3), Colors.deepOrange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(createFadeRoute(
                              MenuListPage(restaurantId:widget.restaurant.id,)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.transparent, // Use the gradient
                          elevation: 0,
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'See Menu >',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
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
                                  restaurantId: widget.restaurant.id),
                            ));
                          },
                          icon: Icon(Icons.calendar_today, color: Colors.black),
                          label: Text(
                            'Book a Table',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.of(context).push(
                            createFadeRoute(
                              PostReviewPage(
                                  restaurantName: widget.restaurant.name,
                                  restaurantId: widget.restaurant.id,
                                  location: widget.restaurant.place),
                            ),
                          );

                          if (result == true) {
                            _fetchReviews(); // Refresh reviews after a new one is posted
                          }
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
                  children: _isLoading
                      ? [Center(child: CircularProgressIndicator())]
                      : _reviews
                          .map((review) => Column(
                                children: [
                                  _buildReviewCard(
                                    name: review.name,
                                    comment: review.comment,
                                    rating: review.rating,
                                    badges: review.badges,
                                    verified: review.verified,
                                    date: review.date,
                                    time: review.time,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ))
                          .toList(),
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
  required int badges, // 1 for good review, 0 for bad review
  required int verified, // 1 for verified, 0 for not verified
  required String date,
  required String time,
}) {
  return Stack(
    children: [
      Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadowColor: Colors.deepOrangeAccent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orangeAccent, Colors.deepOrangeAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                comment,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
              ),
              const SizedBox(height: 16),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    size: 20,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                "$date at $time",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
              ),
            ],
          ),
        ),
      ),
      // Badge for Good or Bad review
      Positioned(
        top: 10,
        right: 10,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: badges == 1 ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            badges == 1 ? 'Good' : 'Bad',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
      // Verified or Not Verified Badge
      Positioned(
        bottom: 10,
        right: 10,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 6, 6, 6) ,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.verified,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                verified == 1 ? 'VERIFIED' : 'NOT VERIFIED',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}


}
