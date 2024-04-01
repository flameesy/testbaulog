import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../helpers/database_helper.dart';

class AddRoomDialog extends StatefulWidget {
  final Database database;

  const AddRoomDialog({super.key, required this.database});

  @override
  _AddRoomDialogState createState() => _AddRoomDialogState();
}

class _AddRoomDialogState extends State<AddRoomDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accessController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Raum hinzufügen'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _accessController,
              decoration: const InputDecoration(labelText: 'Zugang'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: () async {
            final String name = _nameController.text;
            final int access = int.tryParse(_accessController.text) ?? 0;

            if (name.isNotEmpty) {
              await _addRoom(name, access);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Speichern'),
        ),
      ],
    );
  }

  Future<void> _addRoom(String name, int access) async {
    final DatabaseHelper dbHelper = DatabaseHelper(database: widget.database);
    try {
      await dbHelper.addRoom(name,1, access);
    } catch (e) {
      print('Error adding room: $e');
      // Handle error if needed
    }
  }
}
