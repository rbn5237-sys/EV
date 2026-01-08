class ClassModel {
  final int? id;
  final String name;
  final int order;
  DateTime? createdAt;

  ClassModel({
    this.id,
    required this.name,
    required this.order,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'order_index': order,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['id'],
      name: map['name'],
      order: map['order_index'],
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : null,
    );
  }
}
