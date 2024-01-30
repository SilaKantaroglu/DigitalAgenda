// ignore_for_file: constant_identifier_names

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class Event {
  final DateTime date;
  final String event;

  Event(this.date, this.event);
}

class DatabaseHelper {
  static const String TABLE_EVENTS = 'events';
  static const String COLUMN_ID = 'id';
  static const String COLUMN_DATE = 'date';
  static const String COLUMN_EVENT = 'event';

  Future<Database> _initializeDatabase() async {
    final String databasesPath = await getDatabasesPath();
    final String dbPath = path.join(databasesPath, 'ajanda.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
          CREATE TABLE $TABLE_EVENTS (
            $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $COLUMN_DATE TEXT,
            $COLUMN_EVENT TEXT
          )
          ''',
        );
      },
    );
  }

  Future<void> addEvent(Event event) async {
    final db = await _initializeDatabase();
    await db.insert(
      TABLE_EVENTS,
      {
        COLUMN_DATE: event.date.toIso8601String(),
        COLUMN_EVENT: event.event,
      },
    );
  }

  Future<void> deleteEvent(String event) async {
    final db = await _initializeDatabase();
    await db.delete(
      TABLE_EVENTS,
      where: '$COLUMN_EVENT = ?',
      whereArgs: [event],
    );
  }

  Future<Map<DateTime, List<dynamic>>> getEvents() async {
    final db = await _initializeDatabase();
    final events = await db.query(TABLE_EVENTS);
    final eventMap = <DateTime, List<dynamic>>{};
    for (var event in events) {
      final date = DateTime.parse(event[COLUMN_DATE] as String);
      final eventText = event[COLUMN_EVENT] as String;
      if (eventMap[date] != null) {
        eventMap[date]!.add(eventText);
      } else {
        eventMap[date] = [eventText];
      }
    }
    return eventMap;
  }
}
