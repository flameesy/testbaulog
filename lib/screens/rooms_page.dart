import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testbaulog/screens/room_detail_page.dart';
import 'package:grouped_list/grouped_list.dart';
import '../helpers/animated_card.dart';
import '../helpers/database_helper.dart';
import '../widgets/add_room_dialog.dart';
import '../widgets/filter_bar.dart';
import 'edit_level_page.dart';

class RoomsPage extends StatefulWidget {
  final Database database;

  const RoomsPage({super.key, required this.database});

  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  late List<Map<String, dynamic>> _rooms;
  late List<Map<String, dynamic>> _levels; // New variable to hold levels
  String _searchQuery = '';
  String _selectedSortOption = '';

  @override
  void initState() {
    super.initState();
    _rooms = [];
    _levels = [];
    fetchRooms();
    fetchLevels(); // Fetch levels on initialization
  }

  Future<void> fetchRooms() async {
    final DatabaseHelper dbHelper = DatabaseHelper(database: widget.database);
    try {
      final List<Map<String, dynamic>> rooms = await dbHelper.fetchItems('ROOM');
      if (mounted) {
        setState(() {
          _rooms = rooms;
        });
      }
    } catch (e) {
      print('Error fetching rooms: $e');
    }
  }

  Future<void> fetchLevels() async {
    final DatabaseHelper dbHelper = DatabaseHelper(database: widget.database);
    try {
      final List<Map<String, dynamic>> levels = await dbHelper.fetchItems('LEVEL');
      if (mounted) {
        setState(() {
          _levels = levels;
        });
      }
    } catch (e) {
      print('Error fetching levels: $e');
    }
  }

  Future<int> countAppointmentsInRoom(int roomId) async {
    final DatabaseHelper dbHelper = DatabaseHelper(database: widget.database);
    try {
      final List<Map<String, dynamic>> appointments = await dbHelper.fetchItemsWithWhere(
          'APPOINTMENT',
          'room_id = ? AND done <> ?',
          [roomId, 1]); // Assuming done=1 means the appointment is done
      return appointments.length;
    } catch (e) {
      print('Error counting appointments: $e');
      return 0;
    }
  }

  Color _getTileColor(int levelId) {
    // Use a dynamic color scheme based on the level ID
    List<Color> colors = [
      Colors.red[100]!,
      Colors.blue[100]!,
      Colors.green[100]!,
      Colors.orange[100]!,
      Colors.purple[100]!,
    ];
    return colors[levelId % colors.length];
  }

  void _filterRooms(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _sortRooms(String option) {
    setState(() {
      _selectedSortOption = option;
      if (option == 'Name') {
        _rooms.sort((a, b) => a['name'].compareTo(b['name']));
      } else if (option == 'Access') {
        _rooms.sort((a, b) => a['access'].compareTo(b['access']));
      }
    });
  }

  void _editLevel(Map<String, dynamic> levelData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditLevelPage(levelData: levelData, databaseHelper: DatabaseHelper(database: widget.database)),
      ),
    ).then((_) {
      fetchRooms(); // Update room list
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter the rooms based on the search query
    final filteredRooms = _rooms.where((room) {
      return room['name'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Räume', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          FilterBar(
            onSearchChanged: _filterRooms,
            onSortChanged: _sortRooms,
          ),
          Expanded(
            child: filteredRooms.isNotEmpty
                ? GroupedListView<dynamic, String>(
              elements: filteredRooms,
              groupBy: (room) {
                final levelId = room['level_id'];
                final buildingId = room['building_id'];
                return '${levelId}_${buildingId}';
              },
              groupSeparatorBuilder: (String groupByValue) {
                final levelId = int.tryParse(groupByValue.split('_')[0]) ?? 0;
                final buildingId = groupByValue.split('_')[1];
                final levelData = _levels.firstWhere(
                      (level) => level['id'] == levelId,
                  orElse: () => {},
                );

                if (levelData.isNotEmpty) {
                  return Card(
                    color: Colors.grey[300],
                    child: ListTile(
                      title: Text('Level ${levelData['id']} - Gebäude ${levelData['building_id']}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _editLevel(levelData);
                        },
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
              itemBuilder: (context, room) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
                child: AnimatedCard(
                  color: _getTileColor(room['level_id']),
                  child: ListTile(
                    title: Text(
                      '${room['name']} (${room['id']})',
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Zugang: ${room['access']}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: FutureBuilder<int>(
                      future: countAppointmentsInRoom(room['id']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text('Error', style: TextStyle(color: Colors.red));
                        } else {
                          final int count = snapshot.data ?? 0;
                          return Text('$count Termine', style: const TextStyle(color: Colors.black54));
                        }
                      },
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
            )
                : const Center(
              child: Text('Keine Räume vorhanden', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddRoomDialog(database: widget.database);
            },
          );
          fetchRooms(); // Update room list after adding a new room
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

}
