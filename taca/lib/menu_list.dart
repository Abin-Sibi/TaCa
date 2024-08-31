import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taca/config/api_config.dart';

class MenuListPage extends StatefulWidget {

  final String restaurantId;

MenuListPage(
    {required this.restaurantId});
    

  @override
  _MenuListPageState createState() => _MenuListPageState();


}

class _MenuListPageState extends State<MenuListPage> {
  List<dynamic> menuItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMenuItems();
  }

  Future<void> _fetchMenuItems() async {
    final String apiUrl = '${APIConfig.baseURL}/food/menu/${widget.restaurantId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          menuItems = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching menu items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Gradient borderGradient = LinearGradient(
      colors: [Colors.deepOrange, Colors.orangeAccent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.grey[900],
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  var menuItem = menuItems[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    elevation: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2.0,
                          style: BorderStyle.solid,
                          color: Colors.transparent,
                        ),
                        gradient: borderGradient,
                      ),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          menuItem['image'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.memory(
                                    base64Decode(menuItem['image'].split(',').last),
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  height: 150,
                                  color: Colors.grey,
                                  child: Icon(Icons.image, color: Colors.white, size: 50),
                                ),
                          SizedBox(height: 10),
                          Text(
                            menuItem['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            menuItem['description'],
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Price: ₹${menuItem['price']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
