import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Color backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    required this.backgroundColor,
    required this.selectedItemColor,
    required this.unselectedItemColor,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting, // Enable shifting animation
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: backgroundColor, // Set the default background color
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      items: [
        _buildBottomNavigationBarItem(
          icon: Icons.home,
          label: 'Home',
          index: 0,
        ),
        _buildBottomNavigationBarItem(
          icon: Icons.history,
          label: 'History',
          index: 1,
        ),
        _buildBottomNavigationBarItem(
          icon: Icons.notifications,
          label: 'Notifications',
          index: 2,
        ),
        _buildBottomNavigationBarItem(
          icon: Icons.person,
          label: 'Profile',
          index: 3,
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isSelected = currentIndex == index;

    return BottomNavigationBarItem(
      icon: isSelected
          ? ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Colors.deepOrange, Colors.orangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Icon(
                icon,
                color: Colors.white, // The gradient will override this color
              ),
            )
          : Icon(
              icon,
              color: unselectedItemColor,
            ),
      label: label,
      backgroundColor: backgroundColor, // Set individual background color
    );
  }
}
