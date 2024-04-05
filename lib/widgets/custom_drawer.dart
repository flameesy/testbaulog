import 'package:flutter/material.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.orange, // Orange color for header
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Image.asset(
                    'assets/logo.png', // Pfad zum Bild
                    height: 32, // Festlegen der Höhe des Bildes
                  ),
                ),
                const Text(
                  'Menü',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
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
              _navigateTo(context, '/mail');
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.email,
            title: 'Email-Templates',
            onTap: () {
              _navigateTo(context, '/templates');
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
          ),_buildMenuItem(
            context,
            icon: Icons.map,
            title: 'Bestellung',
            onTap: () {
              _navigateTo(context, '/order');
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
          _buildMenuItem(
            context,
            icon: Icons.map,
            title: 'Logout',
            onTap: () {
              _navigateTo(context, '/login');
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
