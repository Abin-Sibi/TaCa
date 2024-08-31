import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taca/booking_status_page.dart';
import 'package:taca/config/api_config.dart';
import 'package:taca/controllers/auth_controller.dart';
import 'package:taca/utils/route_utils.dart';

class ReservationHistoryPage extends StatefulWidget {
  @override
  _ReservationHistoryPageState createState() => _ReservationHistoryPageState();
}

class _ReservationHistoryPageState extends State<ReservationHistoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _reservations = [];
  List<Map<String, dynamic>> _bookings = [];

 final AuthController authController = Get.find<AuthController>();
     

  

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchReservations(); // Fetch reservations on page load
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }




@override
void didUpdateWidget(covariant ReservationHistoryPage oldWidget) {
  super.didUpdateWidget(oldWidget);
  _fetchReservations(); // Fetch reservations when the widget updates
  fetchOrderDetails();
}

  Future<void> _fetchReservations() async {
    final userDetails = authController.userDetails.value;
    final response = await http.get(Uri.parse('${APIConfig.baseURL}/history/${userDetails['_id']}'));
    
     // Replace with your API URL

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _reservations = data.map((item) => item as Map<String, dynamic>).toList();
        
      });
    } else {
      // Handle the error case
      print('Failed to load reservations');
    }
  }

  Future<void> fetchOrderDetails() async {
    final userDetails = authController.userDetails.value;
  final response = await http.get(
    Uri.parse('${APIConfig.baseURL}/userorders/${userDetails['_id']}'), // Replace with your API endpoint
    headers: {
      'Content-Type': 'application/json',
    },
  );
  print('htis is th e response ${response.body} lkjhljlj');

  if (response.statusCode == 200) {
    // Decode the response body
    List<dynamic> data = json.decode(response.body);
      setState(() {
        _bookings = data.map((item) => item as Map<String, dynamic>).toList();
        
      });
  } else {
    print('Failed to load order details. Status code: ${response.statusCode}');
  }
}
 
  @override
  Widget build(BuildContext context) {
     final userDetails = authController.userDetails.value;
  print('heloooo $userDetails');

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Status'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Navigate to edit reservation page
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Image
          Container(
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/city2.jpeg'), // Replace with your image asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark Overlay
          Container(
            height: 300,
            color: Colors.black.withOpacity(0.5),
          ),
          // Reservation Details
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 200),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, ${userDetails['name'] ?? 'Unknown'}!",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      TabBar(
                        controller: _tabController,
                        indicatorColor: Colors.orange,
                        labelColor: Colors.orange,
                        unselectedLabelColor: Colors.white,
                        tabs: [
                          Tab(text: 'Tables Reserved'),
                          Tab(text: 'Caterings Booked'),
                        ],
                      ),
                      Container(
                        height: 550, // Adjust the height as needed
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildTablesReserved(),
                            _buildCateringsBooked(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTablesReserved() {
  return ListView.builder(
    padding: EdgeInsets.all(16.0),
    itemCount: _reservations.length,
    itemBuilder: (context, index) {
      final reservation = _reservations[index];
      return Column(
        children: [
          ReservationCard(
            restaurantName: reservation['restaurantName'] ?? 'Unknown Restaurant',
            date: reservation['date'] ?? 'Unknown Date',
            time: reservation['time'] ?? 'Unknown Time',
            seats: List<Map<String, dynamic>>.from(reservation['seats'] ?? []),
          ),
          SizedBox(height: 16), // Space between cards
        ],
      );
    },
  );
}


  Widget _buildCateringsBooked() {
  return ListView.builder(
    padding: EdgeInsets.all(16.0),
    itemCount: _bookings.length,
    itemBuilder: (context, index) {
      final bookings = _bookings[index];

      // Assuming you have the necessary data for BookingStatusPage
      final cartItems = bookings['items'] ?? [];
      final caterer = bookings['caterer'] ?? {};
      final totalAmount = bookings['totalAmount'] ?? 0.0;
      final status = bookings['status'] ?? {};
      final accepted = bookings['accepted'] ?? false;
      final completed = bookings['completed'] ?? false;

      return GestureDetector(
        onTap: () {
          // Navigate to the BookingStatusPage
          Navigator.of(context).push(createFadeRoute(BookingStatusPage(
                cartItems: List<Map<String, dynamic>>.from(cartItems),
                caterer: Map<String, dynamic>.from(caterer),
                totalAmount: totalAmount.toDouble(),
                status: Map<String, dynamic>.from(status),
                accepted: accepted,
                completed: completed,
              ),
            ),
          );
        },
        child: Column(
          children: [
            CateringCard(
              cateringName: bookings['userId'] ?? 'Unknown User',
              date: bookings['date'] ?? 'Unknown Date',
              menu: bookings['menu'] ?? 'Unknown Menu',
            ),
            SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}

}

class ReservationCard extends StatelessWidget {
  final String restaurantName;
  final String date;
  final String time;
  final List<Map<String, dynamic>> seats;

  ReservationCard({
    required this.restaurantName,
    required this.date,
    required this.time,
    required this.seats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurantName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                "Date: ",
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
              Text(
                date,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Text(
                "Time: ",
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
              Text(
                time,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "Seats: ",
            style: TextStyle(color: Colors.white.withOpacity(0.6)),
          ),
          ...seats.map((seat) {
            return Text(
              "Table ${seat['tableNumber']}: ${seat['chairs']} chairs",
              style: TextStyle(color: Colors.white),
            );
          }).toList(),
        ],
        
      ),
      
    );
    
  }
}

class CateringCard extends StatelessWidget {
  final String cateringName;
  final String date;
  final String menu;

  CateringCard({
    required this.cateringName,
    required this.date,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cateringName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                "Date: ",
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
              Text(
                date,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Text(
                "Menu: ",
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
              Text(
                menu,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
