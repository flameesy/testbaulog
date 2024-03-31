import 'package:flutter/material.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orange, // Orange color for header
            ),
            child: Text(
              'Menü',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _buildMenuItem(
            context,
            icon: Icons.home,
            title: 'Startseite',
            onTap: () {
              _navigateTo(context, '/');
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.calendar_today,
            title: 'Termine',
            onTap: () {
              _navigateTo(context, '/termine');
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.email,
            title: 'Email',
            onTap: () {
              _navigateTo(context, '/email');
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.room,
            title: 'Räume',
            onTap: () {
              _navigateTo(context, '/rooms');
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.map,
            title: 'Karten',
            onTap: () {
              _navigateTo(context, '/karten');
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.settings,
            title: 'Einstellungen',
            onTap: () {
              _navigateTo(context, '/einstellungen');
            },
          ),
          // Add more menu items as needed
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange), // Icon color set to orange
      title: Text(
        title,
        style: TextStyle(color: Colors.grey[800]), // Text color set to grey
      ),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, String routeName) {
    Navigator.pop(context); // Close the drawer first
    Navigator.pushNamed(context, routeName); // Navigate to the specified route
  }
}
