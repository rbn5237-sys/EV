class DatabaseTables {
  static const String classesTable = '''
    CREATE TABLE classes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      order_index INTEGER NOT NULL,
      created_at TEXT
    )
  ''';

  static const String studentsTable = '''
    CREATE TABLE students (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      class_id INTEGER NOT NULL,
      roll_number INTEGER NOT NULL,
      is_custom INTEGER DEFAULT 0,
      name TEXT DEFAULT '',
      father_name TEXT DEFAULT '',
      contact TEXT DEFAULT '',
      address TEXT DEFAULT '',
      comments TEXT DEFAULT '',
      behavior_color INTEGER DEFAULT -1,
      created_at TEXT,
      updated_at TEXT,
      FOREIGN KEY (class_id) REFERENCES classes (id),
      UNIQUE (class_id, roll_number)
    )
  ''';

  static const String settingsTable = '''
    CREATE TABLE settings (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      key TEXT UNIQUE NOT NULL,
      value TEXT
    )
  ''';

  static const String deletedRollsTable = '''
    CREATE TABLE deleted_rolls (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      class_id INTEGER NOT NULL,
      roll_number INTEGER NOT NULL,
      deleted_at TEXT,
      FOREIGN KEY (class_id) REFERENCES classes (id)
    )
  ''';
}
