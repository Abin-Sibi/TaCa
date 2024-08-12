// lib/table_selection_page.dart
import 'package:flutter/material.dart';
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
  Set<int> _selectedTables = Set<int>();

  Widget buildTable(int tableNumber) {
    return GestureDetector(
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
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: _selectedTables.contains(tableNumber) ? Colors.red.withOpacity(0.3) : Colors.grey[700]!.withOpacity(0.3),
          border: Border.all(
            color: _selectedTables.contains(tableNumber) ? Colors.red : Colors.grey[700]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 4,
              child: Transform.rotate(
                angle: 0,
                child: Icon(Icons.chair, color: Colors.grey),
              ),
            ),
            Positioned(
              bottom: 4,
              child: Transform.rotate(
                angle: 3.14,
                child: Icon(Icons.chair, color: Colors.grey),
              ),
            ),
            Positioned(
              left: 4,
              child: Transform.rotate(
                angle: 3.14 / 2,
                child: Icon(Icons.chair, color: Colors.grey),
              ),
            ),
            Positioned(
              right: 4,
              child: Transform.rotate(
                angle: -3.14 / 2,
                child: Icon(Icons.chair, color: Colors.grey),
              ),
            ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _selectedTables.contains(tableNumber) ? Colors.red : Colors.grey[700],
                borderRadius: BorderRadius.circular(8),
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Table at ${widget.restaurantName}'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Your Table',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: List.generate(14, (index) => buildTable(index + 1)),
              ),
            ),
            if (_selectedTables.isNotEmpty)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(createFadeRoute(ConfirmationPage(
                          restaurantName: widget.restaurantName,
                          selectedDate: widget.selectedDate,
                          selectedTime: widget.selectedTime,
                          tableNumbers: _selectedTables.toList(), // Pass the selected tables
                        )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    child: Text(
                      'Confirm Reservation',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
