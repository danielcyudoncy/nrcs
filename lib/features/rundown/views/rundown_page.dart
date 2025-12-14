// features/rundown/views/rundown_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nrcs/core/services/story_service.dart';
import 'package:nrcs/core/models/story.dart';
import 'package:nrcs/core/theme/app_theme.dart';
import 'package:nrcs/core/utils/responsive_utils.dart';
import '../controllers/rundown_controller.dart';
import 'package:nrcs/features/scripts/views/script_editor_page.dart';

class RundownPage extends StatelessWidget {
  const RundownPage({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = Get.put(StoryService());
    final controller = Get.put(RundownController());
    controller.loadSample();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('RUNDOWN CONTROL', style: AppTheme.headingSmall),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha((0.2 * 255).round()),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'LIVE',
                  style: AppTheme.bodySmall?.copyWith(color: Colors.green),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  break;
                case 'refresh':
                  controller.loadSample();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text('Settings', style: AppTheme.bodyMedium),
                ),
              ),
              PopupMenuItem(
                value: 'refresh',
                child: ListTile(
                  leading: const Icon(Icons.refresh),
                  title: Text('Refresh', style: AppTheme.bodyMedium),
                ),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<StoryEvent>(
        stream: svc.stream,
        initialData: StoryEvent(type: StoryEventType.list, list: svc.list()),
        builder: (context, snap) {
          final ev = snap.data!;
          final stories = ev.list ?? svc.list();

          return ResponsiveBuilder(
            builder: (context, deviceType) {
              return Column(
                children: [
                  // Header Stats
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        _buildStatCard(
                          'Total Stories',
                          stories.length.toString(),
                          Icons.article,
                        ),
                        const SizedBox(width: 8),
                        _buildStatCard(
                          'In Progress',
                          stories
                              .where((s) => s.status == 'in_progress')
                              .length
                              .toString(),
                          Icons.pending,
                        ),
                        const SizedBox(width: 8),
                        _buildStatCard(
                          'Ready',
                          stories
                              .where((s) => s.status == 'ready')
                              .length
                              .toString(),
                          Icons.check_circle,
                        ),
                      ],
                    ),
                  ),

                  // Main Content
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: ReorderableListView.builder(
                        itemCount: stories.length,
                        onReorder: (oldIndex, newIndex) {
                          if (newIndex > oldIndex) newIndex -= 1;
                          svc.reorder(oldIndex, newIndex);
                        },
                        itemBuilder: (context, i) {
                          final s = stories[i];
                          return _buildStoryCard(
                            key: ValueKey(s.id),
                            story: s,
                            index: i,
                            onTap: () =>
                                Get.to(() => ScriptEditorPage(story: s)),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withAlpha((0.1 * 255).round()),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.glassBlue, size: 16),
                const SizedBox(width: 6),
                Text(value, style: AppTheme.bodyLarge),
              ],
            ),
            const SizedBox(height: 2),
            Text(title, style: AppTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryCard({
    Key? key,
    required Story story,
    required int index,
    required VoidCallback onTap,
  }) {
    final statusColor = _getStatusColor(story.status);
    final statusIcon = _getStatusIcon(story.status);

    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColors.backgroundCard,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Drag Handle & Order Number
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.drag_indicator,
                        color: Colors.white54,
                        size: 14,
                      ),
                      Text('${story.orderNo}', style: AppTheme.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Story Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.slug,
                        style: AppTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(statusIcon, color: statusColor, size: 12),
                          const SizedBox(width: 3),
                          Text(
                            story.status.toUpperCase(),
                            style: AppTheme.bodySmall?.copyWith(
                              color: statusColor,
                            ),
                          ),
                          if (story.updatedBy != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 3,
                              height: 3,
                              decoration: const BoxDecoration(
                                color: Colors.white54,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'by ${story.updatedBy}',
                              style: AppTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Status Badge & Actions
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha((0.2 * 255).round()),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor, width: 1),
                      ),
                      child: Text(
                        story.status.toUpperCase(),
                        style: AppTheme.bodySmall?.copyWith(color: statusColor),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white54,
                            size: 16,
                          ),
                          onPressed: onTap,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.more_horiz,
                            color: Colors.white54,
                            size: 16,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ready':
        return const Color(0xFF48BB78);
      case 'in_progress':
        return const Color(0xFFFFC107);
      case 'pending':
        return const Color(0xFF6B7280);
      case 'live':
        return const Color(0xFFE53E3E);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'ready':
        return Icons.check_circle;
      case 'in_progress':
        return Icons.pending;
      case 'pending':
        return Icons.schedule;
      case 'live':
        return Icons.radio_button_checked;
      default:
        return Icons.help_outline;
    }
  }
}
