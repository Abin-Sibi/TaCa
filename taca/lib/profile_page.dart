import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/lake.jpeg'), // Replace with user's profile image
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Abin Sibi',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'abin.sibi@example.com',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '123-456-7890',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            // Options List
            Expanded(
              child: ListView(
                children: [
                  ProfileOption(
                    icon: Icons.bookmark,
                    title: 'My Reservations',
                    onTap: () {
                      Navigator.pushNamed(context, '/reservations');
                    },
                  ),
                  ProfileOption(
                    icon: Icons.notifications,
                    title: 'Notification Settings',
                    onTap: () {
                      Navigator.pushNamed(context, '/notification_settings');
                    },
                  ),
                  ProfileOption(
                    icon: Icons.settings,
                    title: 'Account Settings',
                    onTap: () {
                      Navigator.pushNamed(context, '/account_settings');
                    },
                  ),
                  ProfileOption(
                    icon: Icons.help,
                    title: 'Help & Support',
                    onTap: () {
                      Navigator.pushNamed(context, '/help_support');
                    },
                  ),
                  SizedBox(height: 20),
                  // Logout Button
                  ElevatedButton(
                    onPressed: () {
                      // Handle logout functionality
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepOrange),
      title: Text(title, style: TextStyle(fontSize: 18)),
      onTap: onTap,
    );
  }
}
