import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'
if (dart.library.html) 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:testbaulog/screens/add_appointment_page.dart';
import 'package:testbaulog/screens/appointments_page.dart';
import 'package:testbaulog/screens/home_page.dart';
import 'package:testbaulog/screens/rooms_page.dart';
import 'package:testbaulog/screens/settings_page.dart';
import 'package:testbaulog/screens/login_page.dart';
import 'package:testbaulog/theme/baulog_theme.dart';
import 'package:testbaulog/helpers/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  late Database database;
  if (kIsWeb) {
    database = await databaseFactoryFfiWeb.openDatabase(inMemoryDatabasePath);
    databaseFactory = databaseFactoryFfiWeb;
    database = await openDatabase('baulog.db');
  } else {
    String databasesPath = await getDatabasesPath();
    String dbPath = path.join(databasesPath, 'baulog.db');
    database = await openDatabase(
      dbPath,
      onCreate: (db, version) {
        // Create tables if they don't exist
        return DatabaseHelper(database: db).createTablesIfNotExists();
      },
      version: 1,
    );
  }

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
'/': (context) => AppWithAppBarAndDrawer(
child: HomePage(database: database),
),
'/login': (context) => AppWithAppBarAndDrawer(
child: LoginPage(database: database),
),
'/termine': (context) => AppWithAppBarAndDrawer(
child: AppointmentsPage(database: database),
),
'/rooms': (context) => AppWithAppBarAndDrawer(
child: RoomsPage(database: database),
),
'/einstellungen': (context) => AppWithAppBarAndDrawer(
child: SettingsPage(database: database),
),
},
theme: BauLogTheme.getTheme(),
);
}
}

class AppWithAppBarAndDrawer extends StatelessWidget {
  final Widget child;

  const AppWithAppBarAndDrawer({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}
