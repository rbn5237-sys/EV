import 'package:flutter/material.dart';
import '../config/localization.dart';

class StudentForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController fatherNameController;
  final TextEditingController contactController;
  final TextEditingController addressController;
  final TextEditingController commentsController;
  final bool isDark;
  final Color accentColor;
  final Function(String) onFieldChanged;

  const StudentForm({
    super.key,
    required this.nameController,
    required this.fatherNameController,
    required this.contactController,
    required this.addressController,
    required this.commentsController,
    required this.isDark,
    required this.accentColor,
    required this.onFieldChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField(
          context: context,
          controller: nameController,
          label: context.tr('name'),
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          context: context,
          controller: fatherNameController,
          label: context.tr('father_name'),
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          context: context,
          controller: contactController,
          label: context.tr('contact'),
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          context: context,
          controller: addressController,
          label: context.tr('address'),
          icon: Icons.location_on_outlined,
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          context: context,
          controller: commentsController,
          label: context.tr('comments'),
          icon: Icons.comment_outlined,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onFieldChanged,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: isDark ? Colors.white70 : const Color(0xFF5c6bc0),
        ),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: accentColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}
