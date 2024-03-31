import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:testbaulog/screens/add_appointment_page.dart';
import 'package:testbaulog/screens/home_page.dart';
import 'package:testbaulog/screens/login_page.dart';
import 'package:testbaulog/screens/settings_page.dart';
import 'package:testbaulog/theme/baulog_theme.dart';

import 'helpers/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  late Database database;

  // Initialize SQLite database
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
    database = await openDatabase('baulog.db');
  } else {
    database = await openDatabase('baulog.db');
  }

  final DatabaseHelper dbHelper = DatabaseHelper(database: database);

  // Check if the database file exists in the app's document directory
  bool databaseExists = await _checkDatabaseExists();

  // If the database file doesn't exist, download it from GitHub
  if (!databaseExists) {
    // Load database from GitHub URL
    const String databaseUrl =
        'https://github.com/flameesy/BauLog/raw/main/baulog.db';
    await _downloadDatabase(databaseUrl);
    // Re-open the database after downloading
    database = await openDatabase('baulog.db');
  }

  runApp(MyApp(database: database));
}

Future<bool> _checkDatabaseExists() async {
  if (kIsWeb) {
    try {
      await http.get('https://github.com/flameesy/BauLog/raw/main/baulog.db' as Uri);
      return true;
    } catch (e) {
      return false;
    }
  } else {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String dbPath = '${appDocDir.path}/baulog.db';
      return File(dbPath).exists();
    } catch (e) {
      print('Error checking database existence: $e');
      return false;
    }
  }
}

Future<void> _downloadDatabase(String url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200 && !kIsWeb) {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final dbFile = File('${appDocDir.path}/baulog.db');
      await dbFile.writeAsBytes(response.bodyBytes);
    } catch (e) {
      print('Error downloading database: $e');
      throw Exception('Failed to download database');
    }
  } else {
    throw Exception('Failed to download database');
  }
}

class MyApp extends StatelessWidget {
  final Database database;

  const MyApp({Key? key, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BauLog',
      initialRoute: '/login', // Set initial route to the login page
      routes: {
        '/': (context) => AppWithAppBarAndDrawer(
          child: HomePage(database: database),
        ),
        '/login': (context) => AppWithAppBarAndDrawer(
          child: LoginPage(database: database),
        ),
        '/termine': (context) => AppWithAppBarAndDrawer(
          child: AddAppointmentPage(database: database),
        ),
        '/einstellungen': (context) => AppWithAppBarAndDrawer(
          child: SettingsPage(database: database),
        ),
        // Add other routes as needed
      },
      theme: BauLogTheme.getTheme(), // Apply the default light theme
    );
  }
}

class AppWithAppBarAndDrawer extends StatelessWidget {
  final Widget child;

  const AppWithAppBarAndDrawer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}
