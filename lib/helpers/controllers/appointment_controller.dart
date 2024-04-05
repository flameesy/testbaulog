import 'package:sqflite/sqflite.dart';

class AppointmentController {
  final Database database;

  AppointmentController({required this.database});

  Future<void> insertAppointment({
    required DateTime appointmentDate,
    required DateTime startTime,
    required DateTime endTime,
    required String text,
    required String description,
    required int roomId,
    required int platformId,
  }) async {
    // Get the current timestamp for created_at and updated_at fields
    DateTime now = DateTime.now();

    await database.insert(
      'APPOINTMENT',
      {
        'appointment_date': appointmentDate.toIso8601String(),
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'text': text,
        'description': description,
        'location': '', // You may set the location here if applicable
        'participant_ids': '', // You may set participant IDs here if applicable
        'reminder_time': null, // You may set reminder time here if applicable
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
        'platform_id': platformId,
        'room_id': roomId,
        'building_id': 0, // You may set the building ID here if applicable
        'level_id': 0, // You may set the level ID here if applicable
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<Map<String, dynamic>>> fetchAppointments() async {
    try {
      final List<Map<String, dynamic>> appointments = await database.query('APPOINTMENT');
      print('Appointments fetched successfully: $appointments');
      return appointments;
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }

  Future<void> updateAppointment(int id, Map<String, dynamic> updatedAppointment) async {
    await database.update(
      'APPOINTMENT',
      updatedAppointment,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAppointment(int id) async {
    await database.delete('APPOINTMENT', where: 'id = ?', whereArgs: [id]);
  }
}
