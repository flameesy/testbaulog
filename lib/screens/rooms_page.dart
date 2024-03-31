import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testbaulog/screens/room_detail_page.dart';

import '../helpers/database_helper.dart';

class RoomsPage extends StatefulWidget {
  final Database database;

  const RoomsPage({super.key, required this.database});

  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  late List<Map<String, dynamic>> _rooms = []; // Initialize with an empty list

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    final DatabaseHelper dbHelper = DatabaseHelper(database: widget.database);
    final List<Map<String, dynamic>> rooms = await dbHelper.fetchRooms();
    setState(() {
      _rooms = rooms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Räume'),
      ),
      body: _rooms.isNotEmpty
          ? ListView.builder(
        itemCount: _rooms.length,
        itemBuilder: (context, index) {
          final room = _rooms[index];
          return ListTile(
            title: Text(room['name']),
            subtitle: Text('Zugang: ${room['access']}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomDetailPage(room: room),
                ),
              );
            },
          );
        },
      )
          : const Center(
        child: Text('Keine Räume vorhanden'),
      ),
    );
  }
}
