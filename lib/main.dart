import 'dart:convert';

import 'package:drift/backends.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'
if (dart.library.html) 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:testbaulog/screens/appointments_page.dart';
import 'package:testbaulog/screens/home_page.dart';
import 'package:testbaulog/screens/rooms_page.dart';
import 'package:testbaulog/screens/settings_page.dart';
import 'package:testbaulog/screens/login_page.dart';
import 'package:testbaulog/theme/baulog_theme.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';

import 'helpers/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  late Database database;

  if (kIsWeb) {
    // For web, load the database from assets directly into memory
    var data = await rootBundle.load('assets/baulog.db');
    var bytes = data.buffer.asUint8List();
    database = await databaseFactoryFfiWeb.openDatabase(inMemoryDatabasePath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            // Create the necessary tables
            return DatabaseHelper(database: db).createTablesIfNotExists();
          },
        ));
  } else {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "baulog.db");
// Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound){
      // Load database from asset and copy
      ByteData data = await rootBundle.load(join('assets', 'baulog.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await File(path).writeAsBytes(bytes);
    }
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'baulog.db');
    database = await openDatabase(databasePath);
    var initialized = true;
  }


  // Erstelle eine Instanz des DatabaseHelper und übergebe die Datenbank
  DatabaseHelper databaseHelper = DatabaseHelper(database: database);

  // Beispielaufruf 1
  databaseHelper.insertAppointment(
    appointmentDate: DateTime.now(),
    startTime: DateTime.now(),
    endTime: DateTime.now(),
    text: 'Beispieltext 1',
    roomId: 1,
    platformId: 1,
  );

// Beispielaufruf 2
  databaseHelper.insertAppointment(
    appointmentDate: DateTime.now(),
    startTime: DateTime.now(),
    endTime: DateTime.now(),
    text: 'Beispieltext 2',
    roomId: 2,
    platformId: 2,
  );

  databaseHelper.insertUser('test@example.com', 'password123');

  runApp(MyApp(database: database));
}



class MyApp extends StatelessWidget {
final Database database;

const MyApp({Key? key, required this.database}) : super(key: key);

@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'BauLog',
    initialRoute: '/login',
    routes: {
      '/': (context) => AppWrapper(
        child: HomePage(database: database),
      ),
      '/login': (context) => AppWrapper(
        child: LoginPage(database: database),
      ),
      '/termine': (context) => AppWrapper(
        child: AppointmentsPage(database: database),
      ),
      '/rooms': (context) => AppWrapper(
        child: RoomsPage(database: database),
      ),
      '/einstellungen': (context) => AppWrapper(
        child: SettingsPage(database: database),
      ),
    },
    theme: BauLogTheme.getTheme(),
    );
  }
}

class AppWrapper extends StatelessWidget {
  final Widget child;

  const AppWrapper({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}
