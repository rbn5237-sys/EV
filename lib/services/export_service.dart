import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/student.dart';
import '../config/app_config.dart';

class ExportService {
  static Future<String> exportToJson(Map<String, dynamic> data, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName.json');
    await file.writeAsString(jsonEncode(data));
    return file.path;
  }

  static Future<String> exportStudentToJson(Student student, String className) async {
    final data = {
      'exportDate': DateTime.now().toIso8601String(),
      'className': className,
      'student': student.toJson(),
    };
    return await exportToJson(data, 'student_${student.rollNumber}_export');
  }

  static Future<String> exportStudentToPdf(Student student, String className) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Student Information',
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              _buildPdfRow('Class', className),
              _buildPdfRow('Roll Number', '${student.rollNumber}'),
              _buildPdfRow('Name', student.name.isEmpty ? 'N/A' : student.name),
              _buildPdfRow('Father Name', student.fatherName.isEmpty ? 'N/A' : student.fatherName),
              _buildPdfRow('Contact', student.contact.isEmpty ? 'N/A' : student.contact),
              _buildPdfRow('Address', student.address.isEmpty ? 'N/A' : student.address),
              _buildPdfRow('Behavior', _getBehaviorName(student.behaviorColor)),
              _buildPdfRow('Comments', student.comments.isEmpty ? 'N/A' : student.comments),
              pw.SizedBox(height: 30),
              pw.Text(
                'Generated on: ${DateTime.now().toString().split('.')[0]}',
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
              ),
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/student_${student.rollNumber}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  static Future<String> exportClassToPdf(Map<String, dynamic> data) async {
    final pdf = pw.Document();
    final className = data['class']['name'] ?? 'Unknown';
    final students = (data['students'] as List).map((s) => Student.fromMap(s)).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('Class Report: $className',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Total Students: ${students.length}'),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['Roll', 'Name', 'Father', 'Contact', 'Status'],
              data: students.map((s) => [
                '${s.rollNumber}',
                s.name.isEmpty ? '-' : s.name,
                s.fatherName.isEmpty ? '-' : s.fatherName,
                s.contact.isEmpty ? '-' : s.contact,
                _getBehaviorName(s.behaviorColor),
              ]).toList(),
            ),
          ];
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/class_${className}_report.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  static Future<String> exportAllToPdf(Map<String, dynamic> data) async {
    final pdf = pw.Document();
    final classes = data['classes'] as List;
    final students = (data['students'] as List).map((s) => Student.fromMap(s)).toList();

    for (var classData in classes) {
      final classId = classData['id'];
      final className = classData['name'];
      final classStudents = students.where((s) => s.classId == classId).toList();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text('Class: $className',
                    style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Students: ${classStudents.length}'),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['Roll', 'Name', 'Father', 'Contact', 'Status'],
                data: classStudents.map((s) => [
                  '${s.rollNumber}',
                  s.name.isEmpty ? '-' : s.name,
                  s.fatherName.isEmpty ? '-' : s.fatherName,
                  s.contact.isEmpty ? '-' : s.contact,
                  _getBehaviorName(s.behaviorColor),
                ]).toList(),
              ),
            ];
          },
        ),
      );
    }

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/full_export_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  static pw.Widget _buildPdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value),
          ),
        ],
      ),
    );
  }

  static String _getBehaviorName(int colorIndex) {
    if (colorIndex >= 0 && colorIndex < AppConfig.behaviorColors.length) {
      return AppConfig.behaviorColors[colorIndex].name;
    }
    return 'Not Set';
  }
}
