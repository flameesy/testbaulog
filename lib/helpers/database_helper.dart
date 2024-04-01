import 'package:sqflite/sqflite.dart';
import 'package:bcrypt/bcrypt.dart';

class DatabaseHelper {
  final Database database;

  DatabaseHelper({required this.database}) {
    // Überprüfen, ob die Tabellen bereits vorhanden sind, andernfalls erstellen
    createTablesIfNotExists();

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
      FOREIGN KEY (platform_id) REFERENCES PLATFORM(platform_id),
      FOREIGN KEY (room_id) REFERENCES ROOM(room_id),
      FOREIGN KEY (building_id) REFERENCES BUILDING(building_id)
      level_id INTEGER,
      UNIQUE (building_id, level_id, room_id)
    )
  ''',
      'USERS': '''
    CREATE TABLE IF NOT EXISTS USERS (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL
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
      new_data TEXT
    )
  ''',
      'BUILDING': '''
    CREATE TABLE IF NOT EXISTS BUILDING (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT NOT NULL,
      level_count INTEGER
    )
  ''',
      'LEVEL': '''
    CREATE TABLE IF NOT EXISTS LEVEL (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      building_id INTEGER NOT NULL,
      FOREIGN KEY (building_id) REFERENCES BUILDING (id) ON DELETE CASCADE,
      room_count INTEGER
    )
  ''',
      'ROOM': '''
    CREATE TABLE IF NOT EXISTS ROOM (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      level_id INTEGER NOT NULL,
      access INTEGER NOT NULL,
      FOREIGN KEY (level_id) REFERENCES LEVEL (id) ON DELETE CASCADE
    )
  ''',
      'PLATFORM': '''
    CREATE TABLE IF NOT EXISTS PLATFORM (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      building_id INTEGER NOT NULL,
      FOREIGN KEY (building_id) REFERENCES BUILDING (id) ON DELETE CASCADE
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
      country TEXT
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

  Future<void> insertAppointment({
    required DateTime appointmentDate,
    required DateTime startTime,
    required DateTime endTime,
    required String text,
    required int roomId,
    required int platformId,
  }) async {
    await database.insert(
      'APPOINTMENT',
      {
        'appointment_date': appointmentDate.toIso8601String(),
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'text': text,
        'room_id': roomId,
        'platform_id': platformId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> fetchAppointments() async {
    final List<Map<String, dynamic>> appointments =
    await database.query('APPOINTMENT');
    return appointments;
  }

  Future<void> deleteAppointment(int id) async {
    await database.delete('APPOINTMENT', where: 'id = ?', whereArgs: [id]);
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

  Future<void> updateLevel(int id, String name, int buildingId) async {
    await database.update(
      'LEVEL',
      {'name': name, 'building_id': buildingId},
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

  Future<void> updateRoom(int id, String name, int levelId, int access) async {
    await database.update(
      'ROOM',
      {'name': name, 'level_id': levelId, 'access': access},
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

}
