import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// Define constants that will be used throughout the app
const file = 'DoneDatabase.db';
const todoTABLE = 'Todo';
const columnId = 'id';
const columnTask = 'task';
const columnCategory = 'category';
const columnCompletion = 'completion';
const columnAlarm = 'alarm';
const columnRing = 'ring';
const columnRecent = 'recent';
const columnLastSearched = 'lastSearched';

/// The class that provides access to the database
class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();
  Database? _database;

  /// Getter for the database
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  /// Opens the database connection through the directory
  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //"DoneDatabase.db is our database instance name
    String path = join(documentsDirectory.path, file);
    return await openDatabase(
      path,
      version: 1,
      onCreate: initDB,
      onUpgrade: onUpgrade,
    );
  }

  /// This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  // Define the Database Schema when the table is created for the first time
  void initDB(Database database, int version) async {
    await database.execute(
      "CREATE TABLE $todoTABLE ("
      "$columnId INTEGER PRIMARY KEY, "
      "$columnTask TEXT, "
      "is_done INTEGER, " // SQLITE doesn't have boolean type
      "$columnCategory TEXT,"
      "$columnCompletion TEXT,"
      "$columnAlarm TEXT,"
      "$columnRing INTEGER,"
      "$columnRecent INTEGER,"
      "$columnLastSearched INTEGER"
      ")",
    );
  }
}
