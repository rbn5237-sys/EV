import 'package:flutter/material.dart';
import '../models/class_model.dart';

class ClassCard extends StatelessWidget {
  final ClassModel classModel;
  final int index;
  final VoidCallback onTap;

  const ClassCard({
    super.key,
    required this.classModel,
    required this.index,
    required this.onTap,
  });

  Color _getCardColor(int index) {
    final colors = [
      const Color(0xFF1a237e),
      const Color(0xFF283593),
      const Color(0xFF303f9f),
      const Color(0xFF3949ab),
      const Color(0xFF0d47a1),
      const Color(0xFF1565c0),
      const Color(0xFF1976d2),
      const Color(0xFF1e88e5),
      const Color(0xFF004d40),
      const Color(0xFF00695c),
      const Color(0xFF00796b),
      const Color(0xFF00897b),
    ];
    return colors[index % colors.length];
  }

  IconData _getClassIcon(String className) {
    if (className.startsWith('FE')) return Icons.school;
    if (className.startsWith('SE')) return Icons.menu_book;
    if (className.startsWith('DE')) return Icons.architecture;
    return Icons.class_;
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = _getCardColor(index);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cardColor,
                cardColor.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: cardColor.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  _getClassIcon(classModel.name),
                  size: 100,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getClassIcon(classModel.name),
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classModel.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '50+ Students',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
