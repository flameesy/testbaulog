import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';

class HomePage extends StatelessWidget {
  final Database database;

  const HomePage({Key? key, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              _buildNavigationTile(
                context,
                icon: Icons.calendar_today,
                title: 'Termine',
                onTap: () {
                  _navigateTo(context, '/termine');
                },
              ),
              _buildNavigationTile(
                context,
                icon: Icons.email,
                title: 'Email',
                onTap: () {
                  _navigateTo(context, '/mail');
                },
              ),
              _buildNavigationTile(
                context,
                icon: Icons.subject,
                title: 'Email-Templates',
                onTap: () {
                  _navigateTo(context, '/templates');
                },
              ),
              _buildNavigationTile(
                context,
                icon: Icons.business,
                title: 'Räume',
                onTap: () {
                  _navigateTo(context, '/rooms');
                },
              ),
              _buildNavigationTile(
                context,
                icon: Icons.reorder,
                title: 'Bestellung',
                onTap: () {
                  _navigateTo(context, '/order');
                },
              ),
              _buildNavigationTile(
                context,
                icon: Icons.import_export,
                title: 'Export',
                onTap: () {
                  _navigateTo(context, '/einstellungen');
                },
              ),
              _buildNavigationTile(
                context,
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {
                  _navigateTo(context, '/login');
                },
              ),
            ],
          ),
        ),
      ),
      drawer: const CustomAppDrawer(),
    );
  }

  Widget _buildNavigationTile(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.grey[800],
            ),
            SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }
}
