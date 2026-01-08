import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../config/app_config.dart';
import '../config/localization.dart';
import '../widgets/roll_card.dart';
import '../widgets/filter_chip.dart' as custom;

class ClassScreen extends StatefulWidget {
  final String className;
  final int classId;

  const ClassScreen({
    super.key,
    required this.className,
    required this.classId,
  });

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<StudentProvider>(context, listen: false);
      provider.clearColorFilter();
      provider.clearSearch();
      provider.loadStudentsByClass(widget.classId);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF1a1a2e), const Color(0xFF16213e)]
                : [const Color(0xFFe3f2fd), const Color(0xFFbbdefb)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isDark),
              _buildFilterBar(context),
              if (_showSearch) _buildSearchBar(context, isDark),
              Expanded(
                child: Consumer<StudentProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (provider.currentClassStudents.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_off_outlined,
                              size: 80,
                              color: isDark ? Colors.white30 : Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              context.tr('no_students'),
                              style: TextStyle(
                                fontSize: 18,
                                color: isDark ? Colors.white70 : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return AnimationLimiter(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.currentClassStudents.length,
                        itemBuilder: (context, index) {
                          final student = provider.currentClassStudents[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 400),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: RollCard(
                                  student: student,
                                  className: widget.className,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/student',
                                      arguments: {
                                        'rollNumber': student.rollNumber,
                                        'classId': widget.classId,
                                        'className': widget.className,
                                        'studentId': student.id,
                                      },
                                    );
                                  },
                                  onDelete: () => _deleteRollNumber(student.rollNumber),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFAB(context),
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
              onPressed: () => Navigator.pop(context),
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
                  widget.className,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1a237e),
                  ),
                ),
                Consumer<StudentProvider>(
                  builder: (context, provider, child) {
                    return Text(
                      '${provider.currentClassStudents.length} ${context.tr('students')}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : const Color(0xFF5c6bc0),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : const Color(0xFF1a237e).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _showSearch = !_showSearch;
                  if (!_showSearch) {
                    _searchController.clear();
                    Provider.of<StudentProvider>(context, listen: false).clearSearch();
                  }
                });
              },
              icon: Icon(
                _showSearch ? Icons.search_off : Icons.search,
                color: isDark ? Colors.white : const Color(0xFF1a237e),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : const Color(0xFF1a237e).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/export', arguments: {
                  'classId': widget.classId,
                  'className': widget.className,
                });
              },
              icon: Icon(
                Icons.file_download_outlined,
                color: isDark ? Colors.white : const Color(0xFF1a237e),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: -0.1, end: 0);
  }

  Widget _buildFilterBar(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              custom.FilterChipWidget(
                label: context.tr('all'),
                isSelected: provider.selectedColorFilter == -1,
                onTap: () => provider.clearColorFilter(),
              ),
              const SizedBox(width: 8),
              ...List.generate(
                AppConfig.behaviorColors.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: custom.FilterChipWidget(
                    label: AppConfig.behaviorColors[index].name,
                    color: Color(AppConfig.behaviorColors[index].color),
                    isSelected: provider.selectedColorFilter == index,
                    onTap: () => provider.setColorFilter(index),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          Provider.of<StudentProvider>(context, listen: false).setSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: context.tr('search'),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    Provider.of<StudentProvider>(context, listen: false).clearSearch();
                  },
                )
              : null,
        ),
      ),
    ).animate().fadeIn().slideY(begin: -0.5, end: 0);
  }

  Widget _buildFAB(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<int>(
          future: provider.getCustomRollCount(widget.classId),
          builder: (context, snapshot) {
            final customCount = snapshot.data ?? 0;
            if (customCount >= 5) return const SizedBox.shrink();

            return FloatingActionButton.extended(
              onPressed: () => _addCustomRoll(),
              icon: const Icon(Icons.add),
              label: Text(context.tr('add_roll')),
            ).animate().scale(delay: 500.ms);
          },
        );
      },
    );
  }

  Future<void> _addCustomRoll() async {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    final success = await provider.addCustomRollNumber(widget.classId);

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum 5 custom roll numbers allowed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteRollNumber(int rollNumber) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('delete_roll')),
        content: Text(context.tr('confirm_delete')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.tr('no')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.tr('yes')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final provider = Provider.of<StudentProvider>(context, listen: false);
      await provider.deleteRollNumber(widget.classId, rollNumber);
    }
  }
}
