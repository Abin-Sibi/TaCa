import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:taca/config/api_config.dart';
import 'package:taca/controllers/auth_controller.dart';
import 'package:taca/utils/route_utils.dart';
import 'success_page.dart';

class ConfirmationPage extends StatelessWidget {
  final String restaurantName;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final List<Map<String, dynamic>> tableData; // Updated
  final String restaurantId;

  ConfirmationPage({
    required this.restaurantName,
    required this.selectedDate,
    required this.selectedTime,
    required this.tableData,
    required this.restaurantId,
  });

  /// Displays a dialog with two options: Confirm with Payment and Confirm without Payment
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: Text(
            'Confirm Reservation',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Choose how you would like to confirm your reservation:',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            // Confirm without Payment Button
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
                _createBooking(context, withPayment: false);
              },
              child: Text(
                'Confirm without Payment',
                style: TextStyle(color: Colors.orangeAccent),
              ),
            ),
            // Confirm with Payment Button
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
                _createBooking(context, withPayment: true);
              },
              child: Text(
                'Confirm with Payment',
                style: TextStyle(color: Colors.orangeAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Creates a booking with the option to include payment details
  Future<void> _createBooking(BuildContext context, {required bool withPayment}) async {
    try {
      final String bookingDate = selectedDate.toIso8601String().split('T')[0];
      final String bookingTimeSlot =
          '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}-'
          '${(selectedTime.hour + (withPayment ? 2 : 1)).toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
      
      final AuthController authController = Get.find<AuthController>();
      final userDetails = authController.userDetails.value; // Replace with actual user details

      // Extract table IDs from the selected table data
      final List<String> tableIds = tableData.map((table) => table['_id'] as String).toList();

      // Prepare additional booking details based on payment option
      final Map<String, dynamic> bookingDetails = {
        'userId': "${userDetails['_id'] ?? 'Unknown'}",
        'restaurantId': restaurantId,
        'tableIds': tableIds, // Sending multiple table IDs
        'bookingDate': bookingDate,
        'bookingTimeSlot': bookingTimeSlot,
        'withPayment': withPayment, // Indicates if payment is required
        'reservationDuration': withPayment ? '2h' : '1h',
        'ownerWillContact': withPayment,
        'latePolicy': withPayment
            ? '15 minutes grace period, reservation held for 2 hours'
            : '15 minutes grace period, reservation held for 1 hour and can be released to others if late',
      };

      final response = await http.post(
        Uri.parse('${APIConfig.baseURL}/create'), // Adjust the URL as needed
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bookingDetails),
      );

      if (response.statusCode == 201) {
        Navigator.of(context).push(createFadeRoute(SuccessPage()));
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create booking: ${responseData['message']}')),
        );
      }
    } catch (e) {
      print('Error creating booking: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while creating the booking.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Restaurant ID: $restaurantId');
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Reservation'),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Container(
        color: Colors.grey[900],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reservation Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.grey[800],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Restaurant: $restaurantName',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Date: ${selectedDate.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Time: ${selectedTime.format(context)}',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Table(s): ${tableData.map((table) => 'Table ${table['tableNumber']} (${table['chairs']} chairs)').join(', ')}',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Divider(color: Colors.grey[600]),
                    SizedBox(height: 10),
                    Text(
                      'Additional Information:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Please arrive 10 minutes before the reservation time.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Your table will be held for 15 minutes past the reservation time.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Free Wi-Fi is available for all guests.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepOrange, Colors.orangeAccent],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: () => _showConfirmationDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Confirm Reservation',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
