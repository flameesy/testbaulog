import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testbaulog/screens/room_detail_page.dart';
import 'package:grouped_list/grouped_list.dart';
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
  List<Map<String, dynamic>> _allRooms = []; // Alle Räume aus der Datenbank
  List<Map<String, dynamic>> _displayedRooms = []; // Angezeigte Räume nach Filterung

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    final DatabaseHelper dbHelper = DatabaseHelper(database: widget.database);
    try {
      final List<Map<String, dynamic>> rooms = await dbHelper.fetchItems('ROOM');

      if (mounted) {
        setState(() {
          _allRooms = rooms;
          _displayedRooms = rooms; // Zu Beginn werden alle Räume angezeigt
        });
      }
    } catch (e) {
      print('Error fetching rooms: $e');
      // Handle error if needed
    }
  }

  void _filterRooms(String query) {
    setState(() {
      _displayedRooms = _allRooms.where((room) {
        final name = room['name'].toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Räume'),
      ),
      body: Column(
        children: [
          FilterBar( // Verwenden der FilterBar zur Suche
            onSearchChanged: _filterRooms, onSortChanged: (String ) {  },
          ),
          Expanded(
            child: _displayedRooms.isNotEmpty
                ? GroupedListView<dynamic, String>(
              elements: _displayedRooms,
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
                            builder: (context) => RoomDetailPage(room: room),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            )
                : const Center(
              child: Text('Keine passenden Räume gefunden'),
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

  Color _getTileColor(int index) {
    List<Color> colors = [
      Colors.red[100]!,
      Colors.blue[100]!,
      Colors.orange[100]!,
    ];
    return colors[index % 3];
  }
}
