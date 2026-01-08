class Student {
  final int? id;
  final int classId;
  final int rollNumber;
  final bool isCustom;
  String name;
  String fatherName;
  String contact;
  String address;
  String comments;
  int behaviorColor;
  DateTime? createdAt;
  DateTime? updatedAt;

  Student({
    this.id,
    required this.classId,
    required this.rollNumber,
    this.isCustom = false,
    this.name = '',
    this.fatherName = '',
    this.contact = '',
    this.address = '',
    this.comments = '',
    this.behaviorColor = 0,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'class_id': classId,
      'roll_number': rollNumber,
      'is_custom': isCustom ? 1 : 0,
      'name': name,
      'father_name': fatherName,
      'contact': contact,
      'address': address,
      'comments': comments,
      'behavior_color': behaviorColor,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      classId: map['class_id'],
      rollNumber: map['roll_number'],
      isCustom: map['is_custom'] == 1,
      name: map['name'] ?? '',
      fatherName: map['father_name'] ?? '',
      contact: map['contact'] ?? '',
      address: map['address'] ?? '',
      comments: map['comments'] ?? '',
      behaviorColor: map['behavior_color'] ?? 0,
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : null,
      updatedAt: map['updated_at'] != null 
          ? DateTime.parse(map['updated_at']) 
          : null,
    );
  }

  Student copyWith({
    int? id,
    int? classId,
    int? rollNumber,
    bool? isCustom,
    String? name,
    String? fatherName,
    String? contact,
    String? address,
    String? comments,
    int? behaviorColor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      rollNumber: rollNumber ?? this.rollNumber,
      isCustom: isCustom ?? this.isCustom,
      name: name ?? this.name,
      fatherName: fatherName ?? this.fatherName,
      contact: contact ?? this.contact,
      address: address ?? this.address,
      comments: comments ?? this.comments,
      behaviorColor: behaviorColor ?? this.behaviorColor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classId': classId,
      'rollNumber': rollNumber,
      'isCustom': isCustom,
      'name': name,
      'fatherName': fatherName,
      'contact': contact,
      'address': address,
      'comments': comments,
      'behaviorColor': behaviorColor,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String getSummary(String className) {
    return '''
Name: $name
Roll: $rollNumber
Class: $className
Status: ${_getBehaviorName()}
Comment: $comments
''';
  }

  String _getBehaviorName() {
    switch (behaviorColor) {
      case 0: return 'Excellent';
      case 1: return 'Good';
      case 2: return 'Average';
      case 3: return 'Needs Improvement';
      case 4: return 'Critical';
      default: return 'Not Set';
    }
  }
}
