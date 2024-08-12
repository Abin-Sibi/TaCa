import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            NotificationCard(
              title: 'New Restaurant Added!',
              message: 'A new restaurant, "Ocean View Bistro", has just opened in your area.',
              date: 'July 30, 2024',
              icon: Icons.restaurant,
              backgroundColor: Colors.green[100]!,
              iconColor: Colors.green,
            ),
            NotificationCard(
              title: 'Reservation Confirmed',
              message: 'Your reservation at "La Bella Italia" for July 31 at 7:00 PM has been confirmed.',
              date: 'July 30, 2024',
              icon: Icons.check_circle,
              backgroundColor: Colors.blue[100]!,
              iconColor: Colors.blue,
            ),
            NotificationCard(
              title: 'Reservation Reminder',
              message: 'Your reservation at "Ocean View Bistro" is coming up in 1 hour.',
              date: 'July 30, 2024',
              icon: Icons.access_time,
              backgroundColor: Colors.orange[100]!,
              iconColor: Colors.orange,
            ),
            NotificationCard(
              title: 'Reservation Updated',
              message: 'Your reservation at "Mountain Grill" has been updated to August 1 at 6:00 PM.',
              date: 'July 29, 2024',
              icon: Icons.update,
              backgroundColor: Colors.purple[100]!,
              iconColor: Colors.purple,
            ),
          ],
        ),
      ),
     
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String date;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const NotificationCard({
    required this.title,
    required this.message,
    required this.date,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: backgroundColor,
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(message),
        trailing: Text(
          date,
          style: TextStyle(color: Colors.grey),
        ),
        contentPadding: const EdgeInsets.all(16.0),
      ),
    );
  }
}
