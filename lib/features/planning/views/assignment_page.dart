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

class _AssignmentsPageState extends State<AssignmentsPage> with SingleTickerProviderStateMixin {
  late StoryService service;
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  List<Story> _stories = [];
  String _searchQuery = '';

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
    _tabController = TabController(length: 4, vsync: this);
    
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

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Story> _getFilteredStories(int tabIndex) {
    List<Story> filtered = _stories;
    
    // Apply tab filter
    if (tabIndex == 1) { // Pending
      filtered = filtered.where((s) => s.assignedTo == null).toList();
    } else if (tabIndex == 2) { // Assigned
      filtered = filtered.where((s) => s.assignedTo != null && s.status != 'approved').toList();
    } else if (tabIndex == 3) { // Approved
      filtered = filtered.where((s) => s.status == 'approved').toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((s) => s.slug.toLowerCase().contains(_searchQuery)).toList();
    }

    return filtered;
  }

  void _assign(Story story, String? reporter) {
    service.assign(story.id, reporter, user: 'planner');
    _showSnackBar('Assigned ${story.slug} to ${reporter ?? "Unassigned"}');
  }

  void _updateStatus(Story story, String status) {
    final updated = story.copyWith(status: status);
    service.save(updated, user: 'planner');
    _showSnackBar('Updated status of ${story.slug} to ${status.toUpperCase()}');
  }

  void _updatePriority(Story story, String priority) {
    service.updatePriority(story.id, priority, user: 'planner');
    _showSnackBar('Set priority of ${story.slug} to ${priority.toUpperCase()}');
  }

  void _deleteStory(Story story) {
    service.delete(story.id);
    _showSnackBar('Deleted story ${story.slug}');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryBlue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        appBar: AppBar(
          toolbarHeight: 70.h,
          backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.8),
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: Text(
              'PLANNING & ASSIGNMENTS',
              style: AppTheme.headingSmall?.copyWith(
                color: Colors.white,
                letterSpacing: 1.2,
                fontSize: 10.sp,
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(80.h),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search stories...',
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(Icons.search, color: Colors.white38),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: AppColors.accentRed,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white38,
                  tabs: const [
                    Tab(text: 'ALL'),
                    Tab(text: 'UNASSIGNED'),
                    Tab(text: 'ASSIGNED'),
                    Tab(text: 'APPROVED'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildStoryList(0),
            _buildStoryList(1),
            _buildStoryList(2),
            _buildStoryList(3),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.accentRed,
          onPressed: () => _showAddStoryDialog(),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStoryList(int tabIndex) {
    final filtered = _getFilteredStories(tabIndex);
    
    if (filtered.isEmpty) {
      return _buildEmptyState();
    }

    return ReorderableListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: filtered.length,
      onReorder: (oldIdx, newIdx) {
        if (newIdx > oldIdx) newIdx -= 1;
        // Map filtered index back to original index if necessary, 
        // but reorder usually works on the full list.
        // For simplicity in this demo, we reorder the service items.
        service.reorder(oldIdx, newIdx);
      },
      itemBuilder: (context, index) {
        final story = filtered[index];
        return _buildAssignmentCard(story, ValueKey(story.id));
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 48.r, color: Colors.white12),
          SizedBox(height: 16.h),
          Text(
            'No matching stories found',
            style: AppTheme.bodyLarge?.copyWith(color: Colors.white24),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Story story, Key key) {
    Color statusColor;
    switch (story.status.toLowerCase()) {
      case 'approved':
        statusColor = AppColors.success;
        break;
      case 'submitted':
        statusColor = AppColors.warning;
        break;
      case 'pending':
        statusColor = Colors.blueAccent;
        break;
      default:
        statusColor = Colors.white54;
    }

    Color priorityColor;
    switch (story.priority.toLowerCase()) {
      case 'urgent':
        priorityColor = AppColors.accentRed;
        break;
      case 'high':
        priorityColor = AppColors.orangeAccent;
        break;
      case 'low':
        priorityColor = AppColors.success;
        break;
      default:
        priorityColor = Colors.white38;
    }

    return Container(
      key: key,
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: story.priority == 'urgent' ? AppColors.accentRed.withValues(alpha: 0.3) : AppColors.glassWhite10,
          width: story.priority == 'urgent' ? 1.5 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: ExpansionTile(
          collapsedIconColor: Colors.white54,
          iconColor: Colors.white,
          title: Row(
            children: [
              Expanded(
                child: Text(
                  story.slug.toUpperCase(),
                  style: AppTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              _buildPriorityBadge(story.priority, priorityColor),
              SizedBox(width: 8.w),
              _buildStatusBadge(story.status, statusColor),
            ],
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Row(
              children: [
                Icon(Icons.person, size: 14.r, color: story.assignedTo != null ? AppColors.success : Colors.white24),
                SizedBox(width: 4.w),
                Text(
                  story.assignedTo ?? 'Unassigned',
                  style: AppTheme.bodySmall?.copyWith(
                    color: story.assignedTo != null ? Colors.white70 : Colors.white24,
                  ),
                ),
              ],
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Colors.white10),
                  SizedBox(height: 8.h),
                  _buildAssignmentDropdown(story),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(child: _buildStatusDropdown(story)),
                      SizedBox(width: 12.w),
                      Expanded(child: _buildPriorityDropdown(story)),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  _buildNotesSection(story),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => _deleteStory(story),
                        icon: const Icon(Icons.delete_outline, color: AppColors.accentRed, size: 18),
                        label: Text('Delete', style: TextStyle(color: AppColors.accentRed, fontSize: 12.sp)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: color, width: 0.5),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTheme.bodySmall?.copyWith(
          color: color,
          fontSize: 9.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(String priority, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag, size: 10.r, color: color),
          SizedBox(width: 4.w),
          Text(
            priority.toUpperCase(),
            style: AppTheme.bodySmall?.copyWith(
              color: color,
              fontSize: 8.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentDropdown(Story story) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ASSIGN TO', style: AppTheme.bodySmall?.copyWith(color: Colors.white38, fontSize: 10.sp)),
        SizedBox(height: 4.h),
        DropdownButtonHideUnderline(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: DropdownButton<String>(
              value: story.assignedTo,
              dropdownColor: AppColors.backgroundCard,
              isExpanded: true,
              hint: const Text('Select Reporter', style: TextStyle(color: Colors.white24)),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white54),
              items: [
                const DropdownMenuItem(value: null, child: Text("Unassigned", style: TextStyle(color: Colors.white38))),
                ..._reporters.map((r) => DropdownMenuItem(
                      value: r,
                      child: Text(r, style: const TextStyle(color: Colors.white)),
                    )),
              ],
              onChanged: (val) => _assign(story, val),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown(Story story) {
    final statuses = ['pending', 'draft', 'submitted', 'approved', 'ready'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('STATUS', style: AppTheme.bodySmall?.copyWith(color: Colors.white38, fontSize: 10.sp)),
        SizedBox(height: 4.h),
        DropdownButtonHideUnderline(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: DropdownButton<String>(
              value: story.status,
              dropdownColor: AppColors.backgroundCard,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white54),
              items: statuses.map((s) => DropdownMenuItem(
                value: s,
                child: Text(s.toUpperCase(), style: const TextStyle(color: Colors.white)),
              )).toList(),
              onChanged: (val) {
                if (val != null) _updateStatus(story, val);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityDropdown(Story story) {
    final priorities = ['low', 'medium', 'high', 'urgent'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PRIORITY', style: AppTheme.bodySmall?.copyWith(color: Colors.white38, fontSize: 10.sp)),
        SizedBox(height: 4.h),
        DropdownButtonHideUnderline(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: DropdownButton<String>(
              value: story.priority,
              dropdownColor: AppColors.backgroundCard,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white54),
              items: priorities.map((p) => DropdownMenuItem(
                value: p,
                child: Text(p.toUpperCase(), style: const TextStyle(color: Colors.white)),
              )).toList(),
              onChanged: (val) {
                if (val != null) _updatePriority(story, val);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(Story story) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('PLANNING NOTES', style: AppTheme.bodySmall?.copyWith(color: Colors.white38, fontSize: 10.sp)),
            GestureDetector(
              onTap: () => _showEditNotesDialog(story),
              child: Icon(Icons.edit, size: 14.r, color: AppColors.orangeAccent),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            story.notes ?? 'No notes added yet...',
            style: AppTheme.bodySmall?.copyWith(
              color: story.notes != null ? Colors.white70 : Colors.white24,
              fontStyle: story.notes != null ? FontStyle.normal : FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  void _showEditNotesDialog(Story story) {
    final ctrl = TextEditingController(text: story.notes);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: const Text('Edit Planning Notes', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: ctrl,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter assignment details...',
            hintStyle: TextStyle(color: Colors.white24),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              service.updateNotes(story.id, ctrl.text, user: 'planner');
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddStoryDialog() {
    final slugCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String? selectedReporter;
    String selectedPriority = 'medium';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.backgroundCard,
          title: const Text('Plan New Story', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: slugCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Story Slug (required)'),
                ),
                SizedBox(height: 16.h),
                DropdownButtonFormField<String>(
                  dropdownColor: AppColors.backgroundCard,
                  initialValue: selectedReporter,
                  decoration: const InputDecoration(labelText: 'Assign To (optional)'),
                  items: _reporters.map((r) => DropdownMenuItem(
                    value: r,
                    child: Text(r, style: const TextStyle(color: Colors.white)),
                  )).toList(),
                  onChanged: (val) => setDialogState(() => selectedReporter = val),
                ),
                SizedBox(height: 16.h),
                DropdownButtonFormField<String>(
                  dropdownColor: AppColors.backgroundCard,
                  initialValue: selectedPriority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: ['low', 'medium', 'high', 'urgent'].map((p) => DropdownMenuItem(
                    value: p,
                    child: Text(p.toUpperCase(), style: const TextStyle(color: Colors.white)),
                  )).toList(),
                  onChanged: (val) => setDialogState(() => selectedPriority = val!),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: notesCtrl,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Initial Notes'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (slugCtrl.text.isNotEmpty) {
                  final story = service.add(slugCtrl.text, user: 'planner');
                  service.updatePriority(story.id, selectedPriority, user: 'planner');
                  if (selectedReporter != null) {
                    service.assign(story.id, selectedReporter, user: 'planner');
                  }
                  if (notesCtrl.text.isNotEmpty) {
                    service.updateNotes(story.id, notesCtrl.text, user: 'planner');
                  }
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
