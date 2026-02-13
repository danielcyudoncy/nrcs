// features/planning/views/assignment_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nrcs/core/models/story.dart';
import 'package:nrcs/core/services/story_service.dart';
import 'package:nrcs/core/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  late StoryService service;
  List<Story> _stories = [];
  final List<String> _reporters = [
    'Reporter 1',
    'Reporter 2',
    'Reporter 3',
    'Anchor 1',
    'Editor 1'
  ];

  @override
  void initState() {
    super.initState();
    service = Get.find<StoryService>();
    // Initial load
    _stories = service.list();
    // Listen for updates
    service.stream.listen((event) {
      if (mounted) {
        setState(() {
          _stories = service.list(); // Re-fetch list
        });
      }
    });
  }

  void _assign(Story story, String? reporter) {
    service.assign(story.id, reporter, user: 'planner');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Assigned ${story.slug} to ${reporter ?? "Unassigned"}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryBlue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.8),
        elevation: 0,
        title: Text(
          'DAILY ASSIGNMENTS',
          style: AppTheme.headingSmall?.copyWith(
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => setState(() => _stories = service.list()),
          ),
        ],
      ),
      body: _stories.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.all(16.r),
              itemCount: _stories.length,
              itemBuilder: (context, index) {
                final story = _stories[index];
                return _buildAssignmentCard(story);
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accentRed,
        onPressed: () => _showAddStoryDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 32.r, color: Colors.white24),
          SizedBox(height: 16.h),
          Text(
            'No assignments planned yet',
            style: AppTheme.bodyLarge?.copyWith(color: Colors.white54),
          ),
          SizedBox(height: 8.h),
          ElevatedButton(
            onPressed: () => _showAddStoryDialog(),
            child: const Text('Plan New Story'),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Story story) {
    Color statusColor;
    switch (story.status.toLowerCase()) {
      case 'approved':
        statusColor = AppColors.success;
        break;
      case 'submitted':
        statusColor = AppColors.warning;
        break;
      default:
        statusColor = Colors.white54;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.glassWhite10,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    story.slug.toUpperCase(),
                    style: AppTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: statusColor, width: 0.5),
                  ),
                  child: Text(
                    story.status.toUpperCase(),
                    style: AppTheme.bodySmall?.copyWith(
                      color: statusColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(Icons.person_outline, size: 16.r, color: Colors.white54),
                SizedBox(width: 8.w),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: story.assignedTo,
                      dropdownColor: AppColors.backgroundCard,
                      isExpanded: true,
                      hint: Text(
                        'Unassigned',
                        style: AppTheme.bodyMedium?.copyWith(
                          color: Colors.white38,
                        ),
                      ),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white54),
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text(
                            "Unassigned",
                            style: AppTheme.bodyMedium?.copyWith(
                              color: Colors.white38,
                            ),
                          ),
                        ),
                        ..._reporters.map((r) => DropdownMenuItem(
                              value: r,
                              child: Text(
                                r,
                                style: AppTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            )),
                      ],
                      onChanged: (val) => _assign(story, val),
                    ),
                  ),
                ),
              ],
            ),
            if (story.notes != null && story.notes!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.note_alt_outlined, size: 16.r, color: AppColors.orangeAccent),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      story.notes!,
                      style: AppTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAddStoryDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: Text(
          'Plan New Story',
          style: AppTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
        content: TextField(
          controller: ctrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Story Slug',
            hintText: 'Enter story title',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.isNotEmpty) {
                service.add(ctrl.text, user: 'planner');
                Navigator.pop(ctx);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
