class AppConfig {
  static const String appName = 'EV';
  static const String appVersion = '1.0.0';
  
  static const List<String> classes = [
    'FE-1', 'FE-2', 'FE-3', 'FE-4',
    'SE-1', 'SE-2', 'SE-3', 'SE-4',
    'DE-1', 'DE-2', 'DE-3', 'DE-4',
  ];
  
  static const int fixedRollNumbers = 50;
  static const int customRollNumbers = 5;
  
  static const List<BehaviorColor> behaviorColors = [
    BehaviorColor(name: 'Excellent', color: 0xFF4CAF50, nameUrdu: 'بہترین'),
    BehaviorColor(name: 'Good', color: 0xFF2196F3, nameUrdu: 'اچھا'),
    BehaviorColor(name: 'Average', color: 0xFFFFEB3B, nameUrdu: 'اوسط'),
    BehaviorColor(name: 'Needs Improvement', color: 0xFFFF9800, nameUrdu: 'بہتری کی ضرورت'),
    BehaviorColor(name: 'Critical', color: 0xFFF44336, nameUrdu: 'تشویشناک'),
  ];
}

class BehaviorColor {
  final String name;
  final int color;
  final String nameUrdu;
  
  const BehaviorColor({
    required this.name,
    required this.color,
    required this.nameUrdu,
  });
}
