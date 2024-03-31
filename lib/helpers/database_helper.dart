import 'package:sqflite/sqflite.dart';
import 'package:bcrypt/bcrypt.dart';

class DatabaseHelper {
  final Database database;

  DatabaseHelper({required this.database}) {
    // Ensure that the USERS table is created when the DatabaseHelper is instantiated
    createUserTable();
  }
  Future<void> insertAppointment(String appointment) async {
    await database.insert(
      'appointments',
      {'appointment_name': appointment},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> fetchTerminEntries() async {
    final List<Map<String, dynamic>> terminEntries =
    await database.query('appointments');
    return terminEntries;
  }

  Future<void> deleteAppointment(int id) async {
    await database.delete('appointments', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> createUserTable() async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS USERS (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertUser(String email, String password) async {
    final hashedPassword = await _hashPassword(password);
    await database.rawInsert('''
      INSERT INTO USERS (email, password)
      VALUES (?, ?)
    ''', [email, hashedPassword]);
  }

  Future<bool> authenticateUser(String email, String password) async {
    final List<Map<String, dynamic>> result = await database.query(
      'USERS',
      columns: ['password'],
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isEmpty) {
      // User with the provided email doesn't exist
      return false;
    }

    final storedPassword = result.first['password'] as String;
    final isValidPassword = await _verifyPassword(password, storedPassword);

    return isValidPassword;
  }

  Future<String> _hashPassword(String password) async {
    final hashedPassword = await BCrypt.hashpw(password, BCrypt.gensalt());
    return hashedPassword;
  }

  Future<bool> _verifyPassword(String password, String hashedPassword) async {
    final isValidPassword = await BCrypt.checkpw(password, hashedPassword);
    return isValidPassword;
  }
}
