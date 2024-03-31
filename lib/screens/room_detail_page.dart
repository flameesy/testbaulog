import 'package:flutter/material.dart';

class RoomDetailPage extends StatelessWidget {
  final Map<String, dynamic> room;

  const RoomDetailPage({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(room['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Raumname: ${room['name']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Zugang: ${room['access']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            // Add more room details here based on your database schema
            // For example:
            // Text(
            //   'Beschreibung: ${room['description']}',
            //   style: TextStyle(fontSize: 16),
            // ),
            // Text(
            //   'Level: ${room['level']}',
            //   style: TextStyle(fontSize: 16),
            // ),
            // Add other room details as needed
            // You can also customize the styling to make it look nicer
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
