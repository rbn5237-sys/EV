import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../models/student.dart';
import '../config/app_config.dart';
import '../config/localization.dart';
import '../widgets/color_selector.dart';
import '../widgets/contact_actions.dart';
import '../services/export_service.dart';
import '../services/share_service.dart';

class StudentScreen extends StatefulWidget {
  final int rollNumber;
  final int classId;
  final String className;
  final int? studentId;

  const StudentScreen({
    super.key,
    required this.rollNumber,
    required this.classId,
    required this.className,
    this.studentId,
  });

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  final _commentsController = TextEditingController();
  
  int _selectedColor = -1;
  bool _isEditing = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadStudent();
  }

  Future<void> _loadStudent() async {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    await provider.loadStudentByRoll(widget.classId, widget.rollNumber);
    
    final student = provider.currentStudent;
    if (student != null) {
      setState(() {
        _nameController.text = student.name;
        _fatherNameController.text = student.fatherName;
        _contactController.text = student.contact;
        _addressController.text = student.address;
        _commentsController.text = student.comments;
        _selectedColor = student.behaviorColor;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor(bool isDark) {
    if (_selectedColor >= 0 && _selectedColor < AppConfig.behaviorColors.length) {
      return Color(AppConfig.behaviorColors[_selectedColor].color).withOpacity(0.15);
    }
    return isDark ? const Color(0xFF1a1a2e) : const Color(0xFFe3f2fd);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = _getBackgroundColor(isDark);

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroundColor,
              isDark ? const Color(0xFF16213e) : const Color(0xFFbbdefb),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isDark),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRollNumberCard(isDark),
                        const SizedBox(height: 24),
                        ColorSelector(
                          selectedIndex: _selectedColor,
                          onColorSelected: (index) {
                            setState(() {
                              _selectedColor = index;
                              _hasChanges = true;
                            });
                          },
                        ).animate().fadeIn(delay: 100.ms),
                        const SizedBox(height: 24),
                        _buildFormFields(isDark),
                        const SizedBox(height: 24),
                        if (_contactController.text.isNotEmpty)
                          ContactActions(
                            contact: _contactController.text,
                            student: _getCurrentStudent(),
                            className: widget.className,
                          ).animate().fadeIn(delay: 300.ms),
                        const SizedBox(height: 24),
                        _buildActionButtons(context, isDark),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : const Color(0xFF1a237e).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                if (_hasChanges) {
                  _showUnsavedChangesDialog(context);
                } else {
                  Navigator.pop(context);
                }
              },
              icon: Icon(
                Icons.arrow_back_rounded,
                color: isDark ? Colors.white : const Color(0xFF1a237e),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${context.tr('roll_number')} ${widget.rollNumber}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1a237e),
                  ),
                ),
                Text(
                  widget.className,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : const Color(0xFF5c6bc0),
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: isDark ? Colors.white : const Color(0xFF1a237e),
            ),
            onSelected: (value) async {
              switch (value) {
                case 'export_json':
                  await _exportStudent('json');
                  break;
                case 'export_pdf':
                  await _exportStudent('pdf');
                  break;
                case 'share':
                  await _shareStudent();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'export_json',
                child: Row(
                  children: [
                    const Icon(Icons.code),
                    const SizedBox(width: 12),
                    Text('Export JSON'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'export_pdf',
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf),
                    const SizedBox(width: 12),
                    Text('Export PDF'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    const Icon(Icons.share),
                    const SizedBox(width: 12),
                    Text(context.tr('share')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: -0.1, end: 0);
  }

  Widget _buildRollNumberCard(bool isDark) {
    Color cardColor = isDark ? const Color(0xFF2d2d44) : Colors.white;
    if (_selectedColor >= 0 && _selectedColor < AppConfig.behaviorColors.length) {
      cardColor = Color(AppConfig.behaviorColors[_selectedColor].color);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${widget.rollNumber}',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _selectedColor >= 0 ? Colors.white : (isDark ? Colors.white : const Color(0xFF1a237e)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _nameController.text.isNotEmpty ? _nameController.text : context.tr('tap_to_add'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: _selectedColor >= 0 ? Colors.white : (isDark ? Colors.white : const Color(0xFF1a237e)),
            ),
            textAlign: TextAlign.center,
          ),
          if (_fatherNameController.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'S/O ${_fatherNameController.text}',
              style: TextStyle(
                fontSize: 14,
                color: _selectedColor >= 0 ? Colors.white70 : (isDark ? Colors.white70 : Colors.grey[600]),
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }

  Widget _buildFormFields(bool isDark) {
    return Column(
      children: [
        _buildTextField(
          controller: _nameController,
          label: context.tr('name'),
          icon: Icons.person_outline,
          isDark: isDark,
        ).animate().fadeIn(delay: 150.ms).slideX(begin: 0.1, end: 0),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _fatherNameController,
          label: context.tr('father_name'),
          icon: Icons.person_outline,
          isDark: isDark,
        ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1, end: 0),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _contactController,
          label: context.tr('contact'),
          icon: Icons.phone_outlined,
          isDark: isDark,
          keyboardType: TextInputType.phone,
        ).animate().fadeIn(delay: 250.ms).slideX(begin: 0.1, end: 0),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _addressController,
          label: context.tr('address'),
          icon: Icons.location_on_outlined,
          isDark: isDark,
          maxLines: 2,
        ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1, end: 0),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _commentsController,
          label: context.tr('comments'),
          icon: Icons.comment_outlined,
          isDark: isDark,
          maxLines: 3,
        ).animate().fadeIn(delay: 350.ms).slideX(begin: 0.1, end: 0),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: (_) {
        setState(() {
          _hasChanges = true;
        });
      },
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
            color: _selectedColor >= 0
                ? Color(AppConfig.behaviorColors[_selectedColor].color)
                : const Color(0xFF1a237e),
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            label: Text(context.tr('cancel')),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _saveStudent,
            icon: const Icon(Icons.save),
            label: Text(context.tr('save')),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: _selectedColor >= 0
                  ? Color(AppConfig.behaviorColors[_selectedColor].color)
                  : const Color(0xFF1a237e),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0);
  }

  Student _getCurrentStudent() {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    return Student(
      id: provider.currentStudent?.id,
      classId: widget.classId,
      rollNumber: widget.rollNumber,
      name: _nameController.text,
      fatherName: _fatherNameController.text,
      contact: _contactController.text,
      address: _addressController.text,
      comments: _commentsController.text,
      behaviorColor: _selectedColor,
    );
  }

  Future<void> _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<StudentProvider>(context, listen: false);
      final student = _getCurrentStudent();
      
      final success = await provider.saveStudent(student);
      
      if (success && mounted) {
        setState(() {
          _hasChanges = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr('saved')),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _exportStudent(String format) async {
    final student = _getCurrentStudent();
    
    if (format == 'json') {
      await ExportService.exportStudentToJson(student, widget.className);
    } else {
      await ExportService.exportStudentToPdf(student, widget.className);
    }
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('exported')),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _shareStudent() async {
    final student = _getCurrentStudent();
    await ShareService.shareStudent(student, widget.className);
  }

  void _showUnsavedChangesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Unsaved Changes'),
        content: Text('You have unsaved changes. Do you want to save before leaving?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Discard'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _saveStudent();
              if (mounted) Navigator.pop(context);
            },
            child: Text(context.tr('save')),
          ),
        ],
      ),
    );
  }
}
