import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:taca/caterer_details_page.dart';
import 'package:taca/config/api_config.dart';
import 'package:taca/utils/route_utils.dart';

class CateringHomePage extends StatefulWidget {
  @override
  _CateringHomePageState createState() => _CateringHomePageState();
}

class _CateringHomePageState extends State<CateringHomePage> {
  final List<Map<String, dynamic>> categories = [
    {'name': 'Corporate Events', 'icon': Icons.business},
    {'name': 'Weddings', 'icon': Icons.cake},
    {'name': 'Parties', 'icon': Icons.party_mode},
    {'name': 'Other Events', 'icon': Icons.event},
  ];

  List<Map<String, dynamic>> caterers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCaterers();
  }

  Future<void> fetchCaterers() async {
    final url = Uri.parse('${APIConfig.baseURL}/caterers');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('object  $data');
        setState(() {
          caterers = data.map((caterer) {
            return {
              'name': caterer['serviceName'],
              'rating': caterer['ratings'],
              'location':caterer['location'],
              'image': 'assets/images/caterer2.jpeg',
              'catId':caterer['_id'], // Placeholder image path
            };
          }).toList();
          isLoading = false;
        });
      } else {
        // Handle error
        print('Failed to load caterers');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle exception
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            color: Colors.white,
          ),
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [const Color.fromARGB(255, 255, 254, 254), const Color.fromARGB(255, 255, 255, 255)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            'Catering Services',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Color(0xFF2C2C2C),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.deepOrange, Colors.orangeAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'Choose Your Event Type',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Select from the categories below to explore catering services that best suit your event.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 16),
                    // Category Selection
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle category selection
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black54,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.all(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(category['icon'], color: Colors.white, size: 30),
                                  SizedBox(height: 8),
                                  Text(
                                    category['name'],
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.deepOrange, Colors.orangeAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'Available Caterers',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Caterers Grid
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 300,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: caterers.length,
                        itemBuilder: (context, index) {
                          final caterer = caterers[index];
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
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(createFadeRoute(CatererDetailPage(caterer: caterer)));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                                        child: Image.asset(
                                          caterer['image'],
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
                                          caterer['name'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.star, color: Colors.amber, size: 16),
                                          SizedBox(width: 4),
                                          Text(
                                            '${caterer['rating']}',
                                            style: TextStyle(fontSize: 16, color: Colors.white),
                                          ),
                                        ],
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
            ),
    );
  }
}
