import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/student.dart';
import '../models/class_model.dart';

class StudentProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  
  List<ClassModel> _classes = [];
  List<Student> _currentClassStudents = [];
  Student? _currentStudent;
  int? _currentClassId;
  int _selectedColorFilter = -1;
  bool _isLoading = false;
  String _searchQuery = '';

  List<ClassModel> get classes => _classes;
  List<Student> get currentClassStudents => _filteredStudents;
  Student? get currentStudent => _currentStudent;
  int? get currentClassId => _currentClassId;
  int get selectedColorFilter => _selectedColorFilter;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  List<Student> get _filteredStudents {
    List<Student> filtered = _currentClassStudents;
    
    if (_selectedColorFilter >= 0) {
      filtered = filtered.where((s) => s.behaviorColor == _selectedColorFilter).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((s) =>
        s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        s.rollNumber.toString().contains(_searchQuery) ||
        s.fatherName.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    return filtered;
  }

  Future<void> loadClasses() async {
    _isLoading = true;
    notifyListeners();
    
    _classes = await _db.getAllClasses();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadStudentsByClass(int classId) async {
    _isLoading = true;
    _currentClassId = classId;
    notifyListeners();
    
    _currentClassStudents = await _db.getStudentsByClass(classId);
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadStudent(int studentId) async {
    _isLoading = true;
    notifyListeners();
    
    _currentStudent = await _db.getStudentById(studentId);
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadStudentByRoll(int classId, int rollNumber) async {
    _isLoading = true;
    notifyListeners();
    
    _currentStudent = await _db.getStudent(classId, rollNumber);
    
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> saveStudent(Student student) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      if (student.id != null) {
        await _db.updateStudent(student);
      } else {
        await _db.insertStudent(student);
      }
      
      if (_currentClassId != null) {
        await loadStudentsByClass(_currentClassId!);
      }
      _currentStudent = student;
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteRollNumber(int classId, int rollNumber) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _db.deleteRollNumber(classId, rollNumber);
      await loadStudentsByClass(classId);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> addCustomRollNumber(int classId) async {
    try {
      final customCount = await _db.getCustomRollCount(classId);
      if (customCount >= 5) {
        return false;
      }
      
      _isLoading = true;
      notifyListeners();
      
      final nextRoll = await _db.getNextCustomRollNumber(classId);
      await _db.addCustomRollNumber(classId, nextRoll);
      await loadStudentsByClass(classId);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<int> getCustomRollCount(int classId) async {
    return await _db.getCustomRollCount(classId);
  }

  void setColorFilter(int colorIndex) {
    _selectedColorFilter = colorIndex;
    notifyListeners();
  }

  void clearColorFilter() {
    _selectedColorFilter = -1;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  ClassModel? getClassById(int classId) {
    try {
      return _classes.firstWhere((c) => c.id == classId);
    } catch (e) {
      return null;
    }
  }

  Future<List<Student>> getStudentsByColor(int colorIndex) async {
    return await _db.getAllStudentsByColor(colorIndex);
  }

  Future<Map<String, dynamic>> exportAllData() async {
    return await _db.exportAllData();
  }

  Future<Map<String, dynamic>> exportClassData(int classId) async {
    return await _db.exportClassData(classId);
  }

  void clearCurrentStudent() {
    _currentStudent = null;
    notifyListeners();
  }
}
