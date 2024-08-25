import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taca/config/api_config.dart';
import 'package:taca/utils/route_utils.dart';
import 'confirmation_page.dart';

class TableSelectionPage extends StatefulWidget {
  final String restaurantName;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String restaurantId;

  TableSelectionPage({
    required this.restaurantName,
    required this.selectedDate,
    required this.selectedTime,
    required this.restaurantId,
  });

  @override
  _TableSelectionPageState createState() => _TableSelectionPageState();
}

class _TableSelectionPageState extends State<TableSelectionPage> {
  List<Map<String, dynamic>> _tables = [];
  Set<Map<String, dynamic>> _selectedTables = Set<Map<String, dynamic>>();
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchTables();
  }

  Future<void> _fetchTables() async {
    try {
      final response = await http.get(Uri.parse(
          '${APIConfig.baseURL}/restaurants')); // Adjust the URL as needed
      if (response.statusCode == 200) {
        List<dynamic> tableData = jsonDecode(response.body);

        // Find the restaurant with the specified name and get its tables
        Map<String, dynamic>? restaurantWithTables = tableData.firstWhere(
            (restaurant) =>
                restaurant['name'] == widget.restaurantName &&
                restaurant['tables'] != null &&
                (restaurant['tables'] as List).isNotEmpty,
            orElse: () =>
                null // Default value if no restaurant with the name is found
            );

        if (restaurantWithTables != null) {
          DateTime selectedDateTime = DateTime(
            widget.selectedDate.year,
            widget.selectedDate.month,
            widget.selectedDate.day,
            widget.selectedTime.hour,
            widget.selectedTime.minute,
          ).toUtc();

          setState(() {
            _tables =
                (restaurantWithTables['tables'] as List<dynamic>).map((table) {
              Map<String, dynamic> tableMap = table as Map<String, dynamic>;
              // Print the entire table map to see its structure
              print('aaakkkoo $tableMap');

              // Print the booking details to inspect what's inside
              print(tableMap['bookingDetails']);
              if (tableMap['bookingDetails'] != null) {
                DateTime bookedFrom =
                    DateTime.parse(tableMap['bookingDetails']['bookedFrom']);
                DateTime bookedTo =
                    DateTime.parse(tableMap['bookingDetails']['bookedTo']);
                print(
                    'helooo selectdateee:  $selectedDateTime $bookedTo $bookedFrom hello:  ${selectedDateTime.isAfter(bookedFrom)}  ke;;ppp:  ${selectedDateTime.isBefore(bookedTo)}');
                // Check if the selected date and time overlaps with the booked time
                if (selectedDateTime.isAfter(bookedFrom) &&
                    selectedDateTime.isBefore(bookedTo)) {
                  print('i am herreee');
                  tableMap['isBooked'] = true;
                }
              }
              return tableMap;
            }).toList();
          });
        } else {
          setState(() {
            _errorMessage = 'No tables found for the selected restaurant.';
          });
        }
      } else {
        throw Exception('Failed to load tables');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget buildTable(Map<String, dynamic> table) {
    int tableNumber = table['tableNumber'];
    int chairCount = table['chairs'];
    bool isBooked = table['isBooked'] ?? false;

    double baseTableSize = 50.0;
    double tableSize = baseTableSize + (chairCount - 1) * 10.0;
    double chairSize = 18.0;
    double borderPadding = 8.0;

    double xPos = table['position']['x']?.toDouble() ?? 0.0;
    double yPos = table['position']['y']?.toDouble() ?? 0.0;

    bool isSelected = _selectedTables.any((selectedTable) => selectedTable['_id'] == table['_id']);

    return Positioned(
      left: xPos,
      top: yPos,
      child: GestureDetector(
        onTap: () {
          if (!isBooked) {
            setState(() {
              Map<String, dynamic> selectedTable = {
                '_id': table['_id'],
                'tableNumber': tableNumber,
                'chairs': chairCount,
              };

              if (isSelected) {
                _selectedTables.removeWhere((selectedTable) => selectedTable['_id'] == table['_id']);
              } else {
                _selectedTables.add(selectedTable);
              }
            });
          }
        },
        child: Container(
          padding: EdgeInsets.all(borderPadding),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: tableSize,
                height: tableSize,
                decoration: BoxDecoration(
                  gradient: isBooked
                      ? LinearGradient(
                          colors: [Colors.grey, Colors.grey],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : isSelected
                          ? LinearGradient(
                              colors: [Colors.deepOrange, Color.fromARGB(255, 244, 149, 27)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : LinearGradient(
                              colors: [Color.fromARGB(255, 250, 197, 128), Color.fromARGB(255, 249, 125, 87)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$tableNumber',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              for (int i = 0; i < chairCount; i++)
                Positioned(
                  left: (tableSize / 2 - chairSize / 2) +
                      (tableSize / 2 - chairSize / 2) *
                          math.cos(2 * math.pi * i / chairCount),
                  top: (tableSize / 2 - chairSize / 2) +
                      (tableSize / 2 - chairSize / 2) *
                          math.sin(2 * math.pi * i / chairCount),
                  child: Transform.rotate(
                    angle: 2 *
                        math.pi *
                        i /
                        chairCount,
                    child: Icon(Icons.chair_rounded,
                        size: chairSize,
                        color: const Color.fromARGB(255, 4, 4, 4)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Table at ${widget.restaurantName}'),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      backgroundColor: Colors.grey[900],
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Text(_errorMessage,
                      style: TextStyle(color: Colors.white)))
              : Stack(
                  children: _tables.map((table) => buildTable(table)).toList(),
                ),
      floatingActionButton: _selectedTables.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  createFadeRoute(
                    ConfirmationPage(
                      restaurantName: widget.restaurantName,
                      selectedDate: widget.selectedDate,
                      selectedTime: widget.selectedTime,
                      tableData: _selectedTables.toList(),
                      restaurantId:widget.restaurantId,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepOrange, Colors.orangeAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.all(15.0),
                child: Icon(Icons.check, color: Colors.white),
              ),
              backgroundColor: Colors
                  .transparent, // Make the FAB transparent to show the gradient
            )
          : null,
    );
  }
}
