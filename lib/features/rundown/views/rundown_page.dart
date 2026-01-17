// features/rundown/views/rundown_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nrcs/core/auth/token_provider.dart';
import 'package:nrcs/core/services/story_service.dart';
import 'package:nrcs/core/models/story.dart';
import 'package:nrcs/core/theme/app_theme.dart';
import 'package:nrcs/core/utils/responsive_utils.dart';
import 'package:nrcs/features/rundown/views/settings_page.dart';
import 'package:nrcs/features/scripts/views/script_editor_page.dart';

class RundownPage extends StatelessWidget {
  const RundownPage({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = Get.put(StoryService());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
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
                child: Text(
                  'RUNDOWN CONTROL',
                  style: AppTheme.headingSmall?.copyWith(
                    color: Theme.of(context).appBarTheme.foregroundColor,
                  ),
                ),
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
          if (!TokenProvider.isAnchor)
            IconButton(
              icon: Icon(
                Icons.add,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
              onPressed: () => Get.toNamed('/create-story'),
            ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  Get.to(() => const SettingsPage());
                  break;
                case 'refresh':
                  svc.refresh();
                  break;
                case 'loadDemo':
                  svc.loadDemoData();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text('Profile', style: AppTheme.bodyMedium),
                ),
              ),
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
              PopupMenuItem(
                value: 'loadDemo',
                child: ListTile(
                  leading: const Icon(Icons.play_circle),
                  title: Text('Load Demo Data', style: AppTheme.bodyMedium),
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
                          context,
                          'Total Stories',
                          stories.length.toString(),
                          Icons.article,
                        ),
                        const SizedBox(width: 8),
                        _buildStatCard(
                          context,
                          'In Progress',
                          stories
                              .where((s) => s.status == 'in_progress')
                              .length
                              .toString(),
                          Icons.pending,
                        ),
                        const SizedBox(width: 8),
                        _buildStatCard(
                          context,
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
                      child: stories.isEmpty
                          ? _buildEmptyState(context)
                          : (TokenProvider.isEditor ||
                                TokenProvider.isProducer ||
                                TokenProvider.isAdmin)
                          ? ReorderableListView.builder(
                              itemCount: stories.length,
                              onReorder: (oldIndex, newIndex) {
                                if (newIndex > oldIndex) newIndex -= 1;
                                svc.reorder(oldIndex, newIndex);
                              },
                              itemBuilder: (context, i) {
                                final s = stories[i];
                                return _buildStoryCard(
                                  key: ValueKey(s.id),
                                  context: context,
                                  story: s,
                                  index: i,
                                  onTap: () =>
                                      Get.to(() => ScriptEditorPage(story: s)),
                                );
                              },
                            )
                          : ListView.builder(
                              itemCount: stories.length,
                              itemBuilder: (context, i) {
                                final s = stories[i];
                                return _buildStoryCard(
                                  key: ValueKey(s.id),
                                  context: context,
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(179),
          ),
          const SizedBox(height: 16),
          Text(
            'No stories yet',
            style: AppTheme.headingSmall?.copyWith(
              color: Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withAlpha(179),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first story or load demo data',
            style: AppTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withAlpha(179),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              final svc = Get.find<StoryService>();
              svc.loadDemoData();
            },
            icon: const Icon(Icons.play_circle),
            label: const Text('Load Demo Data'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonPrimary,
              foregroundColor: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.glassBlue, size: 16),
                const SizedBox(width: 6),
                Text(
                  value,
                  style: AppTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: AppTheme.bodySmall?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryCard({
    Key? key,
    required BuildContext context,
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
        color: Theme.of(context).cardTheme.color,
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
                        style: AppTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
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
                              style: AppTheme.bodySmall?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.color,
                              ),
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
