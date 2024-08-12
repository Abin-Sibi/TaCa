// lib/booking_status_page.dart
import 'package:flutter/material.dart';

class BookingStatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Status'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success Message Box
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 30),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Service Successfully Booked!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Status Tracker
            Text(
              'Tracking Status',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            SizedBox(height: 10),
            _buildStatusList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusList() {
    final statusItems = [
      {'status': 'Order Accepted', 'isCompleted': true},
      {'status': 'Made Call', 'isCompleted': false},
      {'status': 'Order Confirmed', 'isCompleted': false},
      {'status': 'Item Delivered', 'isCompleted': false},
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
                elevation: 3,
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
                      color: isCompleted ? Colors.black : Colors.grey,
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
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index < totalItems - 1 ? Colors.deepOrange : Colors.transparent,
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
    );
  }
}
