import 'package:flutter/material.dart';

class BookingStatusPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final Map<String, dynamic> caterer;
  final double totalAmount;
  final Map<String, dynamic> status;
  final bool accepted;
  final bool completed;

  BookingStatusPage({
    required this.cartItems,
    required this.caterer,
    required this.totalAmount,
    required this.status,
    required this.accepted,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Status'),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Details
            _buildBookingDetails(),
            SizedBox(height: 20),

            // Status Tracker
            _buildGradientHeading('Tracking Status'),
            SizedBox(height: 10),
            Expanded(child: _buildStatusList()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusList() {
    final statusItems = [
      {'status': 'Order Accepted', 'isCompleted': accepted},
      {'status': 'Packed', 'isCompleted': status['packed'] ?? false},
      {'status': 'Sent', 'isCompleted': status['sent'] ?? false},
      {'status': 'Delivered', 'isCompleted': status['delivered'] ?? false},
      {'status': 'Payment Received', 'isCompleted': status['payment'] ?? false},
    ];

    return Column(
      children: List.generate(statusItems.length, (index) {
        final item = statusItems[index];
        return _buildStatusCard(
          item['status'] as String, 
          item['isCompleted'] as bool, 
          index, 
          statusItems.length,
        );
      }),
    );
  }

  Widget _buildBookingDetails() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          _buildDetailRow('Caterer:', caterer['name'] ?? 'Unknown Caterer'),
          _buildDetailRow('Total Amount:', '\$$totalAmount'),
          SizedBox(height: 10),
          Text(
            'Items:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          ...cartItems.map((item) => _buildDetailRow(item['name'] ?? 'Unknown Item', 'x${item['quantity'] ?? 0}')),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientHeading(String text) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Colors.deepOrange, Colors.orangeAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStatusCard(String status, bool isCompleted, int index, int totalItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildStatusIndicator(index, totalItems, isCompleted),
            SizedBox(width: 10),
            Expanded(
              child: Card(
                color: Colors.black,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (index < totalItems - 1) // Add space between items
          SizedBox(height: 20),
      ],
    );
  }

  Widget _buildStatusIndicator(int index, int totalItems, bool isCompleted) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? Colors.deepOrange : Colors.transparent,
            border: Border.all(
              color: isCompleted ? Colors.deepOrange : Colors.grey,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? Icon(Icons.check, color: Colors.white, size: 16)
                : Container(),
          ),
        ),
        if (index < totalItems - 1)
          Container(
            width: 2,
            height: 50,
            color: Colors.deepOrange,
          ),
      ],
    );
  }
}
