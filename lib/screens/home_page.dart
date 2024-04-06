import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testbaulog/widgets/custom_app_bar.dart';
import 'package:testbaulog/widgets/custom_drawer.dart';

class HomePage extends StatelessWidget {
  final Database database;

  const HomePage({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildTile(
                  context: context,
                  title: 'Anzahl der Benutzer',
                  valueFuture: _getUserCount(),
                ),
              ),
              Expanded(
                child: _buildTile(
                  context: context,
                  title: 'Anzahl der Termine',
                  valueFuture: _getAppointmentCount(),
                ),
              ),
              Expanded(
                child: _buildTile(
                  context: context,
                  title: 'Anzahl der Räume',
                  valueFuture: _getRoomCount(),
                ),
              ),
              Expanded(
                child: _buildTile(
                  context: context,
                  title: 'Anzahl der Gebäude',
                  valueFuture: _getBuildingCount(),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: const CustomAppDrawer(),
    );
  }

  Future<int> _getUserCount() async {
    final List<Map<String, dynamic>> result =
    await database.rawQuery('SELECT COUNT(*) as count FROM USERS;');
    final int userCount = Sqflite.firstIntValue(result) ?? 0;
    return userCount;
  }

  Future<int> _getAppointmentCount() async {
    final List<Map<String, dynamic>> result =
    await database.rawQuery('SELECT COUNT(*) as count FROM APPOINTMENT;');
    final int userCount = Sqflite.firstIntValue(result) ?? 0;
    return userCount;
  }

  Future<int> _getRoomCount() async {
    final List<Map<String, dynamic>> result =
    await database.rawQuery('SELECT COUNT(*) as count FROM ROOM;');
    final int userCount = Sqflite.firstIntValue(result) ?? 0;
    return userCount;
  }

  Future<int> _getBuildingCount() async {
    final List<Map<String, dynamic>> result =
    await database.rawQuery('SELECT COUNT(*) as count FROM BUILDING;');
    final int userCount = Sqflite.firstIntValue(result) ?? 0;
    return userCount;
  }

  Widget _buildTile({
    required BuildContext context,
    required String title,
    required Future<dynamic> valueFuture,
  }) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future: valueFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    '${snapshot.data}',
                    style: Theme.of(context).textTheme.titleMedium,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
