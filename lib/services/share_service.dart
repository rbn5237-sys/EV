import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import '../models/student.dart';
import '../config/app_config.dart';

class ShareService {
  static Future<void> shareStudent(Student student, String className) async {
    final text = _formatStudentInfo(student, className);
    await Share.share(text, subject: 'Student Information');
  }

  static Future<void> shareData(Map<String, dynamic> data) async {
    final jsonString = const JsonEncoder.withIndent('  ').convert(data);
    await Share.share(jsonString, subject: 'EV Data Export');
  }

  static String _formatStudentInfo(Student student, String className) {
    final buffer = StringBuffer();
    buffer.writeln('📚 Student Information');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('🏫 Class: $className');
    buffer.writeln('🔢 Roll Number: ${student.rollNumber}');
    buffer.writeln('👤 Name: ${student.name.isEmpty ? "N/A" : student.name}');
    buffer.writeln('👨 Father: ${student.fatherName.isEmpty ? "N/A" : student.fatherName}');
    buffer.writeln('📱 Contact: ${student.contact.isEmpty ? "N/A" : student.contact}');
    buffer.writeln('📍 Address: ${student.address.isEmpty ? "N/A" : student.address}');
    buffer.writeln('📊 Status: ${_getBehaviorName(student.behaviorColor)}');
    if (student.comments.isNotEmpty) {
      buffer.writeln('💬 Comments: ${student.comments}');
    }
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('Sent via EV App');
    return buffer.toString();
  }

  static String _getBehaviorName(int colorIndex) {
    if (colorIndex >= 0 && colorIndex < AppConfig.behaviorColors.length) {
      return AppConfig.behaviorColors[colorIndex].name;
    }
    return 'Not Set';
  }
}
