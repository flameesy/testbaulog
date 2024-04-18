import 'dart:async';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bcrypt/bcrypt.dart';

class DatabaseHelper {
  final Database database;

  DatabaseHelper({required this.database}) {
    // Überprüfen, ob die Tabellen bereits vorhanden sind, andernfalls erstellen

  }

  Future<void> createTablesIfNotExists() async {
    final tables = {
      'APPOINTMENT': '''
    CREATE TABLE IF NOT EXISTS APPOINTMENT (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      appointment_date DATE NOT NULL,
      start_time TIME NOT NULL,
      end_time TIME NOT NULL,
      text TEXT NOT NULL,
      description TEXT,
      location TEXT,
      participant_ids TEXT,
      reminder_time DATETIME,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      platform_id INTEGER,
      room_id INTEGER,
      building_id INTEGER,
      level_id INTEGER,
      DONE INTEGER DEFAULT 0,
      sync_status INTEGER DEFAULT 0, 
      UNIQUE (building_id, level_id, room_id),
      FOREIGN KEY (platform_id) REFERENCES PLATFORM(id),
      FOREIGN KEY (room_id) REFERENCES ROOM(id),
      FOREIGN KEY (building_id) REFERENCES BUILDING(id),
      FOREIGN KEY (level_id) REFERENCES LEVEL(id)
    )
  ''',
      'USERS': '''
    CREATE TABLE IF NOT EXISTS USERS (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL,
      sync_status INTEGER DEFAULT 0 
    )
  ''',
      'LOG': '''
    CREATE TABLE IF NOT EXISTS LOG (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
      action TEXT NOT NULL,
      table_name TEXT NOT NULL,
      record_id INTEGER,
      old_data TEXT,
      new_data TEXT,
      sync_status INTEGER DEFAULT 0 
    )
  ''',
      'SYNC_QUEUE': '''
    CREATE TABLE IF NOT EXISTS SYNC_QUEUE (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      table_name TEXT NOT NULL,
      record_id INTEGER NOT NULL,
      action TEXT NOT NULL,
      sync_status INTEGER DEFAULT 0,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  ''',
      'SYNC_HISTORY': '''
    CREATE TABLE IF NOT EXISTS SYNC_HISTORY (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      table_name TEXT NOT NULL,
      record_id INTEGER NOT NULL,
      action TEXT NOT NULL,
      sync_status INTEGER DEFAULT 0,
      response_code INTEGER,
      response_message TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  ''',
      'BUILDING': '''
    CREATE TABLE IF NOT EXISTS BUILDING (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT NOT NULL,
      level_count INTEGER,
      sync_status INTEGER DEFAULT 0 
    )
  ''',
      'LEVEL': '''
    CREATE TABLE IF NOT EXISTS LEVEL (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      building_id INTEGER NOT NULL,
      room_count INTEGER,
      sync_status INTEGER DEFAULT 0, 
      FOREIGN KEY (building_id) REFERENCES BUILDING(id) ON DELETE CASCADE
    )
  ''',
      'ROOM': '''
    CREATE TABLE IF NOT EXISTS ROOM (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      level_id INTEGER NOT NULL,
      access INTEGER NOT NULL,
      sync_status INTEGER DEFAULT 0, 
      FOREIGN KEY (level_id) REFERENCES LEVEL(id) ON DELETE CASCADE
    )
  ''',
      'PLATFORM': '''
    CREATE TABLE IF NOT EXISTS PLATFORM (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      building_id INTEGER NOT NULL,
      sync_status INTEGER DEFAULT 0, 
      FOREIGN KEY (building_id) REFERENCES BUILDING(id) ON DELETE CASCADE
    )
  ''',
      'ADDRESS': '''
    CREATE TABLE IF NOT EXISTS ADDRESS (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      first_name TEXT NOT NULL,
      last_name TEXT NOT NULL,
      email TEXT,
      second_email TEXT,
      phone_number TEXT,
      landline TEXT,
      position TEXT,
      street TEXT,
      city TEXT,
      postal_code TEXT,
      country TEXT,
      sync_status INTEGER DEFAULT 0 
    )
  ''',
      'EMAIL_TEMPLATE': '''
    CREATE TABLE IF NOT EXISTS EMAIL_TEMPLATE (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      subject TEXT NOT NULL,
      body TEXT NOT NULL,
      global INTEGER DEFAULT 0,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      sync_status INTEGER DEFAULT 0 
    )
  ''',
      'EMAIL_CATEGORY': '''
    CREATE TABLE IF NOT EXISTS EMAIL_CATEGORY (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      sync_status INTEGER DEFAULT 0 
    )
  ''',
      'EMAIL': '''
    CREATE TABLE IF NOT EXISTS EMAIL (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      recipient TEXT NOT NULL,
      cc TEXT,
      bcc TEXT,
      subject TEXT NOT NULL,
      body TEXT NOT NULL,
      template_id VARCHAR(30),
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      sync_status INTEGER DEFAULT 0, 
      FOREIGN KEY (template_id) REFERENCES EMAIL_TEMPLATE(id)
    )
  ''',
      'EMAIL_VARIABLE': '''
    CREATE TABLE IF NOT EXISTS EMAIL_VARIABLE (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT NOT NULL,
      source_table TEXT NOT NULL,
      source_field TEXT NOT NULL,
      default_value TEXT,
      data_type TEXT,
      required INTEGER DEFAULT 0,
      format TEXT
    )
  ''',
      'ATTACHMENT': '''
    CREATE TABLE IF NOT EXISTS ATTACHMENT (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      appointment_id INTEGER,
      room_id INTEGER,
      email_id INTEGER,
      file_path TEXT NOT NULL,
      file_type TEXT NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (appointment_id) REFERENCES APPOINTMENT(id) ON DELETE CASCADE,
      FOREIGN KEY (room_id) REFERENCES ROOM(id) ON DELETE CASCADE,
      FOREIGN KEY (email_id) REFERENCES EMAIL(id) ON DELETE CASCADE
    )
  ''',
    };


    for (final tableName in tables.keys) {
      await database.execute(tables[tableName]!);
    }
  }



  Future<void> insertUser(String email, String password) async {
    final hashedPassword = await _hashPassword(password);
    await database.insert(
      'USERS',
      {'email': email, 'password': hashedPassword},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> _generateUniqueId() async {
    // Annahme: Eine zufällige ID wird generiert
    // Hier kannst du eine geeignete Logik implementieren, um eine eindeutige ID zu generieren
    Random random = Random();
    int id = random.nextInt(999999); // Annahme: IDs liegen im Bereich von 0 bis 999999
    return id;
  }

  Future<int> insertAppointment({
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

    // Generate a unique ID
    int id = await _generateUniqueId();

    // Execute the SQL query
    await database.insert(
      'APPOINTMENT',
      {
        'id': id,
        'appointment_date': appointmentDate.toIso8601String(),
        'start_time': DateFormat('kk:mm').format(startTime),
        'end_time': DateFormat('kk:mm').format(endTime),
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
    return id;
  }






  Future<List<Map<String, dynamic>>> fetchAppointments() async {
    try {
      final List<Map<String, dynamic>> appointments = await database.query('APPOINTMENT');
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

  Future<void> printAppointmentTableSchema() async {
    // SQL-Statement, um das Tabellenschema der APPOINTMENT-Tabelle abzurufen
    const String query = "PRAGMA table_info(APPOINTMENT);";

    try {
      // Führen Sie das SQL-Statement aus und erhalten Sie die Spalteninformationen
      final List<Map<String, dynamic>> columns = await database.rawQuery(query);

      // Geben Sie die Spalteninformationen aus
      print("APPOINTMENT Table Schema:");
      for (var column in columns) {
        print("${column['name']} - ${column['type']}");
      }
    } catch (e) {
      print("Error printing APPOINTMENT table schema: $e");
    }
  }

  Future<bool> authenticateUser(String email, String password) async {
    final List<Map<String, dynamic>> result = await database.query(
      'USERS',
      columns: ['password'],
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isEmpty) {
      // User mit der angegebenen E-Mail existiert nicht
      return false;
    }

    final storedPassword = result.first['password'] as String;
    final isValidPassword = await _verifyPassword(password, storedPassword);

    return isValidPassword;
  }

  Future<String> _hashPassword(String password) async {
    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    return hashedPassword;
  }

  Future<bool> _verifyPassword(String password, String hashedPassword) async {
    final isValidPassword = BCrypt.checkpw(password, hashedPassword);
    return isValidPassword;
  }

  Future<void> addBuilding(String name, String description) async {
    await database.insert(
      'BUILDING',
      {'name': name, 'description': description},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteBuilding(int id) async {
    await database.delete('BUILDING', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateBuilding(int id, String name, String description) async {
    await database.update(
      'BUILDING',
      {'name': name, 'description': description},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> addLevel(String name, int buildingId) async {
    await database.insert(
      'LEVEL',
      {'name': name, 'building_id': buildingId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteLevel(int id) async {
    await database.delete('LEVEL', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateLevel(int id, String name, int buildingId, int roomCount, int syncStatus) async {
    await database.update(
      'LEVEL',
      {
        'name': name,
        'building_id': buildingId,
        'room_count': roomCount,
        'sync_status': syncStatus,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<void> addRoom(String name, int levelId, int access) async {
    await database.insert(
      'ROOM',
      {'name': name, 'level_id': levelId, 'access': access},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteRoom(int id) async {
    await database.delete('ROOM', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateRoom(int id, String name, int levelId, int access, int syncStatus) async {
    await database.update(
      'ROOM',
      {'name': name, 'level_id': levelId, 'access': access, 'sync_status': syncStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> addPlatform(String name, int buildingId) async {
    await database.insert(
      'PLATFORM',
      {'name': name, 'building_id': buildingId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deletePlatform(int id) async {
    await database.delete('PLATFORM', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updatePlatform(int id, String name, int buildingId) async {
    await database.update(
      'PLATFORM',
      {'name': name, 'building_id': buildingId},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> addAddress(String firstName,
      String lastName,
      String email,
      String secondEmail,
      String phoneNumber,
      String landline,
      String position,
      String street,
      String city,
      String postalCode,
      String country,
      int kennzeichenPrimaerkontakt,
      String firmaPerson) async {
    await database.insert(
      'ADDRESS',
      {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'second_email': secondEmail,
        'phone_number': phoneNumber,
        'landline': landline,
        'position': position,
        'street': street,
        'city': city,
        'postal_code': postalCode,
        'country': country,
        'kennzeichen_primärkontakt': kennzeichenPrimaerkontakt,
        'firma_person': firmaPerson
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateAddress(int id,
      String firstName,
      String lastName,
      String email,
      String secondEmail,
      String phoneNumber,
      String landline,
      String position,
      String street,
      String city,
      String postalCode,
      String country,
      int kennzeichenPrimaerkontakt,
      String firmaPerson) async {
    await database.update(
      'ADDRESS',
      {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'second_email': secondEmail,
        'phone_number': phoneNumber,
        'landline': landline,
        'position': position,
        'street': street,
        'city': city,
        'postal_code': postalCode,
        'country': country,
        'kennzeichen_primärkontakt': kennzeichenPrimaerkontakt,
        'firma_person': firmaPerson
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAddress(int id) async {
    await database.delete('ADDRESS', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> fetchItems(String tableName) async {
    return await database.query(tableName);
  }

  Future<List<Map<String, dynamic>>> fetchItemsWithWhere(String tableName,
      String where, List<dynamic> whereArgs) async {
    return await database.query(tableName, where: where, whereArgs: whereArgs);
  }

  Future<int> countAppointmentsInRoom(int roomId) async {
    final List<Map<String, dynamic>> result = await database.rawQuery(
      'SELECT COUNT(*) AS count FROM APPOINTMENT WHERE room_id = ? AND done = 0',
      [roomId],
    );

    if (result.isNotEmpty) {
      return result.first['count'] as int;
    } else {
      return 0;
    }
  }

  Future<void> insertEmail(Map<String, dynamic> data) async {
    await database.insert('EMAIL', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateEmail(int id, Map<String, dynamic> data) async {
    await database.update('EMAIL', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteEmail(int id) async {
    await database.delete('EMAIL', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteEmailTemplate(int id) async {
    await database.delete('EMAIL_TEMPLATE', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateEmailTemplate(int id, Map<String, dynamic> data) async {
    await database.update('EMAIL_TEMPLATE', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertEmailTemplate(Map<String, dynamic> data) async {
    return await database.insert('EMAIL_TEMPLATE', data);
  }

  Future<void> insertLevel(String name, int buildingId, {int? roomCount, int syncStatus = 0}) async {
    await database.insert(
      'LEVEL',
      {
        'name': name,
        'building_id': buildingId,
        'room_count': roomCount,
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PlatformFile>> getFilesForAppointment(int appointmentId) async {
    final List<Map<String, dynamic>> maps = await database.query(
      'attachments',
      where: 'appointment_id = ?',
      whereArgs: [appointmentId],
    );

    return List.generate(maps.length, (i) {
      return PlatformFile(
        path: maps[i]['path'],
        name: maps[i]['name'],
        size: maps[i]['size'],
        bytes: maps[i]['bytes'],
        identifier: maps[i]['identifier'],
      );
    });
  }

  Future<void> saveAttachmentForAppointment(int appointmentId, PlatformFile file) async {
    await database.insert(
      'attachments',
      {
        'appointment_id': appointmentId,
        'path': file.path,
        'name': file.name,
        'size': file.size,
        'bytes': file.bytes,
        'identifier': file.identifier,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

}
