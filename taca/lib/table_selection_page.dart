import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taca/utils/route_utils.dart';
import 'confirmation_page.dart';

class TableSelectionPage extends StatefulWidget {
  final String restaurantName;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  TableSelectionPage({
    required this.restaurantName,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  _TableSelectionPageState createState() => _TableSelectionPageState();
}

class _TableSelectionPageState extends State<TableSelectionPage> {
  List<Map<String, dynamic>> _tables = [];
  Set<int> _selectedTables = Set<int>();
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchTables();
  }

  Future<void> _fetchTables() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.5:5000/api/restaurants')); // Adjust the URL as needed
      if (response.statusCode == 200) {
        List<dynamic> tableData = jsonDecode(response.body);

        // Find the restaurant with the specified name and get its tables
        Map<String, dynamic>? restaurantWithTables = tableData.firstWhere(
          (restaurant) => restaurant['name'] == widget.restaurantName && restaurant['tables'] != null && (restaurant['tables'] as List).isNotEmpty,
          orElse: () => null // Default value if no restaurant with the name is found
        );

        if (restaurantWithTables != null) {
          setState(() {
            _tables = (restaurantWithTables['tables'] as List<dynamic>)
                .map((table) => table as Map<String, dynamic>)
                .toList();
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

    // Slightly reduced base size for table
    double baseTableSize = 50.0;

    // Calculate table size based on the number of chairs
    double tableSize = baseTableSize + (chairCount - 1) * 10.0;
    double chairSize = 18.0; // Slightly reduced size of the chairs
    double borderPadding = 8.0; // Reduced padding around the table and chairs

    // Get the position of the table from the data
    double xPos = table['position']['x']?.toDouble() ?? 0.0;
    double yPos = table['position']['y']?.toDouble() ?? 0.0;

    return Positioned(
      left: xPos,
      top: yPos,
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (_selectedTables.contains(tableNumber)) {
              _selectedTables.remove(tableNumber);
            } else {
              _selectedTables.add(tableNumber);
            }
          });
        },
        child: Container(
          padding: EdgeInsets.all(borderPadding),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Enhanced Table Container with gradient and no outer border
              Container(
                width: tableSize,
                height: tableSize,
                decoration: BoxDecoration(
                  gradient: _selectedTables.contains(tableNumber)
                      ? LinearGradient(
                          colors: [Colors.deepOrange, Colors.orangeAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [Colors.grey[700]!, Colors.grey[500]!],
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
              // Enhanced chairs with better visibility and rounded shapes
              for (int i = 0; i < chairCount; i++)
                Positioned(
                  left: (tableSize / 2 - chairSize / 2) +
                      (tableSize / 2 - chairSize / 2) *
                          math.cos(2 * math.pi * i / chairCount),
                  top: (tableSize / 2 - chairSize / 2) +
                      (tableSize / 2 - chairSize / 2) *
                          math.sin(2 * math.pi * i / chairCount),
                  child: Transform.rotate(
                    angle: 2 * math.pi * i / chairCount, // Rotate to face the table
                    child: Icon(Icons.chair_rounded, size: chairSize, color: const Color.fromARGB(255, 4, 4, 4)),
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
              ? Center(child: Text(_errorMessage, style: TextStyle(color: Colors.white)))
              : Stack(
                  children: _tables.map((table) => buildTable(table)).toList(),
                ),
      floatingActionButton: _selectedTables.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  createFadeRoute( ConfirmationPage(
                      restaurantName: widget.restaurantName,
                      selectedDate: widget.selectedDate,
                      selectedTime: widget.selectedTime,
                      tableNumbers: _selectedTables.toList(),
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
              backgroundColor: Colors.transparent, // Make the FAB transparent to show the gradient
            )
          : null,
    );
  }
}
