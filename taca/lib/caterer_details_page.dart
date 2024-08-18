import 'package:flutter/material.dart';
import 'package:taca/booking_status_page.dart';
import 'package:taca/utils/route_utils.dart';

class CatererDetailPage extends StatefulWidget {
  final Map<String, dynamic> caterer;

  CatererDetailPage({required this.caterer});

  @override
  _CatererDetailPageState createState() => _CatererDetailPageState();
}

class _CatererDetailPageState extends State<CatererDetailPage> {
  List<Map<String, dynamic>> menuItems = [
    {
      'name': 'Chicken Biryani',
      'image': 'assets/images/chicken_biriyani.jpeg',
      'price': 200,
      'type': 'Non-Veg',
      'cuisine': 'Indian'
    },
    {
      'name': 'Veg Fried Rice',
      'image': 'assets/images/veg_friedrice.png',
      'price': 150,
      'type': 'Veg',
      'cuisine': 'Chinese'
    },
    // Add more menu items here
  ];

  String? selectedType;
  String? selectedCuisine;
  String searchQuery = '';
  List<Map<String, dynamic>> cartItems = [];

  @override
  Widget build(BuildContext context) {
    final caterer = widget.caterer;

    List<Map<String, dynamic>> filteredMenuItems = menuItems.where((item) {
      if ((selectedType != null && item['type'] != selectedType) ||
          (selectedCuisine != null && item['cuisine'] != selectedCuisine) ||
          (searchQuery.isNotEmpty &&
              !item['name']
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))) {
        return false;
      }
      return true;
    }).toList();

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
      body: SingleChildScrollView(
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
  padding: EdgeInsets.all(8.0), // Add padding around the text
  decoration: BoxDecoration(
    color: Color.fromARGB(182, 0, 0, 0), // Background color
    borderRadius: BorderRadius.circular(8.0), // Border radius for the background
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
                    caterer['description'] ??
                        'No description available.', // Replace with caterer description
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

                  // Filter Options and Search Bar
                  Row(
                    children: [
                      DropdownButton<String>(
                        dropdownColor: Colors.grey[800],
                        hint:
                            Text('Type', style: TextStyle(color: Colors.white)),
                        value: selectedType,
                        items: ['Veg', 'Non-Veg'].map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type,
                                style: TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedType = value;
                          });
                        },
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      DropdownButton<String>(
                        dropdownColor: Colors.grey[800],
                        hint: Text('Cuisine',
                            style: TextStyle(color: Colors.white)),
                        value: selectedCuisine,
                        items: ['Indian', 'Chinese', 'Arabic'].map((cuisine) {
                          return DropdownMenuItem<String>(
                            value: cuisine,
                            child: Text(cuisine,
                                style: TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCuisine = value;
                          });
                        },
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 2.0,
                              color: Colors.transparent,
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepOrange,
                                Colors.orangeAccent,
                              ],
                            ),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[800],
                            ),
                            style: TextStyle(color: Colors.white),
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Menu Items List
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredMenuItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredMenuItems[index];
                      return Card(
                        color: Colors.black,
                        child: ListTile(
                          leading: Image.asset(item['image'],
                              width: 50, height: 50, fit: BoxFit.cover),
                          title: Text(
                            item['name'],
                            style: TextStyle(
                              foreground: Paint()
                                ..shader = LinearGradient(
                                  colors: [
                                    Colors.deepOrange,
                                    Colors.orangeAccent
                                  ],
                                ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                            ),
                          ),
                          subtitle: Text('₹${item['price']} per plate',
                              style: TextStyle(color: Colors.white)),
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
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                int numberOfPeople = 0;
                                return AlertDialog(
                                  title: Text('Select Quantity'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Enter the number of people:'),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          numberOfPeople = int.parse(value);
                                        },
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          cartItems.add({
                                            'name': item['name'],
                                            'price': item['price'],
                                            'quantity': numberOfPeople
                                          });
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Add'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
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
                      Navigator.of(context).push(createFadeRoute(BookingStatusPage(
                            cartItems: cartItems,
                            caterer: caterer,
                            totalAmount: totalAmount,
                          )));
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => BookingStatusPage(
                      //       // cartItems: cartItems,
                      //       // caterer: caterer,
                      //       // totalAmount: totalAmount,
                      //     ),
                      //   ),
                      // );
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
                label: Text('View Cart (${cartItems.length})'),
                icon: Icon(Icons.shopping_cart),
                backgroundColor: Colors.transparent, // Transparent to show the gradient
                elevation: 0, // Optional: remove elevation to make it flat
              ),
            )
          : null,
    );
  }
}
