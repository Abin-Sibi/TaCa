import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:taca/booking_status_page.dart';
import 'package:taca/config/api_config.dart';
import 'package:taca/controllers/auth_controller.dart';
import 'package:taca/utils/route_utils.dart';

class CatererDetailPage extends StatefulWidget {
  final Map<String, dynamic> caterer;
 

  CatererDetailPage({required this.caterer});

  @override
  _CatererDetailPageState createState() => _CatererDetailPageState();
}

class _CatererDetailPageState extends State<CatererDetailPage> {
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> cartItems = [];
  String? selectedType;
  String? selectedCuisine;
  String searchQuery = '';
  Map<String, bool> expandedCategories = {};
  bool isLoading = true; // Loading state


  @override
  void initState() {
    super.initState();
    print('Received caterer: ${widget.caterer}');
    print('Received catId: ${widget.caterer['catId']}');
    fetchCategories();
  }

  // Function to fetch categories and dishes from the API


  Future<void> fetchCategories() async {
    print('88888888,${widget.caterer}');
    final response = await http.get(Uri.parse('${APIConfig.baseURL}/menu/${widget.caterer['catId']}')); // Replace with your API endpoint

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      setState(() {
        categories = data.map<Map<String, dynamic>>((category) {
          return {
            'category': category['category'],
            'description': category['description'] ?? '',
            'location': category['location'] ?? '',
            'dishes': category['dishes'].map<Map<String, dynamic>>((dish) {
              return {
                'name': dish['name'],
                'price': dish['price'],
                'image': dish['image'],
              };
            }).toList(),
          };
        }).toList();
        isLoading = false; // Stop loading
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false; // Stop loading even if there's an error
      });
      print('Failed to load categories');
    }
  }

  // Function to handle the booking process
  Future<void> confirmBooking(double currentTotalAmount) async {
     final AuthController authController = Get.find<AuthController>();
     final userDetails = authController.userDetails.value; 
    final userId = '${userDetails['_id'] ?? 'Unknown'}'; // Replace with the actual user ID
    final catererId = widget.caterer['catId'];
    
    final bookingData = {
      'userId': userId,
      'catererId': catererId,
      'totalAmount': currentTotalAmount,
      'items': cartItems,
    };
    print("object ${bookingData}");

    final response = await http.post(
      Uri.parse('${APIConfig.baseURL}/orders'), // Replace with your API endpoint
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(bookingData),
    );
    print(response.body);

 

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);

  // Extract the order details from the response
  final orderData = jsonResponse['order'];
  final status = orderData['status'] as Map<String, dynamic>;
  final accepted = orderData['accepted'] as bool;
  final completed = orderData['completed'] as bool;
      // Handle success
      Navigator.of(context).push(createFadeRoute(BookingStatusPage(
        cartItems: cartItems,
        caterer: widget.caterer,
        totalAmount: currentTotalAmount,
         status: status, // Pass the status map
    accepted: accepted, // Pass the accepted value
    completed: completed, // Pass the completed value
      )));
    } else {
      // Handle error
      print('Failed to create booking');
    }
  }

  @override
  Widget build(BuildContext context) {
    final caterer = widget.caterer;

    double totalAmount = cartItems.fold(
        0, (sum, item) => sum + item['price'] * item['quantity']);

    return Scaffold(
      appBar: AppBar(
        title: Text(caterer['name']),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      backgroundColor: Colors.grey[900],
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner with Caterer Name
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 6,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/caterer1.jpeg'), // Replace with your banner image asset
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 16,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(182, 0, 0, 0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            caterer['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Caterer Description and Location
                        Text(
                          'About',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [Colors.deepOrange, Colors.orangeAccent],
                              ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          caterer['description'] ?? 'No description available.',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.white),
                            SizedBox(width: 4),
                            Text(caterer['location'] ?? 'Location not available',
                                style: TextStyle(fontSize: 16, color: Colors.white)),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Menu Heading
                        Text(
                          'Menu',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [Colors.deepOrange, Colors.orangeAccent],
                              ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                          ),
                        ),
                        SizedBox(height: 10),

                        // Category Cards with Collapsible Items
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> category = categories[index];
                            bool isExpanded = expandedCategories[category['category']] ?? false;

                            return Card(
                              color: Colors.black,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      category['category'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    trailing: Icon(
                                      isExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        expandedCategories[category['category']] = !isExpanded;
                                      });
                                    },
                                  ),
                                  if (isExpanded)
                                    Column(
                                      children: category['dishes']
                                          .map<Widget>((dish) => ListTile(
                                                leading: Image.memory(
                                                    base64Decode(dish['image'].split(',')[1]),
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.cover),
                                                title: Text(
                                                  dish['name'],
                                                  style: TextStyle(
                                                    foreground: Paint()
                                                      ..shader = LinearGradient(
                                                        colors: [
                                                          Colors.deepOrange,
                                                          Colors.orangeAccent
                                                        ],
                                                      ).createShader(Rect.fromLTWH(
                                                          0, 0, 200, 70)),
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  '₹${dish['price']} per plate',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                                trailing: ShaderMask(
                                                  shaderCallback: (Rect bounds) {
                                                    return LinearGradient(
                                                      colors: [
                                                        Colors.deepOrange,
                                                        Colors.orangeAccent
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    ).createShader(bounds);
                                                  },
                                                  child: Icon(Icons.add,
                                                      color: Colors.white),
                                                ),
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      int numberOfPeople = 0;
                                                      return AlertDialog(
                                                        title: Text('Select Quantity'),
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                                'Enter the number of people:'),
                                                            TextField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              onChanged: (value) {
                                                                numberOfPeople =
                                                                    int.parse(value);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context)
                                                                  .pop();
                                                            },
                                                            child: Text('Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                cartItems.add({
                                                                  'name': dish['name'],
                                                                  'price':
                                                                      dish['price'],
                                                                  'quantity':
                                                                      numberOfPeople
                                                                });
                                                              });
                                                              Navigator.of(context)
                                                                  .pop();
                                                            },
                                                            child: Text('Add'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ))
                                          .toList(),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: cartItems.isNotEmpty
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepOrange, Colors.orangeAccent],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: FloatingActionButton.extended(
                onPressed: () {
                  showModalBottomSheet(
  context: context,
  builder: (BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        double currentTotalAmount = totalAmount;

        return Container(
          padding: EdgeInsets.all(16.0),
          color: Colors.black,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Items',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartItems[index];
                  return ListTile(
                    title: Text(
                      cartItem['name'],
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    subtitle: Text(
                      'Quantity: ${cartItem['quantity']}, Price: ₹${cartItem['price'] * cartItem['quantity']}',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                      onPressed: () {
                        setModalState(() {
                          currentTotalAmount -= cartItem['price'] * cartItem['quantity'];
                          cartItems.removeAt(index);
                        });

                        if (cartItems.isEmpty) {
                          Navigator.pop(context);
                          setState(() {});
                        } else {
                          setState(() {
                            totalAmount = currentTotalAmount;
                          });
                        }
                      },
                    ),
                  );
                },
              ),
              Divider(color: Colors.white),
              Text(
                'Total: ₹$currentTotalAmount',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepOrange, Colors.orangeAccent],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      confirmBooking(currentTotalAmount);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      backgroundColor: Colors.transparent, // Transparent to show the gradient
                      shadowColor: Colors.transparent, // Remove shadow
                    ),
                    child: Text('Confirm Booking'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  },
);

                },
                label: Text('View Cart'),
                icon: Icon(Icons.shopping_cart),
                backgroundColor: const Color.fromARGB(0, 247, 246, 246),
                highlightElevation: 0.0,
                elevation: 0.0,
              ),
            )
          : null,
    );
  }
}
