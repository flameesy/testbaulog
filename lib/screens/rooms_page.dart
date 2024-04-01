import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testbaulog/screens/room_detail_page.dart';
import 'package:grouped_list/grouped_list.dart'; // Import des grouped_list-Pakets
import '../helpers/database_helper.dart';
import '../widgets/add_room_dialog.dart';
import '../widgets/filter_bar.dart'; // Import der FilterBar

class RoomsPage extends StatefulWidget {
  final Database database;

  const RoomsPage({Key? key, required this.database}) : super(key: key);

  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  List<Map<String, dynamic>> _rooms = []; // Initialize with an empty list
  String _searchQuery = '';
  String _selectedSortOption = '';

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    final DatabaseHelper dbHelper = DatabaseHelper(database: widget.database);
    try {
      final List<Map<String, dynamic>> rooms =
      await dbHelper.fetchItems('ROOM');

      if (mounted) {
        setState(() {
          _rooms = rooms;
        });
      }
    } catch (e) {
      print('Error fetching rooms: $e');
      // Handle error if needed
    }
  }

  Color _getBackgroundColor(int access) {
    switch (access) {
      case 0:
        return Colors.white;
      case 1:
        return Colors.grey[200]!;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.grey[600]!;
      default:
        return Colors.white;
    }
  }

  Color _getTileColor(int index) {
    List<Color> colors = [
      Colors.red[100]!,
      Colors.blue[100]!,
      Colors.orange[100]!,
    ];
    return colors[index % 3];
  }

  void _filterRooms(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _sortRooms(String option) {
    setState(() {
      _selectedSortOption = option;
    });
    // Implement logic to sort rooms based on selected option
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Räume'),
      ),
      body: Column(
        children: [
          FilterBar(
            onSearchChanged: _filterRooms,
            onSortChanged: _sortRooms,
          ),
          Expanded(
            child: _rooms.isNotEmpty
                ? GroupedListView<dynamic, String>(
              elements: _rooms,
              groupBy: (room) => room['level_id'].toString(),
              groupSeparatorBuilder: (String levelId) => ListTile(
                title: Text('Level $levelId'),
                tileColor: Colors.grey[300],
              ),
              itemBuilder: (context, room) => Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: _getTileColor(room['level_id']),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        '${room['name']} (${room['id']})',
                        style: const TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        'Zugang: ${room['access']}',
                        style: const TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoomDetailPage(
                              room: room,
                              database: widget.database,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            )
                : const Center(
              child: Text('Keine Räume vorhanden'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddRoomDialog(database: widget.database);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
