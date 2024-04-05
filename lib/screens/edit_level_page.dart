import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';

class EditLevelPage extends StatefulWidget {
  final Map<String, dynamic> levelData;
  final DatabaseHelper databaseHelper;

  const EditLevelPage({super.key, required this.levelData, required this.databaseHelper});

  @override
  _EditLevelPageState createState() => _EditLevelPageState();
}

class _EditLevelPageState extends State<EditLevelPage> {
  late TextEditingController _nameController;
  late TextEditingController _roomCountController;
  late TextEditingController _syncStatusController;
  late TextEditingController _buildingIdController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.levelData['name']);
    _roomCountController = TextEditingController(text: widget.levelData['room_count'].toString());
    _syncStatusController = TextEditingController(text: widget.levelData['sync_status'].toString());
    _buildingIdController = TextEditingController(text: widget.levelData['building_id'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Level bearbeiten'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _roomCountController,
              decoration: const InputDecoration(labelText: 'Anzahl der Räume'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _syncStatusController,
              decoration: const InputDecoration(labelText: 'Synchronisierungsstatus'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _buildingIdController,
              decoration: const InputDecoration(labelText: 'Gebäude ID'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Speichern der bearbeiteten Level-Daten
                final String name = _nameController.text.trim();
                final int roomCount = int.tryParse(_roomCountController.text.trim()) ?? widget.levelData['room_count'];
                final int syncStatus = int.tryParse(_syncStatusController.text.trim()) ?? widget.levelData['sync_status'];

                // Überprüfen, ob die Gebäude-ID nicht null ist und erfolgreich in einen Integer umgewandelt werden kann
                int? buildingIdParsed = int.tryParse(_buildingIdController.text.trim());
                final int buildingId = buildingIdParsed ?? widget.levelData['building_id'];

                final Map<String, dynamic> updatedLevelData = {
                  'id': widget.levelData['id'],
                  'name': name,
                  'room_count': roomCount,
                  'sync_status': syncStatus,
                  'building_id': buildingId,
                  // Weitere Felder entsprechend hinzufügen, falls vorhanden
                };

                await widget.databaseHelper.updateLevel(
                  widget.levelData['id'],
                  name,
                  buildingId,
                  roomCount,
                  syncStatus,
                );

                Navigator.pop(context, true); // Zurück zur vorherigen Seite mit Aktualisierungsmarkierung
              },
              child: const Text('Speichern'),
            ),

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roomCountController.dispose();
    _syncStatusController.dispose();
    _buildingIdController.dispose();
    super.dispose();
  }
}
