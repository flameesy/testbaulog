import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testbaulog/screens/room_detail_page.dart';
import 'package:grouped_list/grouped_list.dart';
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
      // Handle error if needed
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
      // Handle error if needed
    }
  }

  Future<int> countAppointmentsInRoom(int roomId) async {
    final DatabaseHelper dbHelper = DatabaseHelper(database: widget.database);
    try {
      final List<Map<String, dynamic>> appointments = await dbHelper.fetchItemsWithWhere(
          'APPOINTMENT',
          'room_id = ? AND done = ?',
          [roomId, 0]); // Assuming done=1 means the appointment is done
      return appointments.length;
    } catch (e) {
      print('Error counting appointments: $e');
      return 0;
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
      if (option == 'Name') {
        _rooms.sort((a, b) => a['name'].compareTo(b['name']));
      } else if (option == 'Access') {
        _rooms.sort((a, b) => a['access'].compareTo(b['access']));
      }
    });
  }

  void _editLevel(Map<String, dynamic> levelData) {
    // Implement logic to edit level
    // Assuming you navigate to a new screen for editing level
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditLevelPage(levelData: levelData, databaseHelper: DatabaseHelper(database: widget.database)),
      ),
    ).then((_) {
      // This function will be called after returning from RoomDetailPage
      fetchRooms(); // Update room list
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
          FilterBar(
            onSearchChanged: _filterRooms,
            onSortChanged: _sortRooms,
          ),
          Expanded(
            child: _rooms.isNotEmpty
                ? GroupedListView<dynamic, String>(
              elements: _rooms,
              groupBy: (room) {
                final levelId = room['level_id'];
                final buildingId = room['building_id'];

                if (levelId != null && buildingId != null) {
                  final levelIdString = levelId.toString();
                  final buildingIdString = buildingId.toString();
                  return '${levelIdString}_$buildingIdString';
                } else if (levelId != null && buildingId == null) {
                  final levelIdString = levelId.toString();
                  return levelIdString;
                } else {
                  return '';
                }
              },
              groupSeparatorBuilder: (String groupByValue) {
                final levelId = int.tryParse(groupByValue) ?? 0;
                final levelData = _levels.firstWhere(
                      (level) => level['id'] == levelId,
                  orElse: () => {},
                );

                if (levelData.isNotEmpty) {
                  return ListTile(
                    title: Text('Level ${levelData['id']} - Gebäude ${levelData['building_id']}'),
                    tileColor: Colors.grey[300],
                    onTap: () {
                      _editLevel(levelData);
                    },
                  );
                } else {
                  return const SizedBox(); // Return an empty widget if no matching level data found
                }
              },
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
                      trailing: FutureBuilder<int>(
                        future: countAppointmentsInRoom(room['id']),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text('Error');
                          } else {
                            final int count = snapshot.data ?? 0;
                            return Text('$count Termine');
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
              ),
            )
                : const Center(
              child: Text('Keine Räume vorhanden'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Zeige den AddRoomDialog an
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddRoomDialog(database: widget.database);
            },
          );
          // Aktualisiere die Raumliste
          fetchRooms();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
