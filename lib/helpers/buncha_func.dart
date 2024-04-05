import 'package:sqflite_common/sqlite_api.dart';

createAppointmentTable(Database database) async {
  try {
    await database.execute('''
      ALTER TABLE APPOINTMENT
      ADD COLUMN description TEXT,
      ADD COLUMN location TEXT,
      ADD COLUMN participant_ids TEXT,
      ADD COLUMN reminder_time DATETIME,
      ADD COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      ADD COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      ADD COLUMN platform_id INTEGER,
      ADD COLUMN room_id INTEGER,
      ADD COLUMN building_id INTEGER,
      ADD COLUMN level_id INTEGER,
      ADD COLUMN DONE INTEGER DEFAULT 0;
    ''');
    print('APPOINTMENT table altered successfully.');
  } catch (e) {
    print('Error altering APPOINTMENT table: $e');
  }
}
/*
await databaseHelper.insertEmail({
'recipient': 'example@example.com',
'cc': 'cc@example.com',
'bcc': 'bcc@example.com',
'subject': 'Test Subject',
'body': 'Test Body',
'template_id': '123456789', // Beispiel Vorlagen-ID
'created_at': DateTime.now().toIso8601String(),
'updated_at': DateTime.now().toIso8601String(),
});

// Füge eine Email-Vorlage in die Datenbank ein
await databaseHelper.insertEmailTemplate({
'name': 'Test Vorlage',
'subject': 'Test Betreff',
'body': 'Test Body',
'created_at': DateTime.now().toIso8601String(),
'updated_at': DateTime.now().toIso8601String(),
});

  List<Map<String, dynamic>> appointments = await databaseHelper.fetchAppointments();
  print('Fetched Appointments: $appointments');
*/