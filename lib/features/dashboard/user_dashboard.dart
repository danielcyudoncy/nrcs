// features/dashboard/user_dashboard.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nrcs/core/auth/token_provider.dart';
import 'package:nrcs/core/auth/auth_service.dart';
import 'package:nrcs/core/models/story.dart';
import 'package:nrcs/core/services/story_service.dart';
import 'package:nrcs/core/theme/app_theme.dart';
import 'package:nrcs/core/utils/responsive_utils.dart';
import 'package:nrcs/features/scripts/views/script_editor_page.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = Get.put(StoryService());

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            Icon(
              TokenProvider.isWriter ? Icons.edit : Icons.tv,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${TokenProvider.isWriter ? 'My Scripts' : 'Broadcast Control'}',
                  style: AppTheme.headingSmall,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _showLogoutDialog(context),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) => _handleMenuAction(value, context),
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
              if (TokenProvider.isWriter) ...[
                PopupMenuItem(
                  value: 'loadDemo',
                  child: ListTile(
                    leading: const Icon(Icons.play_circle),
                    title: Text('Load Demo Data', style: AppTheme.bodyMedium),
                  ),
                ),
              ],
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

          // Filter stories based on user role
          final filteredStories = TokenProvider.isWriter
              ? stories
                    .where((s) => s.updatedBy == TokenProvider.username)
                    .toList()
              : stories.where((s) => s.status == 'ready').toList();

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
                          TokenProvider.isWriter
                              ? 'My Scripts'
                              : 'Ready Scripts',
                          filteredStories.length.toString(),
                          TokenProvider.isWriter
                              ? Icons.edit
                              : Icons.check_circle,
                        ),
                        const SizedBox(width: 8),
                        _buildStatCard(
                          'In Progress',
                          stories
                              .where(
                                (s) =>
                                    s.status == 'in_progress' &&
                                    (TokenProvider.isWriter
                                        ? s.updatedBy == TokenProvider.username
                                        : true),
                              )
                              .length
                              .toString(),
                          Icons.pending,
                        ),
                        const SizedBox(width: 8),
                        _buildStatCard(
                          'Ready',
                          stories
                              .where(
                                (s) =>
                                    s.status == 'ready' &&
                                    (TokenProvider.isWriter
                                        ? s.updatedBy == TokenProvider.username
                                        : true),
                              )
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
                      child: filteredStories.isEmpty
                          ? _buildEmptyState(context)
                          : TokenProvider.isWriter
                          ? _buildWriterList(svc, filteredStories)
                          : _buildCasterList(svc, filteredStories),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: TokenProvider.isWriter
          ? FloatingActionButton(
              onPressed: () => _createNewScript(context),
              backgroundColor: AppColors.buttonPrimary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            TokenProvider.isWriter ? Icons.edit_note : Icons.tv,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            TokenProvider.isWriter ? 'No scripts yet' : 'No ready scripts',
            style: AppTheme.headingSmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            TokenProvider.isWriter
                ? 'Create your first script to get started'
                : 'Scripts will appear here when marked as ready',
            style: AppTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          if (TokenProvider.isWriter)
            ElevatedButton.icon(
              onPressed: () => _createNewScript(context),
              icon: const Icon(Icons.add),
              label: const Text('Create Script'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonPrimary,
                foregroundColor: AppColors.textPrimary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWriterList(StoryService svc, List<Story> stories) {
    return ReorderableListView.builder(
      itemCount: stories.length,
      onReorder: (oldIndex, newIndex) {
        if (newIndex > oldIndex) newIndex -= 1;
        svc.reorder(oldIndex, newIndex);
      },
      itemBuilder: (context, i) {
        final s = stories[i];
        return _buildScriptCard(
          key: ValueKey(s.id),
          story: s,
          index: i,
          onTap: () => Get.to(() => ScriptEditorPage(story: s)),
          onStatusChange: (newStatus) => _updateScriptStatus(svc, s, newStatus),
        );
      },
    );
  }

  Widget _buildCasterList(StoryService svc, List<Story> stories) {
    return ListView.builder(
      itemCount: stories.length,
      itemBuilder: (context, i) {
        final s = stories[i];
        return _buildBroadcastCard(
          key: ValueKey(s.id),
          story: s,
          index: i,
          onTap: () => Get.to(() => ScriptEditorPage(story: s)),
        );
      },
    );
  }

  Widget _buildScriptCard({
    Key? key,
    required Story story,
    required int index,
    required VoidCallback onTap,
    required Function(String) onStatusChange,
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
                          onPressed: () =>
                              _showScriptMenu(story, onStatusChange),
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

  Widget _buildBroadcastCard({
    Key? key,
    required Story story,
    required int index,
    required VoidCallback onTap,
  }) {
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
                // Live Indicator
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
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
                      Text(
                        'Ready for broadcast',
                        style: AppTheme.bodySmall?.copyWith(
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                // Actions
                IconButton(
                  icon: const Icon(
                    Icons.play_circle,
                    color: Colors.green,
                    size: 24,
                  ),
                  onPressed: () => _startBroadcast(story),
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

  void _createNewScript(BuildContext context) {
    // Create a new script
    final svc = Get.find<StoryService>();
    final newStory = Story(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      slug: 'New Script',
      orderNo: svc.list().length + 1,
      status: 'draft',
      updatedBy: TokenProvider.username,
    );
    svc.save(newStory, user: TokenProvider.username!);
  }

  void _updateScriptStatus(StoryService svc, Story story, String newStatus) {
    final updatedStory = story.copyWith(status: newStatus);
    svc.save(updatedStory, user: TokenProvider.username!);
  }

  void _showScriptMenu(Story story, Function(String) onStatusChange) {
    // Show status change menu
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: Text('Script Options', style: AppTheme.bodyLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Script'),
              onTap: () {
                Get.back();
                Get.to(() => ScriptEditorPage(story: story));
              },
            ),
            ListTile(
              leading: const Icon(Icons.pending),
              title: const Text('Mark as Pending'),
              onTap: () {
                Get.back();
                onStatusChange('pending');
              },
            ),
            ListTile(
              leading: const Icon(Icons.hourglass_empty),
              title: const Text('Mark as In Progress'),
              onTap: () {
                Get.back();
                onStatusChange('in_progress');
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Mark as Ready'),
              onTap: () {
                Get.back();
                onStatusChange('ready');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Script'),
              onTap: () {
                Get.back();
                _confirmDelete(story);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Story story) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: Text('Delete Script', style: AppTheme.bodyLarge),
        content: Text(
          'Are you sure you want to delete "${story.slug}"?',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final svc = Get.find<StoryService>();
              svc.delete(story.id);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _startBroadcast(Story story) {
    // Start broadcasting this script
    Get.snackbar(
      'Broadcast Started',
      'Now broadcasting: ${story.slug}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _handleMenuAction(String action, BuildContext context) {
    switch (action) {
      case 'profile':
        _showProfileDialog(context);
        break;
      case 'settings':
        _showSettingsDialog(context);
        break;
      case 'loadDemo':
        final svc = Get.find<StoryService>();
        svc.loadDemoData();
        break;
    }
  }

  void _showProfileDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: Text('User Profile', style: AppTheme.bodyLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username: ${TokenProvider.username}',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Role: ${TokenProvider.currentRole?.name ?? "Unknown"}',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text('Permissions:', style: AppTheme.bodyMedium),
            ...TokenProvider.roles.map(
              (role) => Text('• $role', style: AppTheme.bodySmall),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: Text('Settings', style: AppTheme.bodyLarge),
        content: const Text('Settings panel coming soon...'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: Text('Logout', style: AppTheme.bodyLarge),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final authService = AuthService(Get.find());
              authService.logout();
              Get.offAllNamed('/login');
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
