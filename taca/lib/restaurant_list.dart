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
  List<Restaurant> _filteredRestaurants = [];
  List<Restaurant> _restaurantRec = [];
  List<Restaurant> _filteredRestaurantsRec = [];
  String _searchQuery = '';
  String _selectedType = '';
  String _selectedCategory = '';
  String _selectedGeography = '';

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
    fetchFilteredRestaurants();
  }

  Future<void> fetchRestaurants() async {
    try {
      final response = await http.get(Uri.parse('${APIConfig.baseURL}/restaurants'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _restaurants = data.map((json) => Restaurant.fromJson(json)).toList();
          _filteredRestaurants = _restaurants;
        });
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e, stackTrace) {
      print('Error occurred: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> fetchFilteredRestaurants() async {
    try {
      final response = await http.get(Uri.parse('${APIConfig.baseURL}/filtered-reviews'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _restaurantRec = data.map((json) => Restaurant.fromJson(json)).toList();
          _filteredRestaurantsRec = _restaurantRec;
        });
      } else {
        throw Exception('Failed to load recommended restaurants');
      }
    } catch (e, stackTrace) {
      print('Error occurred: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void _filterRestaurants() {
    setState(() {
      _filteredRestaurants = _restaurants.where((restaurant) {
        bool matchesSearchQuery = _searchQuery.isEmpty || 
            restaurant.name.toLowerCase().contains(_searchQuery.toLowerCase());

        bool matchesType = _selectedType.isEmpty || 
            restaurant.type == _selectedType;

        bool matchesCategory = _selectedCategory.isEmpty || 
            restaurant.category == _selectedCategory;

        bool matchesGeography = _selectedGeography.isEmpty || 
            restaurant.geography == _selectedGeography;

        return matchesSearchQuery && matchesType && matchesCategory && matchesGeography;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _filterRestaurants();
  }

  void _onFilterApplied(BuildContext dialogContext) {
    _filterRestaurants();
    Navigator.of(dialogContext).pop();
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
                decoration: InputDecoration(labelText: 'Type'),
                value: _selectedType.isEmpty ? null : _selectedType,
                items: <String>['', 'Italian', 'Chinese', 'Indian', 'Mexican', 'Thai']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.isEmpty ? 'All' : value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  _selectedType = newValue ?? '';
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Category'),
                value: _selectedCategory.isEmpty ? null : _selectedCategory,
                items: <String>[
                  '', 'Vegetarian', 'Non-Vegetarian', 'Vegan', 'Gluten-Free', 'Halal',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.isEmpty ? 'All' : value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  _selectedCategory = newValue ?? '';
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Geography'),
                value: _selectedGeography.isEmpty ? null : _selectedGeography,
                items: <String>['', 'North', 'South', 'East', 'West', 'Central']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.isEmpty ? 'All' : value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  _selectedGeography = newValue ?? '';
                },
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
              onPressed: () => _onFilterApplied(context),
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
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.grey[900],
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Recommended for you',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CarouselSlider.builder(
                itemCount: _filteredRestaurantsRec.isNotEmpty ? _filteredRestaurantsRec.length : 1,
                options: CarouselOptions(
                  height: 250.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
                itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                  if (_filteredRestaurantsRec.isEmpty) {
                    return Center(
                      child: Text(
                        'No recommendations available',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  final restaurant = _filteredRestaurantsRec[itemIndex];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        createFadeRoute(RestaurantDetailPage(
                          restaurant: restaurant,
                          restaurantId: restaurant.id,
                        )),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [Colors.deepOrange, Colors.orangeAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Card(
                        color: Colors.grey[850],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                restaurant.name,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                restaurant.place,
                                style: TextStyle(color: Colors.white70),
                              ),
                              trailing: Text(
                                '${restaurant.averageRating}/5',
                                style: TextStyle(color: Colors.yellowAccent),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Type: ${restaurant.type} | Category: ${restaurant.category} | Geography: ${restaurant.geography}',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
                              color: Colors.deepOrange,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.orangeAccent,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          prefixIcon: Icon(Icons.search, color: Colors.white70),
                        ),
                        style: TextStyle(color: Colors.white),
                        onChanged: _onSearchChanged,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.filter_list, color: Colors.white),
                      onPressed: () => _showFilterDialog(context),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _filteredRestaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = _filteredRestaurants[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        createFadeRoute(RestaurantDetailPage(
                          restaurant: restaurant,
                          restaurantId: restaurant.id,
                        )),
                      );
                    },
                    child: RestaurantListWidget(
                restaurants: _filteredRestaurants,
                onTap: (Restaurant restaurant) {
                  Navigator.of(context).push(
                    createFadeRoute(RestaurantDetailPage(
                      restaurant: restaurant,
                      restaurantId: restaurant.id,
                    )),
                  );
                },
              ),

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
