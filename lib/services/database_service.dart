import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/schedule_model.dart';
import '../models/reminder_model.dart';

/// ROLE: Backend Engine - Manages all SQLite persistent storage.
/// DESIGN CHOICE: Singleton pattern used to ensure a single DB connection.
class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  // Getter for the database connection
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('water_collection.db');
    return _database!;
  }

  // Initializes the local file on the device (Dell Precision 5530 environment)
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      // CRITICAL: Enables Foreign Keys for Parent-Child relationships
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  /// ROLE: Defines the "Parent-Child" table structure.
  /// Deliverable 2: Explains how data is logically segmented.
  Future _createDB(Database db, int version) async {
    // Parent Table: Stores the collection day and main notes
    await db.execute('''
      CREATE TABLE schedules (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        collection_date TEXT NOT NULL,
        is_active INTEGER DEFAULT 1,
        notes TEXT
      )
    ''');

    // Child Table: Stores multiple alarm times linked to one schedule
    await db.execute('''
      CREATE TABLE reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        schedule_id INTEGER NOT NULL,
        reminder_time TEXT NOT NULL,
        FOREIGN KEY (schedule_id) REFERENCES schedules (id) ON DELETE CASCADE
      )
    ''');
  }

  // --- RETRIEVAL LOGIC (For Calendar View & List Screen) ---

  /// ROLE: Fetches schedules for a specific month for the Calendar View.
  Future<List<Schedule>> getSchedulesForMonth(DateTime month) async {
    final db = await instance.database;
    String prefix = "${month.year}-${month.month.toString().padLeft(2, '0')}";
    
    final result = await db.query(
      'schedules',
      where: 'collection_date LIKE ?',
      whereArgs: ['$prefix%'],
    );

    return result.map((json) => Schedule.fromMap(json)).toList();
  }

  /// ROLE: Atomic Transaction to save a schedule with its multiple reminders.
  Future<void> saveFullSchedule(Schedule schedule, List<String> times) async {
    final db = await instance.database;
    await db.transaction((txn) async {
      // 1. Save Parent
      int scheduleId = await txn.insert('schedules', schedule.toMap());
      // 2. Save all associated Child Reminders
      for (String time in times) {
        await txn.insert('reminders', {
          'schedule_id': scheduleId,
          'reminder_time': time,
        });
      }
    });
  }
}