// lib/caterer_detail_page.dart
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
    {'name': 'Chicken Biryani', 'image': 'assets/images/chicken_biriyani.jpeg', 'price': 200, 'type': 'Non-Veg', 'cuisine': 'Indian'},
    {'name': 'Veg Fried Rice', 'image': 'assets/images/veg_friedrice.png', 'price': 150, 'type': 'Veg', 'cuisine': 'Chinese'},
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
          (searchQuery.isNotEmpty && !item['name'].toLowerCase().contains(searchQuery.toLowerCase()))) {
        return false;
      }
      return true;
    }).toList();

    double totalAmount = cartItems.fold(0, (sum, item) => sum + item['price'] * item['quantity']);

    return Scaffold(
      appBar: AppBar(
        title: Text(caterer['name']),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Menu',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            SizedBox(height: 10),
            // Filter Options and Search Bar
            Row(
              children: [
                DropdownButton<String>(
                  hint: Text('Type'),
                  value: selectedType,
                  items: ['Veg', 'Non-Veg'].map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  hint: Text('Cuisine'),
                  value: selectedCuisine,
                  items: ['Indian', 'Chinese', 'Arabic'].map((cuisine) {
                    return DropdownMenuItem<String>(
                      value: cuisine,
                      child: Text(cuisine),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCuisine = value;
                    });
                  },
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredMenuItems.length,
                itemBuilder: (context, index) {
                  final item = filteredMenuItems[index];
                  return Card(
                    child: ListTile(
                      leading: Image.asset(item['image'], width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(item['name']),
                      subtitle: Text('₹${item['price']} per plate'),
                      trailing: Icon(Icons.add),
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
                                      cartItems.add({'name': item['name'], 'price': item['price'], 'quantity': numberOfPeople});
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
            ),
          ],
        ),
      ),
      floatingActionButton: cartItems.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Cart',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                          ),
                          SizedBox(height: 10),
                          ...cartItems.map((item) {
                            return ListTile(
                              title: Text('${item['name']} (x${item['quantity']})'),
                              subtitle: Text('₹${item['price'] * item['quantity']}'),
                            );
                          }).toList(),
                          SizedBox(height: 10),
                          Text(
                            'Total: ₹$totalAmount',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Handle payment process
                              Navigator.of(context).push(createFadeRoute(BookingStatusPage()));
                            },
                            child: Text('Proceed to Book'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.shopping_cart),
              label: Text('${cartItems.length} items'),
            )
          : null,
    );
  }
}
