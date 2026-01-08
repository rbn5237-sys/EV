import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/student.dart';
import '../models/class_model.dart';
import '../config/app_config.dart';
import 'tables.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ev_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute(DatabaseTables.classesTable);
    await db.execute(DatabaseTables.studentsTable);
    await db.execute(DatabaseTables.settingsTable);
    await db.execute(DatabaseTables.deletedRollsTable);
    
    await _initializeClasses(db);
    await _initializeRollNumbers(db);
    await _initializeSettings(db);
  }

  Future<void> _initializeClasses(Database db) async {
    for (int i = 0; i < AppConfig.classes.length; i++) {
      await db.insert('classes', {
        'name': AppConfig.classes[i],
        'order_index': i,
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> _initializeRollNumbers(Database db) async {
    final classes = await db.query('classes');
    
    for (var classItem in classes) {
      int classId = classItem['id'] as int;
      
      for (int roll = 1; roll <= AppConfig.fixedRollNumbers; roll++) {
        await db.insert('students', {
          'class_id': classId,
          'roll_number': roll,
          'is_custom': 0,
          'name': '',
          'father_name': '',
          'contact': '',
          'address': '',
          'comments': '',
          'behavior_color': -1,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    }
  }

  Future<void> _initializeSettings(Database db) async {
    await db.insert('settings', {
      'key': 'language',
      'value': 'en',
    });
    await db.insert('settings', {
      'key': 'theme_mode',
      'value': 'system',
    });
    await db.insert('settings', {
      'key': 'is_first_run',
      'value': '1',
    });
    await db.insert('settings', {
      'key': 'pin_hash',
      'value': '',
    });
  }

  // Classes Operations
  Future<List<ClassModel>> getAllClasses() async {
    final db = await database;
    final result = await db.query('classes', orderBy: 'order_index ASC');
    return result.map((map) => ClassModel.fromMap(map)).toList();
  }

  Future<ClassModel?> getClassById(int id) async {
    final db = await database;
    final result = await db.query('classes', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return ClassModel.fromMap(result.first);
  }

  // Students Operations
  Future<List<Student>> getStudentsByClass(int classId) async {
    final db = await database;
    final result = await db.query(
      'students',
      where: 'class_id = ?',
      whereArgs: [classId],
      orderBy: 'roll_number ASC',
    );
    return result.map((map) => Student.fromMap(map)).toList();
  }

  Future<List<Student>> getStudentsByClassAndColor(int classId, int colorIndex) async {
    final db = await database;
    final result = await db.query(
      'students',
      where: 'class_id = ? AND behavior_color = ?',
      whereArgs: [classId, colorIndex],
      orderBy: 'roll_number ASC',
    );
    return result.map((map) => Student.fromMap(map)).toList();
  }

  Future<List<Student>> getAllStudentsByColor(int colorIndex) async {
    final db = await database;
    final result = await db.query(
      'students',
      where: 'behavior_color = ?',
      whereArgs: [colorIndex],
      orderBy: 'class_id ASC, roll_number ASC',
    );
    return result.map((map) => Student.fromMap(map)).toList();
  }

  Future<Student?> getStudent(int classId, int rollNumber) async {
    final db = await database;
    final result = await db.query(
      'students',
      where: 'class_id = ? AND roll_number = ?',
      whereArgs: [classId, rollNumber],
    );
    if (result.isEmpty) return null;
    return Student.fromMap(result.first);
  }

  Future<Student?> getStudentById(int id) async {
    final db = await database;
    final result = await db.query(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return Student.fromMap(result.first);
  }

  Future<int> insertStudent(Student student) async {
    final db = await database;
    return await db.insert('students', student.toMap());
  }

  Future<int> updateStudent(Student student) async {
    final db = await database;
    return await db.update(
      'students',
      {...student.toMap(), 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(int id) async {
    final db = await database;
    return await db.delete('students', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteRollNumber(int classId, int rollNumber) async {
    final db = await database;
    await db.delete(
      'students',
      where: 'class_id = ? AND roll_number = ?',
      whereArgs: [classId, rollNumber],
    );
    await db.insert('deleted_rolls', {
      'class_id': classId,
      'roll_number': rollNumber,
      'deleted_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<int>> getDeletedRolls(int classId) async {
    final db = await database;
    final result = await db.query(
      'deleted_rolls',
      where: 'class_id = ?',
      whereArgs: [classId],
    );
    return result.map((map) => map['roll_number'] as int).toList();
  }

  Future<int> addCustomRollNumber(int classId, int rollNumber) async {
    final db = await database;
    final existing = await getStudent(classId, rollNumber);
    if (existing != null) {
      throw Exception('Roll number already exists');
    }
    
    return await db.insert('students', {
      'class_id': classId,
      'roll_number': rollNumber,
      'is_custom': 1,
      'name': '',
      'father_name': '',
      'contact': '',
      'address': '',
      'comments': '',
      'behavior_color': -1,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<int> getNextCustomRollNumber(int classId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT MAX(roll_number) as max_roll FROM students WHERE class_id = ?',
      [classId],
    );
    int maxRoll = result.first['max_roll'] as int? ?? 50;
    return maxRoll + 1;
  }

  Future<int> getCustomRollCount(int classId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM students WHERE class_id = ? AND is_custom = 1',
      [classId],
    );
    return result.first['count'] as int;
  }

  // Settings Operations
  Future<String?> getSetting(String key) async {
    final db = await database;
    final result = await db.query('settings', where: 'key = ?', whereArgs: [key]);
    if (result.isEmpty) return null;
    return result.first['value'] as String?;
  }

  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await db.update(
      'settings',
      {'value': value},
      where: 'key = ?',
      whereArgs: [key],
    );
  }

  // Export Operations
  Future<List<Student>> getAllStudents() async {
    final db = await database;
    final result = await db.query('students', orderBy: 'class_id ASC, roll_number ASC');
    return result.map((map) => Student.fromMap(map)).toList();
  }

  Future<Map<String, dynamic>> exportAllData() async {
    final classes = await getAllClasses();
    final students = await getAllStudents();
    
    return {
      'exportDate': DateTime.now().toIso8601String(),
      'appVersion': AppConfig.appVersion,
      'classes': classes.map((c) => {
        'id': c.id,
        'name': c.name,
        'order': c.order,
      }).toList(),
      'students': students.map((s) => s.toJson()).toList(),
    };
  }

  Future<Map<String, dynamic>> exportClassData(int classId) async {
    final classInfo = await getClassById(classId);
    final students = await getStudentsByClass(classId);
    
    return {
      'exportDate': DateTime.now().toIso8601String(),
      'appVersion': AppConfig.appVersion,
      'class': {
        'id': classInfo?.id,
        'name': classInfo?.name,
        'order': classInfo?.order,
      },
      'students': students.map((s) => s.toJson()).toList(),
    };
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
