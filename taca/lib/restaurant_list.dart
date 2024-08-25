import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'models/restaurants.dart';
import 'restaurant_details_page.dart';
import 'widgets/restaurant_list_widget.dart';
import 'utils/route_utils.dart';
import 'package:taca/config/api_config.dart';

class RestaurantList extends StatefulWidget {
  final String title;

  RestaurantList({required this.title});

  @override
  _RestaurantListState createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  List<Restaurant> _restaurants = [];

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    try {

      print('object :khalkhdf  :${APIConfig.baseURL}');
      final response =
          await http.get(Uri.parse('${APIConfig.baseURL}/restaurants'));
          print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _restaurants = data.map((json) => Restaurant.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

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
                  labelText: 'Type',
                ),
                items: <String>[
                  'Italian',
                  'Chinese',
                  'Indian',
                  'Mexican',
                  'Thai'
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
                items: <String>['North', 'South', 'East', 'West', 'Central']
                    .map((String value) {
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
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.grey[900],
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
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
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.deepOrange, Colors.orangeAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Search for restaurants',
                          labelStyle: TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors
                                  .deepOrange, // Set the border color here
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors
                                  .deepOrange, // Set the border color when the TextField is enabled
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors
                                  .orangeAccent, // Set the border color when the TextField is focused
                              width: 2,
                            ),
                          ),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.white70),
                          filled: true,
                          fillColor: Colors.grey[800],
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.deepOrange, Colors.orangeAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () => _showFilterDialog(context),
                        color: Colors.white, // Ensure the icon is visible
                      ),
                    ),
                  ],
                ),
              ),
              RestaurantListWidget(
                restaurants: _restaurants,
                onTap: (Restaurant restaurant) {
                  Navigator.of(context).push(
                    createFadeRoute(
                        RestaurantDetailPage(restaurant: restaurant, restaurantId: restaurant.id,)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
